protocol AnyPath {
    var value: String { get }
}

@propertyWrapper struct _Path: AnyPath {
    var wrappedValue: String
    var value: String { wrappedValue }
}
