// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UseCasesContracts",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "UseCasesContracts", targets: ["UseCasesContracts"]),
    ],
    dependencies: [
        .package(path: "../UseCases"),
        .package(path: "../Entities"),
    ],
    targets: [
        .target(name: "UseCasesContracts", dependencies: [
            .product(name: "UseCases"),
            .product(name: "Entities"),
        ], path: "./Sources"),
    ]
)
