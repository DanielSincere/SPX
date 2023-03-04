// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SwishScripts",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
    .package(url: "https://github.com/FullQueueDeveloper/ShXcrun.git", from: "0.3.0"),
    .package(url: "https://github.com/FullQueueDeveloper/SwishXCAssets.git", from: "0.3.2"),
  ],
  targets: [
    .executableTarget(
      name: "appstore",
      dependencies: ["Sh", "ShXcrun"]),
    .executableTarget(
      name: "appicon",
      dependencies: ["SwishXCAssets"]),
  ]
)
