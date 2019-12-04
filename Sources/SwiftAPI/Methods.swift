@propertyWrapper
public class Method<Req, Res: Codable> {
    public var wrappedValue: Endpoint<Req, Res>

    init(_ method: HTTPMethod, _ path: String) {
        self.wrappedValue = Endpoint<Req, Res>(method: method, path: path)
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
public class POST<Req, Res: Codable>: Method<Req, Res> {
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
