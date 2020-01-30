struct SwiftAPIError: Error, CustomStringConvertible {
    let message: String
    var description: String { "[SwiftAPIError] \(self.message)" }
}
