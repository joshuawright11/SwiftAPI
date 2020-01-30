@testable import SwiftAPI

struct Test {
    @POST("v1/accounts/:userID:/transfer")
    var test: Endpoint<TestReqDTO, TestResDTO>
}

struct TestReqDTO: RequestEncodable {
    @_Path   var userID: String
    @_Query  var number: Int
    @_Query  var someThings: [String]
    @_Header var value: String
    @_Body   var obj: TestObj
}

struct TestResDTO: Codable {
    let string: String
}

struct TestObj: Codable {
    var thing: String
}
