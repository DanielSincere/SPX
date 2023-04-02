// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SwishScriptsForSwish",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-system", from: "1.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "generate-scaffold-code",
      dependencies: [
        "Sh",
        .product(name: "SystemPackage", package: "swift-system"),
      ]),
  ]
)
