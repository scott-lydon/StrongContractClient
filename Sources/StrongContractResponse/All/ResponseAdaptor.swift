//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//
#if canImport(Vapor)
import Foundation
import Vapor

public extension StrongContractClient.Request {

    struct ResponseAdaptor {
        var status: HTTPResponseStatus
        var version: HTTPVersion
        var headers: HTTPHeaders
        var data: ByteBuffer  // Holds the encoded data

        // Initializer that throws an error if the body cannot be encoded
        init(
            status: HTTPResponseStatus,
            version: HTTPVersion,
            headers: HTTPHeaders,
            body: Response
        ) throws {
            self.status = status
            self.version = version
            self.headers = headers

            // Encode the body into JSON data, throw an error if encoding fails
            let jsonData = try JSONEncoder().encode(body)
            self.data = ByteBuffer(data: jsonData)  // Assign the encoded data to the data property
        }

        // Computed property to generate a Vapor.Response from the adaptor
        var vaporResponse: Vapor.Response {
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
