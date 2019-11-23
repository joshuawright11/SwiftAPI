public struct Empty: Codable {
    public static let empty = Empty()
}

open class APIGroup {
    public init() {}
}

public struct Endpoint<Req: Codable, Res: Codable> {
    public var path: String
    public var method: HTTPMethod
}

public enum HTTPMethod: String {
    case post, put, get, delete, patch
}

@propertyWrapper
public class Method<Req: Codable, Res: Codable> {
    public var wrappedValue: Endpoint<Req, Res>

    init(_ method: HTTPMethod, _ path: String) {
        self.wrappedValue = Endpoint<Req, Res>(path: path, method: method)
    }
}

@propertyWrapper
public class GET<Req: Codable, Res: Codable>: Method<Req, Res> {
    // https://forums.swift.org/t/is-it-allowed-to-inherit-a-property-wrapper-class/28695
    public override var wrappedValue: Endpoint<Req, Res> { didSet {} }
    
    public init(_ path: String) {
        super.init(.get, path)
    }
}

@propertyWrapper
public class POST<Req: Codable, Res: Codable>: Method<Req, Res> {
    // https://forums.swift.org/t/is-it-allowed-to-inherit-a-property-wrapper-class/28695
    public override var wrappedValue: Endpoint<Req, Res> { didSet {} }

    public init(_ path: String) {
        super.init(.get, path)
    }
}

@propertyWrapper
public class PUT<Req: Codable, Res: Codable>: Method<Req, Res> {
    // https://forums.swift.org/t/is-it-allowed-to-inherit-a-property-wrapper-class/28695
    public override var wrappedValue: Endpoint<Req, Res> { didSet {} }

    public init(_ path: String) {
        super.init(.get, path)
    }
}

@propertyWrapper
public class PATCH<Req: Codable, Res: Codable>: Method<Req, Res> {
    // https://forums.swift.org/t/is-it-allowed-to-inherit-a-property-wrapper-class/28695
    public override var wrappedValue: Endpoint<Req, Res> { didSet {} }

    public init(_ path: String) {
        super.init(.get, path)
    }
}

@propertyWrapper
public class DELETE<Req: Codable, Res: Codable>: Method<Req, Res> {
    // https://forums.swift.org/t/is-it-allowed-to-inherit-a-property-wrapper-class/28695
    public override var wrappedValue: Endpoint<Req, Res> { didSet {} }

    public init(_ path: String) {
        super.init(.get, path)
    }
}
