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
        guard !(req is Empty) else {
            return this
        }
        
        // Then, attempt to load request params out
        this.body = try (req as? BodyLoadable)?.getBodyData()
        if let req = req as? HeaderLoadable {
            this.headers = try req.getHeaderDict()
        }
        if let req = req as? QueryLoadable {
            this.queryParams = try req.getQueryDict()
        }
        if let req = req as? PathLoadable {
            this.pathParams = try req.getPathDict()
        }
        
        return this
    }
}
