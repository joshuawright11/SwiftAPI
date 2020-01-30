import Foundation

public struct Endpoint<Req, Res: Codable> {
    public let method: HTTPMethod
    public var path: String

    public var body: Data?
    public var pathParams: [String: String] = [:]
    public var headers: [String: String] = [:]
    public var queryParams: [String: String] = [:]
}

public extension Endpoint {
    func update(_ req: Req) throws -> Endpoint {
        var this = self
        
        // First, check to see if it's an empty
        guard !(req is Void) else {
            return this
        }
        
        // Then, attempt to load request params out
        var isParamsPulled = false
        if let req = req as? BodyLoadable {
            this.body = try req.getBodyData()
            isParamsPulled = true
        }
        if let req = req as? HeaderLoadable {
            this.headers = try req.getHeaderDict()
            isParamsPulled = true
        }
        if let req = req as? QueryLoadable {
            this.queryParams = try req.getQueryDict()
            isParamsPulled = true
        }
        if let req = req as? PathLoadable {
            this.pathParams = try req.getPathDict()
            isParamsPulled = true
        }
        
        // If no params were pulled from the request object, assume it's a body into the body
        if !isParamsPulled, let req = req as? Encodable {
            this.body = try req.toJSONData()
        }

        return this
    }
    
    var queryString: String {
        guard !queryParams.isEmpty else {
            return ""
        }
        
        return "?" + queryParams.compactMap { param in
            param.value.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
                .map { "\(param.key)" + ($0.isEmpty ? "" : "=\($0)") }
        }.joined(separator: "&")
    }
}

private extension Encodable {
    func toJSONData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}


private extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}
