// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Network", targets: ["Network"]),
    ],
    dependencies: [
        .package(path: "../../Domain/Services"),
        .package(path: "../../Core"),
        .package(path: "../../Common"),
    ],
    targets: [
        .target(name: "Network", dependencies: [
            "Services",
            "Core",
            "Common"
        ], path: "./Sources"),
    ]
)
