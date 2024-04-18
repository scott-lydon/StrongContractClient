//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/17/24.
//

import Foundation

extension URLComponents {
    func urlAndValidate() throws -> URL {
        guard scheme != nil else {
            throw URLValidationError.missingScheme("Current scheme: \(String(describing: self.scheme))")
        }

        guard host != nil else {
            throw URLValidationError.missingHost("Current host: \(String(describing: self.host))")
        }

        if self.path.isEmpty {
            throw URLValidationError.missingPath("Current path: \(self.path)")
        }

        guard self.path.hasPrefix("/") else {
            throw URLValidationError.invalidPath("Current path: \(self.path)")
        }

        // If all validations pass but url is still nil, it indicates an unknown problem.
        guard let url = self.url else {
            let componentsDescription = "scheme: \(String(describing: self.scheme)), host: \(String(describing: self.host)), path: \(self.path)"
            throw URLValidationError.unknown("URL could not be constructed. Components: \(componentsDescription)")
        }
        return url
    }
}
