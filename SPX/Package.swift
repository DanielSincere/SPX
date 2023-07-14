// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "SPXScriptsForSPX",
  platforms: [
    .macOS(.v13),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.3.0"),
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
