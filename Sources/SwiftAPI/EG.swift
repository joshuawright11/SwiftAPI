import Foundation

class ReminderService: APIGroup {
    var getAll: Endpoint<Empty, Reminder>?
    var create: Endpoint<Reminder, Reminder>?
}

class APIGroup {}

struct Reminder: Codable {
    var userID: String
    var name: String
    var isComplete: Bool
}

struct User: Codable {
    var id: String
    var username: String
    var hashedPassword: String
}

struct Empty: Codable {}
