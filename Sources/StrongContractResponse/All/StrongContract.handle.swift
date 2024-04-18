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
        payloadToResponse: @escaping (AccessTokenAndPayload<Payload>, Vapor.Request) throws -> ResponseAdaptor
    ) {
        // Split the path by '/' to get individual components
        let pathSegments = path.split(separator: "/").map(String.init)

        // Convert string path segments to PathComponent
        let partialPathComponents = pathSegments.map { PathComponent(stringLiteral: $0) }

        // Prepend initialPath if it's not empty to the path components
        let pathComponents: [PathComponent] = initialPath.isEmpty ? partialPathComponents : [PathComponent(stringLiteral: initialPath)] + partialPathComponents
        switch method {
        case .get:
            app.get(pathComponents) {
                try payloadToResponse($0.decryptedData().decodedObject(), $0).vaporResponse
            }
        case .post:
            app.post(pathComponents) { 
                do {
                    let payload: AccessTokenAndPayload<Payload> = try $0.decryptedData().decodedObject()
                    return try payloadToResponse(payload, $0).vaporResponse
                } catch {
                    print(error.localizedDescription)
                }
                do {
                    let payload: Payload = try $0.decryptedData().decodedObject()
                 //  return try payloadToResponse(payload, $0).vaporResponse
                } catch {
                    print(error.localizedDescription)
                }
                let payload1: Payload? = $0.body.data?.data.codable()
                let payload2: Payload? = $0.body.data?.data.traditionalCodable()
                let payload3: AccessTokenAndPayload<Payload>? = $0.body.data?.data.codable()
                let payload4: AccessTokenAndPayload<Payload>? = $0.body.data?.data.traditionalCodable()

                print(
                    payload1 as Any,
                    payload2 as Any,
                    payload3 as Any,
                    payload4 as Any
                )


                let payload: AccessTokenAndPayload<Payload> = try $0.decryptedData().decodedObject()
                return try payloadToResponse(payload, $0).vaporResponse
            }
        case .put:
            app.put(pathComponents) {
                try payloadToResponse($0.decryptedData().decodedObject(), $0).vaporResponse
            }
        case .delete:
            app.delete(pathComponents) {
                try payloadToResponse($0.decryptedData().decodedObject(), $0).vaporResponse
            }
        case .patch:
            app.patch(pathComponents) {
                try payloadToResponse($0.decryptedData().decodedObject(), $0).vaporResponse
            }
        case .head:
            // Register a route to handle HEAD requests.
            // In Vapor, HEAD requests are handled by GET route handlers without 
            // sending the body in the response.
            // This means that any logic and headers applied in GET handlers will
            // apply to HEAD requests as well,
            // but the response body will not be sent to the client.
            app.get(pathComponents) {
                try payloadToResponse($0.decryptedData().decodedObject(), $0).vaporResponse
            }
        }
    }
}
#endif
