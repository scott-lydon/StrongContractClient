//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

#if canImport(Vapor)
import Vapor


public extension StrongContractClient.Request {

    /// This method registers routes, and exposes a callback for
    ///  the call site to process the request and return a response
    func handle(
        app: any RoutesBuilder,
        payloadToResponse: @escaping (Payload, Vapor.Request) -> Vapor.Response
    ) {
        let pathComponents: [PathComponent] = ["\(initialPath)", "/", "\(path)"]

        switch method {
        case .get:
            app.get(pathComponents) { request in
                // body.data?.data
                let payload: Payload = try request.decryptedData().decodedObject()
                return payloadToResponse(payload, request)
            }
        case .post:
            app.post(pathComponents) { request in
                let payload: Payload = try request.decryptedData().decodedObject()
                return payloadToResponse(payload, request)
            }
        case .put:
            app.put(pathComponents) { request in
                let payload: Payload = try request.decryptedData().decodedObject()
                return payloadToResponse(payload, request)
            }
        case .delete:
            app.delete(pathComponents) { request in
                let payload: Payload = try request.decryptedData().decodedObject()
                return payloadToResponse(payload, request)
            }
        case .patch:
            app.patch(pathComponents) { request in
                let payload: Payload = try request.decryptedData().decodedObject()
                return payloadToResponse(payload, request)
            }
        case .head:
            // Register a route to handle HEAD requests.
            // In Vapor, HEAD requests are handled by GET route handlers without sending the body in the response.
            // This means that any logic and headers applied in GET handlers will apply to HEAD requests as well,
            // but the response body will not be sent to the client.
            app.get(pathComponents) { request in
                let payload: Payload = try request.decryptedData().decodedObject()
                return payloadToResponse(payload, request)
            }
        }
    }
}
#endif
