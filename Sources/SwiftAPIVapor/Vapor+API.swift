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
        let parameters = try dto.parameters(baseURL: self.baseURL, method: endpoint.method)
        return request.performRequest(parameters)
    }
    
    public func request<Res>(_ endpoint: Endpoint<SwiftAPI.Empty, Res>, _ request: Request)
        -> EventLoopFuture<Res>
    {
        request.performRequest(.just(url: baseURL + endpoint.basePath, method: endpoint.method))
    }
}

private extension Request {
    func performRequest<Response: Codable>(_ parameters: RequestParameters) -> EventLoopFuture<Response> {
        self.client.send(parameters.method.nio, headers: HTTPHeaders(parameters.headers.map { $0 }),
                         to: URI(string: parameters.fullURL))
        {
            guard let data = parameters.body else {
                return
            }
            
            var buffer = ByteBufferAllocator().buffer(capacity: data.count)
            buffer.writeBytes(data)
            $0.body = buffer
        }
        .flatMapThrowing { response in
            guard response.status.isSuccess else {
                print("[SwiftAPIVapor] Error: Got status code `\(response.status.code)` hitting `\(parameters.fullURL)`. The response body was \(response.content).")
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