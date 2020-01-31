import SwiftAPI
import Vapor

extension SwiftAPI.HTTPMethod {
    var nio: NIOHTTP1.HTTPMethod {
        switch self {
        case .delete:   return .DELETE
        case .get:      return .GET
        case .patch:    return .PATCH
        case .post:     return .POST
        case .put:      return .PUT
        }
    }
}
