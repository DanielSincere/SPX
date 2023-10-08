// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "SPX",
  platforms: [
    .macOS(.v13),
  ],
  products: [
    .executable(name: "spx", targets: ["spx"]),
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.3.0"),
//    .package(path: "PluginsPackage"),
  ],
  targets: [
    .executableTarget(
      name: "spx",
      dependencies: ["SPXLib"]),
    .target(
      name: "SPXLib",
      dependencies: ["Sh", "Rainbow", ],
      plugins: [
        .plugin(name: "GenerateTemplatesPlugin")
      ]
    ),
    .testTarget(
      name: "SPXTests",
      dependencies: ["SPXLib"],
      resources: [
        .copy("Fixtures"),
      ]),
    .plugin(
      name: "GenerateTemplatesPlugin",
      capability: .buildTool,
      dependencies: [
        "GenerateTemplatesTool"
      ]
    ),
    .executableTarget(name: "GenerateTemplatesTool",
                     dependencies: [])
  ]
)
