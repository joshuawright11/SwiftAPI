import Foundation

protocol AnyBody {
    func toData() throws -> Data
}

@propertyWrapper struct Body<Value: Codable>: AnyBody {
    var wrappedValue: Value

    func toData() throws -> Data {
        try wrappedValue.toData()
    }
}

extension Encodable {
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
