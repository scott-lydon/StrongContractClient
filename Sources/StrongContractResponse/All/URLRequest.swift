//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/6/24.
//

import Foundation

//public extension URLRequest {
//    /// Initializes a URLRequest configured for a specified HTTP method with a JSON body from a Codable object.
//    ///Sources/EncryptDecryptKey/DataCrypto.swift
//    /// Using a generic type `T` constrained to `Codable` allows the Swift compiler to know the specific type
//    /// of the `Codable` object being passed in. This is crucial because the encoding process needs to know
//    /// the exact type to correctly use its `encode(to:)` method. Directly using `Codable` as a parameter type
//    /// would not work for encoding, as `Codable` is a protocol that many types can conform to, and just passing
//    /// a `Codable` would not provide the `JSONEncoder` with enough information about which specific type's
//    /// encoding logic to use. Hence, a generic type `T` ensures that the specific type information is preserved,
//    /// enabling `JSONEncoder` to correctly and safely encode the object.
//    ///
//    /// - Parameters:
//    ///   - url: The URL for the request.
//    ///   - method: The HTTP method (e.g., "POST", "PUT") as a `String`.
//    ///   - codable: The Codable object to encode and use as the request body. It uses a generic type `T` to
//    ///             maintain the type information necessary for encoding.
//    ///   - contentType: The content type to set for the request. Defaults to "application/octet-stream".
//    init?<T: Codable>(
//        baseComponents: URLComponents,
//        initialPath: String = "/api/",
//        path: String,
//        method: HTTPMethod,
//        payload: T,
//        contentType: String = "application/octet-stream"
//    ) {
//        self.init(url: baseComponents.with(path: path).url!)
//
//        httpMethod = method.rawValue
//        addValue(contentType, forHTTPHeaderField: "Content-Type")
//
//        let codable: TokenAndPayload<T> = .init(payload: payload)
//        do {
//            let encoder = JSONEncoder()
//            httpBody = try encoder.encode(codable)
//            print("Original data size: \(String(describing: httpBody?.count)) bytes")
//        } catch {
//            print("Error encoding codable to JSON: \(error)")
//            return nil
//        }
//    }
//}
