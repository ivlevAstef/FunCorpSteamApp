// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Core", targets: ["Core"]),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "3.9.0")
    ],
    targets: [
        .target(name: "Core", dependencies: [
            .product(name: "Common"),
            .product(name: "DITranquillity")
        ], path: "./Sources"),
    ]
)
