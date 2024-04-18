// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Callable

public var defaultComponents: URLComponents = .init()
public var defaultPath: String = ""
public var defaultContentType: String = ""

public struct Request<Payload: Codable, Response: Codable> {

    public var path: String = "/"
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
    internal func urlRequest() throws -> URLRequest {
        // Combine the base components with the initial and specific path
        var components = baseComponents
        let fullPath = "/\(initialPath)/\(path)"
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        // Ensures no leading double slashes
        components.path = "/" + fullPath

        // Attempt to validate the URL and create the URLRequest

        let url = try components.urlAndValidate()
        // Create the URLRequest and set its properties
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        // ... Set other properties on the request as needed ...
        return request
    }


    /// This is the client side half of the strong contract between the client and the api
    /// You can call this task and trust that the
    /// - Parameters:
    ///   - expressive: Prints any errors.
    ///   - payload: The payload you want to pass to the backend.
    ///   - passResponse: Exposes the response from the backend.
    ///   - errorHandler: Exposes any errors.
    @discardableResult
    public func task(
        expressive: Bool = false,
        payload: Payload,
        passResponse: @escaping PassResponse,
        errorHandler: ErrorHandler? = nil
    ) throws -> URLRequest? {
        // These might be better as properties.
        var buffer: URLRequest = try! urlRequest()

        let codable: AccessTokenAndPayload<Payload> = .init(payload: payload)
        do {
            let encoder = JSONEncoder()
            buffer.httpBody = try encoder.encode(codable)
        } catch {
            errorHandler?(error)
            return nil
        }
        // The error may be from codable.
        buffer.callCodableError(
            expressive: expressive,
            action: passResponse,
            errorHandler: errorHandler
        )
        return buffer
    }
}
