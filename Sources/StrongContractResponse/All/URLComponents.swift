//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//

import Foundation

extension URLComponents {
    func urlAndValidate() throws -> URL {
        guard let _ = scheme else {
            throw URLValidationError.missingScheme
        }

        guard let _ = host else {
            throw URLValidationError.missingHost
        }

        guard !path.isEmpty else {
            throw URLValidationError.missingPath
        }

        guard path.hasPrefix("/") else {
            throw URLValidationError.invalidPath
        }
        
        // If all validations pass but url is still nil, it indicates an unknown problem.
        guard let url else {
            throw URLValidationError.unknown
        }

        return url
    }
}
