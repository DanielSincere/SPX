// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "SPXScripts",
    platforms: [.macOS(.v12)],
    products: [ ],
    dependencies: [
        .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "docker",
            dependencies: ["Sh"]),
        .executableTarget(
            name: "UpdateAndTest",
            dependencies: ["Sh"]),
    ]
)
