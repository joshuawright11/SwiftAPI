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

struct PetsAPI {
    @POST("v1/dda/:user_id:")
    var create: Endpoint<CreatePetRequest, Pet>
}

struct CreatePetRequest: Codable {
    @Path("user_id")  var userID: String = ""
    @Header("header") var header: String = ""
    @Query("sorted")  var query: String = ""
    
    @Body var pet: Pet
}

struct Pet: Codable {
    var id: String?
    var name: String
}
