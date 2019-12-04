import Foundation

/// Shared Lib
/// ----------
struct Endpoint<Req, Res: Codable> { ... }

struct PetsAPI {
    @POST("v1/pets")
    var create: Endpoint<Pet, Pet> // If Req is codable, put it in the body

    @POST("v1/pets/:pet_id:/toys")
    var createToy: Endpoint<CreateToyRequest, Toy> // Otherwise, use wrappers on Req to decide where fields go

    @GET("v1/pets")
    var getAll: Endpoint<Empty, [Pet]> // Empty means no request is necessary
}

struct Toy: Codable { ... }
struct Pet: Codable { ... }

struct CreateToyRequest {
    @Path("pet_id")           var petID = ""
    @Header("special_header") var header = ""
    @Query("some_key")        var query = ""
    @Body                     var toy: Toy
}

/// Client Consuming
/// ----------------
let api = PetsAPI()

// If Req type is empty, no params required
api.getAll.request()
    .subscribe(onSuccess: { ... })

// Otherwise, require the Req type as param
let toyReq = CreateToyRequest(
    petID: somePet.id,
    header: "special_value",
    query: "some_query",
    toy: Toy(...))
api.createToy.request(toyReq)
    .subscribe(onSuccess: { ... })

/// Server Consuming
/// ----------------
let api = PetsAPI()
let controller = PetController()
router.register(api.createToy, controller.createToy)

class PetController {
    // Automatically parse `CreateToyRequest` from query, headers, body, etc to handle most validation.
    func createToy(request: ServerRequest, content: CreateToyRequest) -> Promise<Toy> { ... }
}

// Load Obj from request
extension CreatePetRequest: Mappable {
    init(_ mapper: Mapper) throws {
        pet = try mapper.body(Pet.self)
        userID = try mapper.load(_userID)
        header = try mapper.load(_header)
        query = try mapper.load(_query)
    }
}

extension Decodable where Self: Encodable {
    init(_ mapper: Mapper) throws {
        self = try mapper.body(Self.self)
    }
}

protocol Mappable {
    init(_ mapper: Mapper) throws
}

protocol Mapper {
    // Load a param from path
    func load<T>(_ param: Path) throws -> T

    // Load a param from headers
    func load<T>(_ header: Header) throws -> T

    // Load a param from query
    func load<T>(_ param: Query) throws -> T

    // Load a body from a body
    func body<T: Codable>(_ body: T.Type) throws -> T
}
