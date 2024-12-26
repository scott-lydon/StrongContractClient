//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

#if canImport(Vapor)
import Vapor

public extension StrongContractClient.Request {

    typealias PayloadToResponse = (Payload, Vapor.Request) async throws -> ResponseAdaptor

    /// This method registers routes, and exposes a callback for
    ///  the call site to process the request and return a response
    /// - Parameters:
    ///   - app: The application's route builder to which the route will be registered.
    ///   - verbose: Flag to enable or disable verbose logging for debugging.
    ///   - payloadToResponse: A closure that processes the request and returns a response.
    func register(
        app: any RoutesBuilder,
        verbose: Bool = false,
        handler: @escaping PayloadToResponse
    ) {
        // Split the path by '/' to get individual components
        // Convert string path segments to PathComponent
        let pathComponents = path.split(separator: "/").map(String.init).map(PathComponent.init)
        
        if verbose {
            print(pathComponents)
        }
        
        switch method {
        case .get, .head:
            // Register a route to handle HEAD requests.
            // In Vapor, HEAD requests are handled by GET route handlers without
            // sending the body in the response.
            // This means that any logic and headers applied in GET handlers will
            // apply to HEAD requests as well,
            // but the response body will not be sent to the client.
            app.get(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await handler($0.decodedObject(), $0).vaporResponse
            }
        case .post:
            app.post(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await handler($0.decodedObject(), $0).vaporResponse
            }
        case .put:
            app.put(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await handler($0.decodedObject(), $0).vaporResponse
            }
        case .delete:
            app.delete(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await handler($0.decodedObject(), $0).vaporResponse
            }
        case .patch:
            app.patch(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await handler($0.decodedObject(), $0).vaporResponse
            }
        }
    }
}

public extension StrongContractClient.Request where Response == Data {

    // We need to break the contract in order to return a byte stream `streamFile(at: )`
    // Thats why we return a Vapor.Response here
    typealias PayloadToData = (Payload?, Vapor.Request) async throws -> Vapor.Response

    func register(
        app: any RoutesBuilder,
        verbose: Bool = false,
        downloader: @escaping PayloadToData
    ) {
        let pathComponents = path.split(separator: "/").map(String.init).map(PathComponent.init)
        if verbose {
            print(pathComponents)
        }
        switch method {
        case .get, .head:
            app.get(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await downloader($0.body.data?.data.decodedObject(), $0)
            }
        case .post:
            app.post(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await downloader($0.body.data?.data.decodedObject(), $0)
            }
        case .put:
            app.put(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await downloader($0.body.data?.data.decodedObject(), $0)
            }
        case .delete:
            app.delete(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await downloader($0.body.data?.data.decodedObject(), $0)
            }
        case .patch:
            app.patch(pathComponents) {
                if verbose { print("We received: \($0)") }
                return try await downloader($0.body.data?.data.decodedObject(), $0)
            }
        }
    }
}
#endif
