protocol AnyQuery {
    var value: Any { get }
}

@propertyWrapper struct Query<T>: AnyQuery {
    var wrappedValue: T
    var value: Any { wrappedValue }
}
