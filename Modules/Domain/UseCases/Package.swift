// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UseCases",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "UseCases", targets: ["UseCases"]),
    ],
    dependencies: [
        .package(path: "../../Core"),
        .package(path: "../Entities"),
    ],
    targets: [
        .target(name: "UseCases", dependencies: [
            .product(name: "Core"),
            .product(name: "Entities"),
        ], path: "./Sources"),
    ]
)
