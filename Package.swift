// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Swish",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .executable(name: "swish", targets: ["swish"]),
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
  ],
  targets: [
    .executableTarget(
      name: "swish",
      dependencies: ["SwishLib"]),
    .target(
      name: "SwishLib",
      dependencies: ["Sh", "Rainbow"]),
    .testTarget(
      name: "SwishTests",
      dependencies: ["SwishLib"],
      resources: [
        .copy("Fixtures"),
      ]),
  ]
)
