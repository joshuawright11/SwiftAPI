import XCTest
@testable import SwiftAPI

final class EncodingTests: XCTestCase {
    func testEncodeValue() throws {
        let testAPI = TestAPI()
        let testObj = TestObj(thing: "value")
        let reqDTO = TestReqDTO(userID: "1234", number: 1, someThings: [], value: "test", obj: testObj)
        let params = try testAPI.test.parameters(dto: reqDTO)
        XCTAssert(params.fullPath.hasPrefix("/v1/accounts/1234/transfer"))
        XCTAssert(params.fullPath.hasSuffix("?number=1"))
        XCTAssert(params.method == .post)

        let testData = try testObj.toData()
        XCTAssert(params.body == testData)
    }

    static var allTests = [
        ("encodeValue", testEncodeValue),
    ]
}
