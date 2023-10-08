// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "PluginsPackage",
  platforms: [
    .macOS(.v13),
  ],
  products: [
    .executable(
      name: "GenerateTemplatesTool",
      targets: ["GenerateTemplatesTool"]),
  ],
  dependencies: [],
  targets: [
    .executableTarget(
      name: "GenerateTemplatesTool",
      dependencies: [])
  ]
)
