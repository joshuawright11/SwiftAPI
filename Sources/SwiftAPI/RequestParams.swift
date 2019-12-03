@propertyWrapper
public class Path: Codable {
    public var wrappedValue: String
    var pathKey: String
    init(wrappedValue initialValue: String = "", _ pathKey: String) {
        self.wrappedValue = initialValue
        self.pathKey = pathKey
    }
}

@propertyWrapper
public struct Header: Codable {
    public var wrappedValue: String
    var pathKey: String
    init(wrappedValue initialValue: String = "", _ pathKey: String) {
        self.wrappedValue = initialValue
        self.pathKey = pathKey
    }
}

@propertyWrapper
public struct Query: Codable {
    public var wrappedValue: String
    var pathKey: String
    init(wrappedValue initialValue: String = "", _ pathKey: String) {
        self.wrappedValue = initialValue
        self.pathKey = pathKey
    }
}

@propertyWrapper
public struct Body<T: Codable>: Codable, BodyBase {
    public var wrappedValue: T
    var bodyValue: Codable { return wrappedValue }
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

protocol BodyBase {
    var bodyValue: Codable { get }
}
