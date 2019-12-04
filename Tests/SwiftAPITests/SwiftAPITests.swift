import XCTest
@testable import SwiftAPI

final class SwiftAPITests: XCTestCase {
    func testExample() {
        let req = CreatePetRequest(userID: "foo", header: "bar", query: "baz", pet: Pet(id: nil, name: ""))
        var endpoint = PetsAPI().create
        endpoint.update(req)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
