// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dota",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Dota", targets: ["Dota"]),
    ],
    dependencies: [
        .package(path: "../GameInformation"),
    ],
    targets: [
        .target(name: "Dota", dependencies: [
            .product(name: "GameInformation"),
        ], path: "./Sources"),
    ]
)
