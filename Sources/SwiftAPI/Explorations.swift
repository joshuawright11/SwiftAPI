import Foundation

struct PetsAPI {
    @POST("v1/pets")
    var create: Endpoint<Pet, Pet>

    @POST("v1/pets/:pet_id:/toys")
    var createToy: Endpoint<CreateToyRequest, Toy>

    @GET("v1/pets")
    var getAll: Endpoint<Empty, [Pet]>
}

struct Toy: Codable {}
struct Pet: Codable {}

public protocol BodyRequest {
    associatedtype BodyType: Codable
    var body: BodyType { get }
}

struct CreateToyRequest: BodyRequest {
    @Path("pet_id")           var petID = ""
    @Header("special_header") var header = ""
    @Query("some_key")        var query = ""
    
    var body: Toy
}

///// Client Consuming
///// ----------------
//let api = PetsAPI()
//
//// If Req type is empty, no params required
//api.getAll.request()
//    .subscribe(onSuccess: { ... })
//
//// Otherwise, require the Req type as param
//let toyReq = CreateToyRequest(
//    petID: somePet.id,
//    header: "special_value",
//    query: "some_query",
//    toy: Toy(...))
//api.createToy.request(toyReq)
//    .subscribe(onSuccess: { ... })

///// Server Consuming
///// ----------------
//let api = PetsAPI()
//let controller = PetController()
//router.register(api.createToy, controller.createToy)
//
//class PetController {
//    // Automatically parse `CreateToyRequest` from query, headers, body, etc to handle most validation.
//    func createToy(request: ServerRequest, content: CreateToyRequest) -> Promise<Toy> { ... }
//}
//
