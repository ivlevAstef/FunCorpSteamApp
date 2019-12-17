// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Entities",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Entities", targets: ["Entities"]),
    ],
    dependencies: [
        .package(path: "../../Common"),
    ],
    targets: [
        .target(name: "Entities", dependencies: [
            .product(name: "Common"),
        ], path: "./Sources"),
    ]
)
