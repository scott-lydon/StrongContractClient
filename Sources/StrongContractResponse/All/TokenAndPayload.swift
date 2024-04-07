//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/6/24.
//

import Foundation

public struct TokenAndPayload<Payload: Codable>: Codable {
    var accessToken: URLQueryItem = .access_token_and_user_id
    var payload: Payload
}
