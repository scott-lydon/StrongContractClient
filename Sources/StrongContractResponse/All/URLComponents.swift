//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//

import Foundation

extension URLComponents {

    enum URLValidationError: Error {
         case missingScheme(String)
         case missingHost(String)
         case missingPath(String)
         case invalidPath(String)
         case invalidCharactersInPath(String)
         case unknown(String)
     }

    func urlAndValidate() throws -> URL {
        guard let scheme else {
            throw URLValidationError.missingScheme("Current scheme: nil")
        }

        guard let host else {
            throw URLValidationError.missingHost("Current host: nil")
        }

        if path.isEmpty {
            throw URLValidationError.missingPath("Current path is emtpy")
        }

        guard path.hasPrefix("/") else {
            throw URLValidationError.invalidPath("Current path: \(path)")
        }

        // Check for invalid characters or patterns in the path
        let invalidPatterns = ["://", "..", "::", "/:/"]
        for pattern in invalidPatterns {
            if path.contains(pattern) {
                throw URLValidationError.invalidCharactersInPath("Path contains invalid pattern '\(pattern)': \(path)")
            }
        }

        // If all validations pass but url is still nil, it indicates an unknown problem.
        guard let url else {
            let componentsDescription = "scheme: \(scheme), host: \(host), path: \(path)"
            throw URLValidationError.unknown(
                "URL could not be constructed. Components: " + componentsDescription
            )
        }
        return url
    }
}
