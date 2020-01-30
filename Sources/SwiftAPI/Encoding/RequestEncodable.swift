import Foundation

protocol RequestEncodable {
    func encode(to encoder: RequestEncoder, basePath: String, method: HTTPMethod) throws
}

extension RequestEncodable {
    func encode(to encoder: RequestEncoder, basePath: String, method: HTTPMethod) throws {
        let helper = EncodingHelper(self)
        encoder.setMethod(method)
        encoder.setPath(try helper.getFullPath(basePath))
        encoder.setHeaders(helper.getHeaders())
        encoder.setBody(try helper.getBody())
    }
}

struct EncodingHelper {
    var bodies: [String: AnyBody] = [:]
    var headers: [String: AnyHeader] = [:]
    var queries: [String: AnyQuery] = [:]
    var paths: [String: AnyPath] = [:]

    init<T>(_ value: T) {
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

    func getFullPath(_ basePath: String) throws -> String {
        try self.replacedPath(basePath) + self.queryString()
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
