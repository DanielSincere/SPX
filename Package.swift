// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SPX",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .executable(name: "spx", targets: ["spx"]),
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
  ],
  targets: [
    .executableTarget(
      name: "spx",
      dependencies: ["SPXLib"]),
    .target(
      name: "SPXLib",
      dependencies: ["Sh", "Rainbow"]),
    .testTarget(
      name: "SPXTests",
      dependencies: ["SPXLib"],
      resources: [
        .copy("Fixtures"),
      ]),
  ]
)
