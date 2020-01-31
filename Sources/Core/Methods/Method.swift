public enum HTTPMethod: String {
    case post, put, get, delete, patch
}

public class Method<Req: RequestDTO, Res: Codable> {
    public var wrappedValue: Endpoint<Req, Res>

    init(_ method: HTTPMethod, _ basePath: String) {
        self.wrappedValue = Endpoint<Req, Res>(method: method, basePath: basePath)
    }
}
