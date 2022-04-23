// swift-tools-version: 5.5

import PackageDescription

let package = Package(
  name: "Swish",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .executable(name: "swish", targets: ["Swish"]),
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "Swish",
      dependencies: ["Sh", "Rainbow"]),
    .testTarget(
      name: "SwishTests",
      dependencies: ["Swish"]),
  ]
)
