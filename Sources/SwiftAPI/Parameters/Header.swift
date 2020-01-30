protocol AnyHeader {
    var value: String { get }
}

@propertyWrapper struct _Header: AnyHeader {
    var wrappedValue: String
    var value: String { wrappedValue }
}
