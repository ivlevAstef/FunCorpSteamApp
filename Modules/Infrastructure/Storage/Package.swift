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
    ],
    targets: [
        .target(name: "Storage", dependencies: [], path: "./Sources"),
    ]
)
