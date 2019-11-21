// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [
        .package(path: "../../Domain/Services"),
        .package(path: "../../Core"),
        .package(path: "../../Common"),
    ],
    targets: [
        .target(name: "Storage", dependencies: [
            "Services",
            "Core",
            "Common"
        ], path: "./Sources"),
    ]
)
