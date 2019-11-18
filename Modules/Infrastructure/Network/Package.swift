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
    ],
    targets: [
        .target(name: "Network", dependencies: [], path: "./Sources"),
    ]
)
