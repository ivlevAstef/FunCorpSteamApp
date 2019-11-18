// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Design",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Design", targets: ["Design"]),
    ],
    dependencies: [
        .package(path: "../../Core"),
        .package(path: "../../Common"),
    ],
    targets: [
        .target(name: "Design", dependencies: [
            .product(name: "Core"),
            .product(name: "Common"),
        ], path: "./Sources"),
    ]
)
