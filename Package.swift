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
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.2"),
    ],
    targets: [
        /// Main targets
        .target(name: "SwiftAPI", dependencies: [], path: "Sources/Core"),
        .target(name: "SwiftAPIClient", dependencies: ["Alamofire", "SwiftAPI"], path: "Sources/Client"),
        .target(name: "SwiftAPIVapor", dependencies: ["Vapor", "SwiftAPI"], path: "Sources/Vapor"),

        /// Test targets
        .testTarget(name: "SwiftAPITests", dependencies: ["SwiftAPI"]),
    ]
)
