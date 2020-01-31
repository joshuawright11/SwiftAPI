import Foundation

protocol AnyBody {
    func toData() throws -> Data
}

@propertyWrapper
public struct Body<Value: Codable>: AnyBody {
    public var wrappedValue: Value
    public init(wrappedValue: Value) { self.wrappedValue = wrappedValue }

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
