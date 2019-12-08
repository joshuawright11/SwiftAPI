import Foundation

// Endpoint Has:
// 0. Method
// 1. Path
// 2. Params
// 3. Response

// Params Have:
// 0. Headers       (apiKey: "f1o2o3-b4a5r6-b7a8z9")
// 1. Query         (/places?sorted=true&include_countries=false)
// 2. URL Params    (DELETE /v1/:user_id:)
// 3. Body          ({ name: "josh", age: 26 })

// Each param protocol needs to...
// 1. Put self into networking request obj
// 2. Load self from server Request

public struct SomeResponse: Codable {
    public var name: String
    public var age: Int
}

public struct SomeRequest: Body, Query, Headers, Path {
    public var body: SomeRequestBody
    public var query: SomeRequestQuery
    public var headers: SomeRequestHeaders
    public var path: SomePathParameters
}

public struct SomePathParameters: Codable {
    var userID: String
    var postID: String
}

public struct SomeRequestBody: Codable {
    public var thing: String
}

public struct SomeRequestQuery: Codable {
    public var thing: String
}

public struct SomeRequestHeaders: Codable {
    public var thing: String
}

public protocol PathLoadable {
    func getPathDict() throws -> [String: String]
}

public protocol Path: PathLoadable {
    associatedtype PathType: Codable
    var path: PathType { get }
}

extension Path {
    public func getPathDict() throws -> [String : String] {
        guard let dict = path.dictionary as? [String: String] else {
            throw EncodingError(info: "All path properties must be strings")
        }
        
        return dict
    }
}

public protocol BodyLoadable {
    func getBodyData() throws -> Data?
}

public protocol Body: BodyLoadable {
    associatedtype BodyType: Codable
    var body: BodyType { get }
}

extension Body {
    public func getBodyData() throws -> Data? {
        return try JSONEncoder().encode(body)
    }
}

public protocol QueryLoadable {
    func getQueryDict() throws -> [String: String]
}

public protocol Query: QueryLoadable {
    associatedtype QueryType: Codable
    var query: QueryType { get }
}

extension Query {
    public func getQueryDict() throws -> [String : String] {
        guard let dict = query.dictionary as? [String: String] else {
            throw EncodingError(info: "All query properties must be strings")
        }
        
        return dict
    }
}

public protocol HeaderLoadable {
    func getHeaderDict() throws -> [String: String]
}

public protocol Headers: HeaderLoadable {
    associatedtype HeadersType: Codable
    var headers: HeadersType { get }
}

extension Headers {
    public func getHeaderDict() throws -> [String : String] {
        guard let dict = headers.dictionary as? [String: String] else {
            throw EncodingError(info: "All header properties must be strings")
        }
        
        return dict
    }
}

struct JSON {
    static let encoder = JSONEncoder()
}

struct EncodingError: Error {
    var info: String
}

extension Encodable {
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
