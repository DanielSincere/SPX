// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "SPXScripts",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.3.0"),
  ],
  targets: [
    .executableTarget(
      name: "date",
      dependencies: ["Sh"]),
  ]
)
