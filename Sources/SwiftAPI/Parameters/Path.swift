protocol AnyPath {
    var value: String { get }
}

@propertyWrapper struct Path: AnyPath {
    var wrappedValue: String
    var value: String { wrappedValue }
}
