//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/6/24.
//

import Foundation
import Callable

public struct AccessTokenAndPayload<Payload: Codable>: Codable {
    public var accessToken: URLQueryItem = .access_token_and_user_id
    public var payload: Payload

    /// Produces the access token from the urlQueryItem.
    func token() throws -> String {
        guard let tokenn = accessToken.value else {
            throw GenericError(text: "Access token was nil")
        }
        if tokenn == "" {
            throw GenericError(text: "Token was an empty string")
        }
        return tokenn
    }
}
