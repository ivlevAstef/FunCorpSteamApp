// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "News",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "News", targets: ["News"]),
    ],
    dependencies: [
        .package(path: "../../AppUIComponents"),
        .package(path: "../../UIComponents"),
        .package(path: "../../Design"),
        .package(path: "../../../Core"),
        .package(path: "../../../Common"),
    ],
    targets: [
        .target(name: "News", dependencies: [
            .product(name: "AppUIComponents"),
            .product(name: "UIComponents"),
            .product(name: "Design"),
            .product(name: "Core"),
            .product(name: "Common"),
        ], path: "./Sources"),
    ]
)
