public struct Endpoint<Req, Res: Codable> {
    public let method: HTTPMethod
    public var path: String
    public var headers: [String: String] = [:]
    public var queryParams: [String: String] = [:]
}

public extension Endpoint {
    func update(_ req: Req) -> Endpoint {
        var this = self
        
        // First, check to see if it's an empty
        guard !(req is Empty) else {
            return this
        }
        
        // Then, attempt to load request params out
        let mirror = Mirror(reflecting: req)
        for child in mirror.children {
            if let val = child.value as? Query {
                this.queryParams[val.pathKey] = val.wrappedValue
            } else if let val = child.value as? Header {
                this.headers[val.pathKey] = val.wrappedValue
            } else if let val = child.value as? Path {
                this.path = this.path.replacingOccurrences(of: ":\(val.pathKey):", with: val.wrappedValue)
            }
        }
        
        return this
    }
}
