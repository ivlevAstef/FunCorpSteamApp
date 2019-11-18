// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Models", targets: ["Models"]),
    ],
    dependencies: [
        .package(path: "../../Core"),
    ],
    targets: [
        .target(name: "Models", dependencies: [
            .product(name: "Core"),
        ], path: "./Sources"),
    ]
)
