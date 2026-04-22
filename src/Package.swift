// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TinyHomeEnd",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "TinyHomeEnd", targets: ["TinyHomeEnd"]),
        .executable(name: "TinyHomeEndApp", targets: ["TinyHomeEndApp"])
    ],
    targets: [
        .executableTarget(
            name: "TinyHomeEnd",
            dependencies: ["KeyBindingCore"]
        ),
        .executableTarget(
            name: "TinyHomeEndApp",
            dependencies: ["KeyBindingCore"],
            path: "Sources/TinyHomeEndApp"
        ),
        .target(
            name: "KeyBindingCore",
            dependencies: [],
            path: "Sources/KeyBindingCore"
        ),
        .testTarget(
            name: "KeyBindingCoreTests",
            dependencies: ["KeyBindingCore"]
        ),
    ]
)
