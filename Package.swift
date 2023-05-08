// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings = [SwiftSetting.unsafeFlags([
    "-Xfrontend", "-strict-concurrency=complete",
    "-Xfrontend", "-warn-concurrency",
    "-Xfrontend", "-enable-actor-data-race-checks",
])]

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
            dependencies: [],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "CleevioCoreTests",
            dependencies: ["CleevioCore"],
            swiftSettings: swiftSettings
        )
    ]
)
