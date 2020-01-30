import XCTest
@testable import SwiftAPI

final class EncodingTests: XCTestCase {
    let request = MockRequest()

    func testEncodeValue() throws {
        let testObj = TestObj(thing: "value")

        let reqDTO = TestReqDTO(userID: "1234", number: 1, someThings: [], value: "test", obj: testObj)
        try reqDTO.encode(to: self.request, basePath: "/v1/shtuff/{userID}", method: .post)
        XCTAssert(self.request.path.hasPrefix("/v1/shtuff/1234"))
        XCTAssert(self.request.path.hasSuffix("?number=1"))
        XCTAssert(self.request.method == .post)

        let testData = try testObj.toData()
        XCTAssert(self.request.body == testData)
    }

    static var allTests = [
        ("encodeValue", testEncodeValue),
    ]
}

final class MockRequest: RequestEncoder {
    var body: Data?
    var headers: [String: String] = [:]
    var path: String = ""
    var method: HTTPMethod = .get

    func setHeaders(_ headers: [String : String]) {
        self.headers = headers
    }

    func setPath(_ path: String) {
        self.path = path
    }

    func setBody(_ data: Data?) {
        self.body = data
    }

    func setMethod(_ method: HTTPMethod) {
        self.method = method
    }
}
