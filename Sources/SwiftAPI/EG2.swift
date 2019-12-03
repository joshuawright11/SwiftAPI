import Foundation

struct PetsAPI {
    @Query([
        .method(.get),
        .headerDynamic("header", \CreatePetRequest.header)
    ])
    var create: Endpoint<CreatePetRequest, Pet> = .init(path: "", method: .get)
}

struct CreatePetRequest: Codable {
    var header: String
    var query: String
    var userID: String
    var pet: Pet
}

struct Pet: Codable {
    var id: String?
    var name: String
}

@propertyWrapper
public struct Query<Req: Codable, Res: Codable> {
    // https://forums.swift.org/t/is-it-allowed-to-inherit-a-property-wrapper-class/28695
    public var wrappedValue: Endpoint<Req, Res>

    public init(
        wrappedValue initialValue: Endpoint<Req, Res>,
        _ pieces: [RequestPiece<Req, Res>])
    {
        self.wrappedValue = initialValue
    }
}

public enum RequestPiece<Req, Res> {
    case headerStatic(String, String)
    case headerDynamic(String, PartialKeyPath<Req>)
    case query(String, PartialKeyPath<Req>)
    case path(String, PartialKeyPath<Req>)
    case body(PartialKeyPath<Req>)
    case method(HTTPMethod)
}
