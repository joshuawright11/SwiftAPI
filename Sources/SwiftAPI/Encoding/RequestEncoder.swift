import Foundation

protocol RequestEncoder {
    /// Set the HTTP method of the request
    func setMethod(_ method: HTTPMethod)
    /// Set the headers of the request
    func setHeaders(_ headers: [String: String])
    /// Set the path, which includes escaped queries
    func setPath(_ path: String)
    /// Set the body, if there is one
    func setBody(_ data: Data?)
}
