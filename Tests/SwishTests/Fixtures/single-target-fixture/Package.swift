// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Single Target Fixture",
  dependencies: [],
  targets: [
    .executableTarget(
      name: "example",
      dependencies: []),
  ]
)
