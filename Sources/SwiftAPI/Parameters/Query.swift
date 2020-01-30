protocol AnyQuery {
    var value: Any { get }
}

@propertyWrapper struct _Query<T>: AnyQuery {
    var wrappedValue: T
    var value: Any { wrappedValue }
}
