@propertyWrapper
public class Path: Codable {
    public var wrappedValue: String
    public var pathKey: String
    public init(wrappedValue initialValue: String = "", _ pathKey: String) {
        self.wrappedValue = initialValue
        self.pathKey = pathKey
    }
}

@propertyWrapper
public struct Header: Codable {
    public var wrappedValue: String
    public var pathKey: String
    public init(wrappedValue initialValue: String = "", _ pathKey: String) {
        self.wrappedValue = initialValue
        self.pathKey = pathKey
    }
}

@propertyWrapper
public struct Query: Codable {
    public var wrappedValue: String
    public var pathKey: String
    public init(wrappedValue initialValue: String = "", _ pathKey: String) {
        self.wrappedValue = initialValue
        self.pathKey = pathKey
    }
}
