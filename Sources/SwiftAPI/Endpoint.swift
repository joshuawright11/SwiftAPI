public struct Endpoint<Req, Res: Codable> {
    public var method: HTTPMethod
    public var path: String
    public var headers: [String: String] = [:]
    public var queryParams: [String: String] = [:]
    public var body: Codable?
}

public extension Endpoint {
    mutating func update(_ req: Req) {
        // First, check to see if it's an empty
        guard !(req is Empty) else {
            return
        }
        
        // Second, attempt to load request params out
        let mirror = Mirror(reflecting: req)
        var hadParam = false
        for child in mirror.children {
            if let val = child.value as? Query {
                hadParam = true
                queryParams[val.pathKey] = val.wrappedValue
            } else if let val = child.value as? Header {
                hadParam = true
                headers[val.pathKey] = val.wrappedValue
            } else if let val = child.value as? Path {
                hadParam = true
                self.path = self.path.replacingOccurrences(of: ":\(val.pathKey):", with: val.wrappedValue)
            } else if let val = child.value as? BodyBase {
                hadParam = true
                self.body = val.bodyValue
            }
        }
        
        // If there was a param, we're done
        guard !hadParam else {
            return
        }
        
        /// Finally, if there were no params above, put the Req in the body if it's codable
        if let req = req as? Codable {
            self.body = req
        }
    }
}
