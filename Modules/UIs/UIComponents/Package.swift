// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "UIComponents", targets: ["UIComponents"]),
    ],
    dependencies: [
        .package(path: "../Design"),
        .package(path: "../../Core"),
        .package(path: "../../Common"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1")
    ],
    targets: [
        .target(name: "UIComponents", dependencies: [
            .product(name: "Design"),
            .product(name: "Core"),
            .product(name: "Common"),
            .product(name: "SnapKit"),
        ], path: "./Sources"),
    ]
)
