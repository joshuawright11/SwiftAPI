/// Implement this for models you want to decode.
protocol RequestDecodable {
    init(from: RequestDecoder) throws
}

/// Implement this on the server side.
protocol RequestDecoderProvider {
    func headers() -> [String: String]
    func pathComponents() -> [String: String]
    func body<T: Decodable>() throws -> T
    func queryDict() -> [String: Any]
}

protocol RequestDecoder {
    func header(for key: String) throws -> String
    func query<T: Any>(for key: String) throws -> T
    func body<T: Decodable>() throws -> T
    func pathComponent(for key: String) throws -> String
}

extension RequestDecoder {
    func load<T: RequestDecodable>(_ type: T.Type) throws -> T {
        try T(from: self)
    }
}

private struct DecodingHelper: RequestDecoder {
    var provider: RequestDecoderProvider
    var headers: [String: String] = [:]
    var pathComponents: [String: String] = [:]
    var queries: [String: Any] = [:]

    init(provider: RequestDecoderProvider) {
        self.provider = provider
        self.headers = provider.headers()
        self.pathComponents = provider.pathComponents()
        self.queries = provider.queryDict()
    }

    func header(for key: String) throws -> String {
        try self.headers[key].unwrap(or: SwiftAPIError(message: "Expected `\(key)` in the request headers."))
    }

    func query<T>(for key: String) throws -> T {
        let value = try self.queries[key]
            .unwrap(or: SwiftAPIError(message: "Expected `\(key)` in the request query."))

        guard let castValue = value as? T else {
            throw SwiftAPIError(message: "Found `\(key)` in the request query, but it was of type `\(type(of: value))` instead of expected type `\(T.self)`.")
        }

        return castValue
    }

    func body<T>() throws -> T where T : Decodable {
        do {
            return try self.provider.body()
        } catch {
            throw SwiftAPIError(message: "Encountered an error decoding the body to type `\(T.self)`: \(error)")
        }
    }

    func pathComponent(for key: String) throws -> String {
        try self.pathComponents[key]
            .unwrap(or: SwiftAPIError(message: "Expected `\(key)` in the request path components."))
    }
}

extension Optional {
    func unwrap(or error: Error) throws -> Wrapped {
        guard let value = self else {
            throw error
        }

        return value
    }
}
