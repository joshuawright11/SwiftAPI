import SwiftAPI
import Vapor

extension Empty: Content {}

public extension RoutesBuilder {
    /// Register an Endpoint.
    func register<Req, Res>(_ endpoint: Endpoint<Req, Res>,
                            use closure: @escaping (Request, Req) throws -> EventLoopFuture<Res>)
        where Req: RequestLoadable, Res: Content
    {
        let wrappingClosure = { (request: Request) -> EventLoopFuture<Res> in
            try closure(request, try request.load(Req.self))
        }
        registerRequest(endpoint, wrappingClosure)
    }
    
    /// Register an Endpoint with Empty request type.
    func register<Res>(_ endpoint: Endpoint<Empty, Res>,
                       use closure: @escaping (Request) throws -> EventLoopFuture<Res>) where Res: Content
    {
        registerRequest(endpoint, closure)
    }
    
    private func registerRequest<Req, Res>(_ endpoint: Endpoint<Req, Res>,
                                           _ closure: @escaping (Request) throws -> EventLoopFuture<Res>)
        where Res: Content
    {
        self.on(endpoint.method.nio, endpoint.pathComponents, use: closure)
    }
}

private extension Endpoint {
    var pathComponents: [PathComponent] {
        self.basePath.split(separator: "/")
            .map { PathComponent(stringLiteral: String($0)) }
    }
}
