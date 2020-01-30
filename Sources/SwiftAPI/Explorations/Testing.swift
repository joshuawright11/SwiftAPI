import Foundation

@propertyWrapper struct _POST<Req, Res: Codable> {
    var wrappedValue: Endpoint<Req, Res>
    var path: String

    init(_ path: String) {
        self.path = path
        self.wrappedValue = .init(method: .post, path: path)
    }
}
