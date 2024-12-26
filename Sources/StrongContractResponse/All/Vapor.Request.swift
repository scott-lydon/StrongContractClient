//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

#if canImport(Vapor)
import EncryptDecryptKey
import Vapor
import Callable

extension Vapor.Request {
    func decryptedData() throws -> Data {
        guard let encryptedData = body.data?.data else {
            throw Abort(.badRequest, reason: "body data not found")
        }
        return try encryptedData.decrypt()
    }

    func codableBody<T: Codable>() throws -> T {
        guard let bodyData = body.data else { throw GenericError(text: "Body data was nil") }
        return try JSONDecoder().decode(T.self, from: bodyData.data)
    }

    func codableBodyExemptingData<T: Codable>() throws -> T {
        if T.self == Data.self, let data = body.data?.data as? T {
            return data
        } else if let bodyData = body.data {
            return try JSONDecoder().decode(T.self, from: bodyData.data)
        }
        throw GenericError(text: "Body data was nil")
    }

    func decodedObject<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        guard let data = body.data?.data else { throw GenericError(text: "Body data was nil") }
        return try data.decodedObject(using: decoder)
    }
}
#endif
