//
//  File.swift
//  StrongContractClient
//
//  Created by Scott Lydon on 1/13/26.
//

import Foundation

#if canImport(FoundationNetworking)
// Provided for `URL` related objects on Linux platforms.
import FoundationNetworking
#endif

extension URLRequest {

    public static func commonURLRequest<Payload: Codable>(
        url: URL,
        payload: Payload?,
        method: HTTPMethod = .post,
        token: String? = String.accessToken,
        using encoder: JSONEncoder = .init(),
        contentType: String = defaultContentType
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        if let payload {
            if Payload.self == Data.self {
                request.httpBody = payload as? Data
            } else if Payload.self == Empty.self {
                request.httpBody = nil
            } else {
                request.httpBody = try encoder.encode(payload)
            }
        }
        request.httpMethod = method.rawValue
        if request.httpMethod == HTTPMethod.get.rawValue {
            assert(request.httpBody == nil, "URL Request session will throw an error if the method is get and body is not nil")
            request.httpBody = nil
        }
        if let token {
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        return request
    }
}
