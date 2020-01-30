import Foundation
import SwiftAPI
import Vapor

extension Request: RequestDecoder {
    public func header(for key: String) throws -> String {
        try self.headers.first(name: key)
            .unwrap(or: SwiftAPIError(message: "Expected `\(key)` in the request headers."))
    }
    
    public func query<T>(for key: String) throws -> T {
        let value = try self.query.get(String.self, at: key)
        
        guard let castValue = value as? T else {
            throw SwiftAPIError(message: "Found `\(key)` in the request query, but it was of type `\(type(of: value))` instead of expected type `\(T.self)`.")
        }

        return castValue
    }
    
    public func pathComponent(for key: String) throws -> String {
        do {
            return try self.pathComponent(for: key)
        } catch {
            throw SwiftAPIError(message: "Expected `\(key)` in the request path components.")
        }
    }
    
    public func body<T>() throws -> T where T : Decodable {
        do {
            return try self.content.decode(T.self)
        } catch {
            throw SwiftAPIError(message: "Encountered an error decoding the body to type `\(T.self)`: \(error)")
        }
    }
}

private extension Optional {
    func unwrap(or error: Error) throws -> Wrapped {
        guard let value = self else {
            throw error
        }

        return value
    }
}
