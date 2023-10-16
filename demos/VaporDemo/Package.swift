// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "VaporDemo",
  platforms: [.macOS(.v13)],

  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.84.0"),
  ],
  targets: [
    .executableTarget(name: "Run",
      dependencies: [
        .target(name: "App"),
      ]
    ),
    .target(name: "App",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
      ]
    ),
    .testTarget(name: "AppTests",
      dependencies: [
        .target(name: "App"),
        .product(name: "XCTVapor", package: "vapor"),
      ])
  ]
)
