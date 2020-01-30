import Foundation

/// Conform your request objects to this.
public protocol RequestDTO {
    func parameters(baseURL: String, method: HTTPMethod) throws -> RequestParameters
}

public extension RequestDTO {
    func parameters(baseURL: String, method: HTTPMethod) throws -> RequestParameters {
        let helper = EncodingHelper(self)
        return RequestParameters(method: method, headers: helper.getHeaders(),
                                 fullURL: try helper.getFullURL(baseURL), body: try helper.getBody())
    }
}

public struct RequestParameters {
    public let method: HTTPMethod
    public let headers: [String: String]
    public let fullURL: String
    public let body: Data?
}

struct EncodingHelper {
    private var bodies: [String: AnyBody] = [:]
    private var headers: [String: AnyHeader] = [:]
    private var queries: [String: AnyQuery] = [:]
    private var paths: [String: AnyPath] = [:]

    fileprivate init<T>(_ value: T) {
        Mirror(reflecting: value)
            .children
            .forEach { child in
                guard let label = child.label else {
                    return print("No label on a child")
                }

                let sanitizedLabel = String(label.dropFirst())
                if let query = child.value as? AnyQuery {
                    self.queries[sanitizedLabel] = query
                } else if let body = child.value as? AnyBody {
                    self.bodies[sanitizedLabel] = body
                } else if let header = child.value as? AnyHeader {
                    self.headers[sanitizedLabel] = header
                } else if let path = child.value as? AnyPath {
                    self.paths[sanitizedLabel] = path
                }
            }
    }

    func getFullURL(_ baseURL: String) throws -> String {
        try self.replacedPath(baseURL) + self.queryString()
    }

    private func replacedPath(_ basePath: String) throws -> String {
        try self.paths.reduce(into: basePath) { basePath, component in
            guard basePath.contains("{\(component.key)}") else {
                throw SwiftAPIError(message: "Tried to encode path component '\(component.key)' but didn't find any instance of '{\(component.key)}' in the path.")
            }

            basePath = basePath.replacingOccurrences(of: "{\(component.key)}", with: component.value.value)
        }
    }

    private func queryString() -> String {
        self.queries.isEmpty ? "" :
            "?" + self.queries.sorted { $0.key < $1.key }
            .reduce(into: []) { list, query in
                list += self.queryComponents(fromKey: query.key, value: query.value.value)
            }
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
    }

    func getBody() throws -> Data? {
        guard self.bodies.count <= 1 else {
            throw SwiftAPIError(message: "Only one `@Body` attribute is allowed per request.")
        }

        return try self.bodies.first?.value.toData()
    }

    func getHeaders() -> [String: String] {
        self.headers.reduce(into: [String: String]()) { dict, val in
            dict[val.key] = val.value.value
        }
    }
}
