// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CleevioCore",
    products: [
        .library(name: "CleevioCore", targets: ["CleevioCore"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "CleevioCore",
            dependencies: []),
        .testTarget(
            name: "CleevioCoreTests",
            dependencies: ["CleevioCore"]),
    ]
)
