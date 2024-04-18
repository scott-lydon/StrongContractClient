//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//

import Foundation

enum URLValidationError: Error, LocalizedError {
    case missingScheme
    case missingHost
    case missingPath
    case invalidPath
    case unknown

    var errorDescription: String? {
        switch self {
        case .missingScheme:
            return "Scheme component is missing."
        case .missingHost:
            return "Host component is missing."
        case .missingPath:
            return "Path component is missing."
        case .invalidPath:
            return "Path component is invalid. It must start with '/'."
        case .unknown:
            return "Unknown error. The URL could not be constructed."
        }
    }
}
