protocol AnyHeader {
    var value: String { get }
}

@propertyWrapper struct Header: AnyHeader {
    var wrappedValue: String
    var value: String { wrappedValue }
}
