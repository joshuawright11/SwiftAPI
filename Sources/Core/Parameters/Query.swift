protocol AnyQuery {
    var value: Any { get }
}

@propertyWrapper
public struct Query<T>: AnyQuery {
    public var wrappedValue: T
    var value: Any { wrappedValue }
    public init(wrappedValue: T) { self.wrappedValue = wrappedValue }
}
