//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//

import Foundation

enum URLValidationError: Error, LocalizedError {
    case missingScheme(String)
    case missingHost(String)
    case missingPath(String)
    case invalidPath(String)
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .missingScheme(let details):
            return "Scheme component is missing. \(details)"
        case .missingHost(let details):
            return "Host component is missing. \(details)"
        case .missingPath(let details):
            return "Path component is missing. \(details)"
        case .invalidPath(let details):
            return "Path component is invalid. It must start with '/'. \(details)"
        case .unknown(let details):
            return "Unknown error. The URL could not be constructed. \(details)"
        }
    }
}
