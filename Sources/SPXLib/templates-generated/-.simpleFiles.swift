extension Templates {
  static let simpleFiles: [ScaffoldFile] = [
    ScaffoldFile(directory: "SPX",
             name: "Package.resolved",
             contents: #"""
{
  "pins" : [
    {
      "identity" : "rainbow",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/onevcat/Rainbow",
      "state" : {
        "revision" : "e0dada9cd44e3fa7ec3b867e49a8ddbf543e3df3",
        "version" : "4.0.1"
      }
    },
    {
      "identity" : "sh",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/FullQueueDeveloper/Sh.git",
      "state" : {
        "revision" : "a40bba19d8085761e051fa1f0d5937259fa2e17a",
        "version" : "1.2.0"
      }
    }
  ],
  "version" : 2
}

"""#),
ScaffoldFile(directory: "SPX",
             name: ".gitignore",
             contents: #"""
.DS_Store
.swiftpm
.build

"""#),
ScaffoldFile(directory: "SPX",
             name: "Package.swift",
             contents: #"""
// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SPXScripts",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
  ],
  targets: [
    .executableTarget(
      name: "date",
      dependencies: ["Sh"]),
  ]
)

"""#),
ScaffoldFile(directory: "SPX/Sources/date",
             name: "main.swift",
             contents: #"""
import Sh
import Foundation

let cmd =
"""
date +%s
"""
let timeInterval = try sh(TimeInterval.self, cmd)
let date = Date(timeIntervalSince1970: timeInterval)
print(date)

"""#),
  ]
}