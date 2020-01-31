protocol AnyPath {
    var value: String { get }
}

@propertyWrapper
public struct Path: AnyPath {
    public var wrappedValue: String
    var value: String { wrappedValue }
    public init(wrappedValue: String) { self.wrappedValue = wrappedValue }
}
