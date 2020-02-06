import Foundation
import SwiftAPI
import Vapor

extension Request: RequestDecoder {
    public func header(for key: String) throws -> String {
        try self.headers.first(name: key)
            .unwrap(or: SwiftAPIError(message: "Expected `\(key)` in the request headers."))
    }
    
    public func query<T: Decodable>(for key: String) throws -> T {
        do {
            return try self.query.get(T.self, at: key)
        } catch {
            throw SwiftAPIError(message: "Encountered an error getting `\(key)` from the request query. \(error).")
        }
    }
    
    public func pathComponent(for key: String) throws -> String {
        return try self.parameters.get(key)
            .unwrap(or: SwiftAPIError(message: "Expected `\(key)` in the request path components."))
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
