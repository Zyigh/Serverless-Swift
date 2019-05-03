// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Serverless-Swift",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.11.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.7.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Compression.git", from: "2.2.2")
    ],
    targets: [
        .target(
            name: "Serverless-Swift",
            dependencies: ["KituraStencil", "Kitura", "KituraCompression"]),
        .testTarget(
            name: "Serverless-SwiftTests",
            dependencies: ["Serverless-Swift"]),
    ]
)
