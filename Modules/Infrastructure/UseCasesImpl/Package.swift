// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UseCasesImpl",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "UseCasesImpl", targets: ["UseCasesImpl"]),
    ],
    dependencies: [
        .package(path: "../../Domain/UseCases"),
        .package(path: "../../Domain/UseCasesContracts"),
        .package(path: "../../Domain/Entities"),
        .package(path: "../../Core"),
        .package(path: "../../Common"),
    ],
    targets: [
        .target(name: "UseCasesImpl", dependencies: [
            .product(name: "Entities"),
            .product(name: "UseCases"),
            .product(name: "UseCasesContracts"),
            .product(name: "Core"),
            .product(name: "Common")
        ], path: "./Sources"),
    ]
)
