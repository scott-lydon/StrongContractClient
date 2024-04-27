// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Callable

public var defaultComponents: URLComponents = .init()
public var defaultPath: String = ""
public var defaultContentType: String = ""

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
