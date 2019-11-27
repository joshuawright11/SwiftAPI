import Foundation

class ReminderService: APIGroup {
    @Auth(User.self)
    var getAll: Endpoint<Empty, Reminder>
    @POST("LEL")
    var create: Endpoint<Reminder, Reminder>
}

class APIGroup {}

struct Reminder: Codable {
    var userID: PK<User>
    var name: String
    var isComplete: Bool
}

struct PK<Type>: Codable {
    private let val: Val
}

protocol PrimaryIdentifiable {
    associatedtype PKType
}

struct User: Codable, Authable {
    var id: String
    var username: String
    var hashedPassword: String

    func test() {
        let thing: KeyPath<User, String> = \.username
        let user = User(id: "", username: "", hashedPassword: "")
        let rem = Reminder(userID: user.username, name: <#T##String#>, isComplete: <#T##Bool#>)
    }
}

struct Empty: Codable {}
