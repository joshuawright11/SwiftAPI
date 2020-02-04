/// Implement this for models you want to decode.
public protocol RequestLoadable {
    init(from: RequestDecoder) throws
}

/// Implement this on the server side.
public protocol RequestDecoder {
    func header(for key: String) throws -> String
    func query<T: Decodable>(for key: String) throws -> T
    func body<T: Decodable>() throws -> T
    func pathComponent(for key: String) throws -> String
}

public extension RequestDecoder {
    func load<T: RequestLoadable>(_ type: T.Type) throws -> T {
        try T(from: self)
    }
}
