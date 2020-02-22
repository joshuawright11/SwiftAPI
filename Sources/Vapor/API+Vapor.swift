import AsyncHTTPClient
import SwiftAPI
import Vapor

public struct API {
    /// The baseURL of all endpoints this requests
    let baseURL: String
    
    /// TODO add auth interceptors
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func request<Req, Res>(_ endpoint: Endpoint<Req, Res>, _ dto: Req, _ request: Request) throws
        -> EventLoopFuture<Res>
    {
        let parameters = try endpoint.parameters(dto: dto)
        return request.performRequest(baseURL: self.baseURL, parameters)
    }
    
    public func request<Res>(_ endpoint: Endpoint<SwiftAPI.Empty, Res>, _ request: Request)
        -> EventLoopFuture<Res>
    {
        request.performRequest(baseURL: self.baseURL, .just(url: endpoint.basePath, method: endpoint.method))
    }
}

private extension Request {
    func performRequest<Response: Codable>(baseURL: String, _ parameters: RequestParameters) -> EventLoopFuture<Response> {
        let fullURL = baseURL + parameters.fullPath
        return self.client.send(parameters.method.nio, headers: HTTPHeaders(parameters.headers.map { $0 }),
                         to: URI(string: fullURL))
        {
            guard let body = parameters.body else {
                return
            }
            
            try $0.content.encode(body.content, as: body.contentType.httpMediaType)
        }
        .flatMapThrowing { response in
            guard response.status.isSuccess else {
                print("[SwiftAPIVapor] Error: Got status code `\(response.status.code)` hitting `\(fullURL)`. The response was \(response.description).")
                throw Abort(response.status)
            }
            
            return try response.content.decode(Response.self)
        }
    }
}

private extension HTTPStatus {
    var isSuccess: Bool {
        self.code >= 200 && self.code <= 299
    }
}

private extension ContentType {
    var httpMediaType: HTTPMediaType {
        switch self {
        case .json:       return .json
        case .urlEncoded: return .urlEncodedForm
        }
    }
}
