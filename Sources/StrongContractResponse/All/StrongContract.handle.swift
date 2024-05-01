//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

#if canImport(Vapor)
import Vapor
import CommonExtensions

public extension StrongContractClient.Request {

    /// This method registers routes, and exposes a callback for
    ///  the call site to process the request and return a response
    func registerHandler(
        app: any RoutesBuilder,
        payloadToResponse: @escaping (Payload, Vapor.Request) async throws -> ResponseAdaptor
    ) {
        // Split the path by '/' to get individual components
        let pathSegments = path.split(separator: "/").map(String.init)

        // Convert string path segments to PathComponent
        let partialPathComponents = pathSegments.map(PathComponent.init)

        // Prepend initialPath if it's not empty to the path components
        let pathComponents: [PathComponent] = initialPath.isEmpty ?
            partialPathComponents :
            CollectionOfOne(.init(stringLiteral: initialPath)) + partialPathComponents

        // let test:
        switch method {
        case .get, .head:
            // Register a route to handle HEAD requests.
            // In Vapor, HEAD requests are handled by GET route handlers without
            // sending the body in the response.
            // This means that any logic and headers applied in GET handlers will
            // apply to HEAD requests as well,
            // but the response body will not be sent to the client.
            app.get(pathComponents) {
                try await payloadToResponse($0.codableBody(), $0).vaporResponse
            }
        case .post:
            app.post(pathComponents) { 
                try await payloadToResponse($0.codableBody(), $0).vaporResponse
            }
        case .put:
            app.put(pathComponents) {
                try await payloadToResponse($0.codableBody(), $0).vaporResponse
            }
        case .delete:
            app.delete(pathComponents) {
                try await payloadToResponse($0.codableBody(), $0).vaporResponse
            }
        case .patch:
            app.patch(pathComponents) {
                try await payloadToResponse($0.codableBody(), $0).vaporResponse
            }
        }
    }
}
#endif
