import XCTest
@testable import StrongContractClient

class RequestTests: XCTestCase {

    func testURLRequestCreation() {
        let request = Request<EmptyPayload, EmptyResponse>(
            path: "/test",
            method: .get,
            baseComponents: URLComponents(string: "https://example.com")!,
            initialPath: "/api",
            contentType: "application/json"
        )

        let urlRequest = request.urlRequest

        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://example.com/api/test")
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        XCTAssertEqual(urlRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func testURLRequestInitializationFailsWithInvalidURLComponents() {
        var components = URLComponents()
        components.scheme = "https" // A valid scheme
        components.host = "127.0.0.1" // A valid host
        components.port = 80 // A valid port
        // A path that should be valid but will be combined in a way that makes the URL nil
        components.path = "/test" // Normally valid

        // Set the initial path to a malformed string that, when combined with `path`, should result in a nil URL
        let malformedInitialPath = "://badpath"

        let request = Request<EmptyPayload, EmptyResponse>(
            path: components.path,
            method: .get,
            baseComponents: components,
            initialPath: malformedInitialPath, // This should cause the URL to be nil
            contentType: "application/json"
        )

        // The URLRequest should be nil because the initialPath will cause an invalid URL
        XCTAssertNil(request.urlRequest, "URLRequest should be nil due to invalid combination of URL components")
    }
}

// Mocks and placeholders used in tests
struct EmptyPayload: Codable {}
struct EmptyResponse: Codable {}
struct SamplePayload: Codable {
    let message: String
}


class RequestTests2: XCTestCase {

//    // Test the task method with a valid payload
//    func testTaskWithValidPayload() {
//        let components = URLComponents(string: "https://example.com/api")!
//        let request = Request<ValidPayload, EmptyResponse>(
//            path: "/test",
//            method: .post,
//            baseComponents: components,
//            contentType: "application/json"
//        )
//
//        let encodingExpectation = expectation(description: "Payload should be encoded successfully")
//
//        let _ = request.task(
//            payload: ValidPayload(exampleProperty: "Test"),
//            passResponse: { _ in
//                encodingExpectation.fulfill()
//            },
//            errorHandler: { error in
//                XCTFail("Encoding should not fail, but failed with error: \(error)")
//            }
//        )
//
//        waitForExpectations(timeout: 1)
//    }

    // Test the task method with an invalid payload that throws during encoding
    func testTaskWithPayloadThatThrowsDuringEncoding() {
        let components = URLComponents(string: "https://example.com/api")!
        let request = Request<InvalidPayload, EmptyResponse>(
            path: "/test",
            method: .post,
            baseComponents: components,
            contentType: "application/json"
        )

        let encodingFailedExpectation = expectation(description: "Encoding should fail")

        let _ = request.task(
            payload: InvalidPayload(unencodableProperty: "Invalid"), // Use the payload that will throw an error
            passResponse: { _ in
                XCTFail("Encoding should fail, but it succeeded")
            },
            errorHandler: { error in
                // Check that the error is of type EncodingError
                if case EncodingError.invalidValue(_, let context) = error {
                    XCTAssertEqual(context.debugDescription, "Invalid value for encoding")
                    encodingFailedExpectation.fulfill()
                } else {
                    XCTFail("Error should be of type EncodingError.invalidValue")
                }
            }
        )

        waitForExpectations(timeout: 1)
    }


}

// Helper Codable structs for tests
struct ValidPayload: Codable {
    let exampleProperty: String
}

struct InvalidPayload: Codable {
    let unencodableProperty: String

    enum CodingKeys: CodingKey {
        case unencodableProperty
    }

    func encode(to encoder: Encoder) throws {
        // Throw an error to simulate failure during encoding.
        throw EncodingError.invalidValue(unencodableProperty, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid value for encoding"))
    }
}
