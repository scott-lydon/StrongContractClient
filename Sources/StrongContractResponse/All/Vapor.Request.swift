//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

import EncryptDecryptKey
#if canImport(Vapor)
import Vapor


extension Vapor.Request {
    func decryptedData() throws -> Data {
        guard let encryptedData = body.data?.data else {
            throw Abort(.badRequest, reason: "body data not found")
        }
        return try encryptedData.decrypt()
    }
}
#endif
