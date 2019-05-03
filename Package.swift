// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Serverless-Swift",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.11.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.7.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Compression.git", from: "2.2.2"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.8.1")
    ],
    targets: [
        .target(
            name: "Serverless-Swift",
            dependencies: ["KituraStencil", "Kitura", "KituraCompression", "HeliumLogger"]),
        .testTarget(
            name: "Serverless-SwiftTests",
            dependencies: ["Serverless-Swift"]),
    ]
)
