// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SPXScripts",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
  .package(url: "https://github.com/FullQueueDeveloper/ShGit.git", from: "1.0.0"),
  .package(url: "https://github.com/FullQueueDeveloper/ShXcrun.git", from: "0.2.0"),
  .package(url: "https://github.com/FullQueueDeveloper/SwishXCAssets.git", from: "0.3.2"),
  .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
  .package(url: "https://github.com/swiftpackages/DotEnv.git", from: "3.0.0"),
  .package(url: "https://github.com/mxcl/Version.git", from: "2.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "appstore",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "ShXcrun",
        "ShGit",
        "Sh",
        "DotEnv",
        "Version"
    ]),
    .executableTarget(
      name: "appicon",
      dependencies: ["SwishXCAssets"]),
  ]
)
