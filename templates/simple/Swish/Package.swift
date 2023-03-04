// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SwishScripts",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
  ],
  targets: [
    .executableTarget(
      name: "date",
      dependencies: ["Sh"]),
  ]
)
