// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwishScripts",
    platforms: [.macOS(.v11)],
    products: [ ],
    dependencies: [
        .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.0.0"),
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
