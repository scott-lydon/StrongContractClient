//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//

import Foundation

extension URLComponents {
    func urlAndValidate() throws -> URL {
        guard let scheme = self.scheme else {
            throw URLValidationError.missingScheme
        }

        guard let host = self.host else {
            throw URLValidationError.missingHost
        }

        guard !self.path.isEmpty else {
            throw URLValidationError.missingPath
        }

        guard self.path.hasPrefix("/") else {
            throw URLValidationError.invalidPath
        }
        
        // If all validations pass but url is still nil, it indicates an unknown problem.
        guard let url = self.url else {
            throw URLValidationError.unknown
        }

        return url
    }
}
