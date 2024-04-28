// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Callable

public var defaultComponents: URLComponents = .init()
public var defaultPath: String = ""
public var defaultContentType: String = ""

/// **What is it**: 
///     `Request` is a type intended to be shared on both client and server side to create strong contracts
///
/// **Problem `Request` solves**:
///     Instead of creating a path on the server side, converting types back and forth with `JSON`, creating swagger documents,
///     Then meetings with server side and client side devs to "sync" up, and errors where incorrect payloads are sent to
///     to the server, and client side devs are unsure exactly what values are required by the server side, and not sure what to
///     expect as a response.
///
/// **Set up**:
///     - Import `StrongContractClient` into both the client side app and the server side project.
///
/// **How to use**:
///     1. Create an instance of `Request` assigning the type of the payload you want to send from client to server `Payload` and
///     the type you intend for the server to respond back with `Response`.  Suppose we call our instance of request: `register`
///     2. Make a call to `task` on the client side with your instance: `Request.register.task(` The method will know what payload
///     and response types thanks to the Swift Compiler's Generic type inference.
///     3. Make a call to `registerHandler` on the server side with your instance: `Request.register.registerHandler(`
///     The method will know what payload and response types thanks to the Swift Compiler's Generic type inference.
///
/// **How to modify**:
///     *Change to the payload the client sends and the server side receives*:  Simply make a change to the `Payload` type
///     assigned to your request. merge the changes, create a release, then both client and server update packages.
///     *Change to the response the server sends and the client side receives*:  Simply make a change to the `Response` type
///     assigned to your request, merge the changes, create a release, then both client and server update packages.
///
public struct Request<Payload: Codable, Response: Codable> {

    public var path: String
    public var method: HTTPMethod
    public var baseComponents: URLComponents = defaultComponents
    public var initialPath: String = defaultPath
    public var contentType: String = defaultContentType

    public init(
        path: String,
        method: HTTPMethod,
        baseComponents: URLComponents = defaultComponents,
        initialPath: String = defaultPath,
        contentType: String = defaultContentType
    ) {
        self.path = path
        self.method = method
        self.baseComponents = baseComponents
        self.initialPath = initialPath
        self.contentType = contentType
    }

    public typealias PassResponse = (Response?) -> Void

    /// This is made to be a force unwrap so that the user of this framework may write unit tests.
    public func urlRequest(payload: Payload?) throws -> URLRequest {
        // Combine the base components with the initial and specific path
        var components = baseComponents
        let fullPath = "/\(initialPath)/\(path)".replacingOccurrences(of: "//", with: "/")
        // Ensures no leading double slashes
        components.path = fullPath

        // Attempt to validate the URL and create the URLRequest

        let url = try components.urlAndValidate()
        // Create the URLRequest and set its properties
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        // ... Set other properties on the request as needed ...
        if let payload {
            let codable: AccessTokenAndPayload<Payload> = .init(payload: payload)
            request.httpBody = try JSONEncoder().encode(codable)
        }
        return request
    }

    /// This is the client side half of the strong contract between the client and the api
    /// You can call this task and trust that the
    /// - Parameters:
    ///   - expressive: Prints any errors.
    ///   - payload: The payload you want to pass to the backend.
    ///   - passResponse: Exposes the response from the backend.
    ///   - errorHandler: Exposes any errors, including non async errors.  Errors can come from failed url validation of urlComponents, failing to encode the payload into the request body, and any errors produced when creating a session and making a datatask on the URLRequest.
    @discardableResult
    public func task(
        autoResume: Bool = true,
        expressive: Bool = false,
        assertHasAccessToken: Bool = true,
        payload: Payload,
        passResponse: @escaping PassResponse,
        errorHandler: ErrorHandler? = nil
    ) -> URLSessionDataTask? {
        if assertHasAccessToken {
            URLQueryItem.assertHasToken()
        }
        do {
            let theTask = try urlRequest(payload: payload).callCodableErrorTask(
                expressive: expressive,
                action: passResponse,
                errorHandler: errorHandler
            )
            theTask.resume()
            return theTask
        } catch {
            errorHandler?(error)
            return nil
        }
    }
}
