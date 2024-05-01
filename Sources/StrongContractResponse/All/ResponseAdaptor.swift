//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//
#if canImport(Vapor)
import Foundation
import Vapor

/// I ResponseAdaptor is a carrier for the Vapor.Response properties and the StrongContractClient.Response.
/// This lets the user of registerHandler define Vapor.Response properties, while preserving a strong contract, expecting the correct Response. 
public extension StrongContractClient.Request {

    struct ResponseAdaptor {
        public var status: HTTPResponseStatus
        public var version: HTTPVersion
        public var headers: HTTPHeaders
        public var data: ByteBuffer  // Holds the encoded data

        // Initializer that throws an error if the body cannot be encoded
        public init(
            status: HTTPResponseStatus = .ok,
            version: HTTPVersion = .http1_1,
            headers: HTTPHeaders = .defaultJson,
            body: Response,
            using encoder: JSONEncoder = .init()
        ) throws {
            self.status = status
            self.version = version
            self.headers = headers
            // Encode the body into JSON data, throw an error if encoding fails
            let jsonData = try encoder.encode(body)
            self.data = ByteBuffer(data: jsonData)  // Assign the encoded data to the data property
        }

        // Computed property to generate a Vapor.Response from the adaptor
        public var vaporResponse: Vapor.Response {
            // Create a Vapor.Response with the stored data
            let response = Vapor.Response(
                status: status,
                version: version,
                headers: headers,
                body: .init(buffer: data)
            )

            // Update headers to include content-length
            response.headers.replaceOrAdd(name: "Content-Length", value: String(data.readableBytes))
            return response
        }
    }
}
#endif
