// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Services", targets: ["Services"]),
    ],
    dependencies: [
        .package(path: "../../Core"),
    ],
    targets: [
        .target(name: "Services", dependencies: [
            .product(name: "Core"),
        ], path: "./Sources"),
    ]
)
