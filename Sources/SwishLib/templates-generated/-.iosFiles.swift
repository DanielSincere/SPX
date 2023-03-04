extension Templates {
  static let iosFiles: [ScaffoldFile] = [
    ScaffoldFile(directory: "Swish",
             name: "README.md",
             contents: #"""
# iOS Swish Scripts

These are some scripts for managing your iOS project. Included in this template are a script to generate an app icon from an SVG (`swish appicon`) and a script to push to the App Store (`swish appstore`).

## App Store

This script archives your app & pushes it up to the App Store.

By default, it expects some environment variables, but of course feel free to get them how ever you like, perhaps using [Sh1Password](https://github.com/FullQueueDeveloper/Sh1Password.git).

- `APPLE_TEAM_ID` your development team ID in App Store Connect
- `APPLE_API_KEY_ID` your API Key ID from App Store Connect
- `APPLE_API_ISSUER_ID` your Issuer ID from App Store Connect

You could also use other kinds of credentials for uploading to the App Store, such as username and password, using [LiteralPasswordCredential](https://github.com/FullQueueDeveloper/ShXcrun/blob/trunk/Sources/ShXcrun/Altool/Credential/LiteralPasswordCredential.swift). This will require generate an app-specific password at https://appleid.apple.com.

Be sure to also update the scheme that is built. By default this is `App`. You may also want to update the script if you need to specify a project or workspace to `xcodebuild`.

## App icon

This script uses the SVG at `Swish/AppIcon.svg` by default. You may want to use a different SVG, but this will be useful for pushing to TestFlight.

You may also want to update the output directory to something that makes sense to you. By default, it outputs an `AppIcon.xcassets` to a directory name `App`.

"""#),
ScaffoldFile(directory: "Swish",
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
    },
    {
      "identity" : "shxcrun",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/FullQueueDeveloper/ShXcrun.git",
      "state" : {
        "revision" : "c84151a8c208de50f7ac5f3bcd096a538b4e120d",
        "version" : "0.3.0"
      }
    }
  ],
  "version" : 2
}

"""#),
ScaffoldFile(directory: "Swish",
             name: ".gitignore",
             contents: #"""
.DS_Store
.swiftpm
.build

"""#),
ScaffoldFile(directory: "Swish",
             name: "Package.swift",
             contents: #"""
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

"""#),
ScaffoldFile(directory: "Swish/Sources/appstore",
             name: "AppStoreMain.swift",
             contents: #"""
import Sh
import Foundation
import ShXcrun

@main
struct AppStoreMain {

  static func main() throws {
    let logRoot = "tmp/logs"
    let artifactRoot = "tmp/artifacts"

    try FileManager.default.resetDir(atPath: logRoot)
    try FileManager.default.resetDir(atPath: artifactRoot)

    let credential = try ApiKeyCredential(keyID: Secrets.apiKeyID.value(),
                                          issuerID: Secrets.apiIssuerID.value())

    try AppStore(logRoot: logRoot, artifactRoot: artifactRoot)
      .buildAndUpload(scheme: "App",
                      appleTeamID: Secrets.appleTeamID.value(),
                      uploadCredential: credential)
  }
}

extension FileManager {
  func resetDir(atPath path: String) throws {
    if FileManager.default.fileExists(atPath: path) {
      try FileManager.default.removeItem(atPath: path)
    }
    try FileManager.default.createDirectory(atPath: path,
                                            withIntermediateDirectories: true)
  }
}

"""#),
ScaffoldFile(directory: "Swish/Sources/appstore",
             name: "Secrets.swift",
             contents: #"""
import Foundation

enum Secrets: String {
  case appleTeamID = "APPLE_TEAM_ID"
  case apiKeyID = "APPLE_API_KEY_ID"
  case apiIssuerID = "APPLE_API_ISSUER_ID"

  func value() throws -> String {
    guard let v = ProcessInfo.processInfo.environment[rawValue] else {
      throw Missing(secret: self)
    }

    return v
  }

  struct Missing: Error, LocalizedError {
    let secret: Secrets

    var errorDescription: String {
      "Could not find \(secret.rawValue) in the environment"
    }
  }
}

"""#),
ScaffoldFile(directory: "Swish/Sources/appstore",
             name: "AppStore.swift",
             contents: #"""
import Foundation
import Sh
import ShXcrun
import Rainbow

struct AppStore {
  let logRoot: String
  let artifactRoot: String

  func buildAndUpload(scheme: String,
                      appleTeamID: String,
                      uploadCredential: AltoolCredential?) throws {

    let archivePath = "\(artifactRoot)/\(scheme).xcarchive"
    let exportOptionsPath = "\(artifactRoot)/\(scheme)-exportOptions.plist"
    let derivedDataPath = "\(artifactRoot)/DerivedData"

    print("=== Build start ===".cyan)

    let exportOptions = ExportOptions(compileBitcode: true,
                                      manageAppVersionAndBuildNumber: true,
                                      method: .appStore,
                                      teamID: appleTeamID,
                                      uploadBitcode: true,
                                      uploadSymbols: true)
    try exportOptions.write(to: exportOptionsPath)

    try sh(.file("\(logRoot)/\(scheme)-archive.log"),
    """
    xcrun xcodebuild archive -scheme \(scheme) \
    -destination "generic/platform=iOS" \
    -derivedDataPath "\(derivedDataPath)" \
    -archivePath "\(archivePath)"
    """)

    try sh(.file("\(logRoot)/\(scheme)-exportArchive.log"),
    """
    xcrun xcodebuild -exportArchive \
    -archivePath "\(archivePath)" \
    -exportPath \(artifactRoot) \
    -exportOptionsPlist \(exportOptionsPath)
    """)

    guard let credential = uploadCredential else {
      print("No credential for `altool` provided. Skipping upload".yellow)
      return
    }

    let altool = Altool(credential: credential)
    try altool.uploadApp(.file("\(logRoot)/upload.log"), file: "\(artifactRoot)/\(scheme).ipa", platform: .iOS)
  }
}


"""#),
ScaffoldFile(directory: "Swish/Sources/appicon",
             name: "main.swift",
             contents: #"""
import SwishXCAssets

let svgPath = "Swish/AppIcon.svg"
try await AppIcon(inputSVG: svgPath, outputDir: "App")
  .render(platforms: [.iPhone, .iPad])

"""#),
ScaffoldFile(directory: "Swish",
             name: "AppIcon.svg",
             contents: #"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->

<svg
   width="1024"
   height="1024"
   viewBox="0 0 270.93333 270.93333"
   version="1.1"
   id="svg5"
   inkscape:version="1.2.2 (b0a84865, 2022-12-01)"
   sodipodi:docname="Sample.svg"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <sodipodi:namedview
     id="namedview7"
     pagecolor="#ffffff"
     bordercolor="#000000"
     borderopacity="0.25"
     inkscape:showpageshadow="2"
     inkscape:pageopacity="0.0"
     inkscape:pagecheckerboard="0"
     inkscape:deskcolor="#d1d1d1"
     inkscape:document-units="px"
     showgrid="false"
     inkscape:zoom="0.39723196"
     inkscape:cx="206.42851"
     inkscape:cy="451.87704"
     inkscape:window-width="1772"
     inkscape:window-height="1027"
     inkscape:window-x="0"
     inkscape:window-y="25"
     inkscape:window-maximized="0"
     inkscape:current-layer="layer1" />
  <defs
     id="defs2" />
  <g
     inkscape:label="Layer 1"
     inkscape:groupmode="layer"
     id="layer1">
    <rect
       style="fill:#d8b8e0;stroke-width:9.11369;stroke-linecap:square;paint-order:stroke fill markers;fill-opacity:1"
       id="rect184"
       width="270.93332"
       height="270.93332"
       x="-7.1054274e-15"
       y="0" />
  </g>
</svg>

"""#),
  ]
}