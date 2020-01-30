protocol RequestDecodable {
    init(from: RequestDecoder) throws
}

protocol RequestDecoder {
    func header(for key: String) throws -> String
    func path(for key: String) throws -> String
    func body<T: Decodable>(for key: String) throws -> T
    func query<T: Decodable>(for key: String) throws -> T
}

extension RequestDecoder {
    func load<T: RequestDecodable>(_ type: T.Type) throws -> T {
        try T(from: self)
    }
}
