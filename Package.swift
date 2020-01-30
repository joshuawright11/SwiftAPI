// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftAPI",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(name: "SwiftAPI", targets: ["SwiftAPI"]),
        .library(name: "SwiftAPIClient", targets: ["SwiftAPIClient"]),
        .library(name: "SwiftAPIVapor", targets: ["SwiftAPIVapor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .exact("4.0.0-beta.3.9")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0-rc.3"),
    ],
    targets: [
        .target(name: "SwiftAPI", dependencies: []),
        .target(name: "SwiftAPIClient", dependencies: ["Alamofire", "SwiftAPI"]),
        .target(name: "SwiftAPIVapor", dependencies: ["Vapor", "SwiftAPI"]),
        .testTarget(name: "SwiftAPITests", dependencies: ["SwiftAPI"]),
    ]
)
