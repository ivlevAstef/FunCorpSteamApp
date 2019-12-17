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
        .package(path: "../../Domain/UseCasesContracts"),
        .package(path: "../../Core"),
        .package(path: "../../Common"),
        .package(url: "https://github.com/realm/realm-cocoa.git", from: "4.1.1")
    ],
    targets: [
        .target(name: "Storage", dependencies: [
            "UseCasesContracts",
            "Core",
            "Common",
            "RealmSwift"
        ], path: "./Sources"),
    ]
)
