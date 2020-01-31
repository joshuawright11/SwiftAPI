public struct Endpoint<Req: RequestDTO, Res: Codable> {
    public let method: HTTPMethod
    public var basePath: String
}
