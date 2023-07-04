extension Templates {
  static let iosFiles: [ScaffoldFile] = [
    ScaffoldFile(directory: "SPX",
             name: ".env.sample",
             contents: #"""
APPSTORECONNECT_API_KEY_ID=
APPSTORECONNECT_ISSUER_ID=
APPSTORECONNECT_DEVELOPMENT_TEAM=ARSTG12345

"""#),
ScaffoldFile(directory: "SPX",
             name: "README.md",
             contents: #"""
# iOS SPX Scripts

These are some scripts for managing your iOS project. Included in this template are a script to generate an app icon from an SVG (`spx appicon`) and a script to push to the App Store (`spx appstore`).

## App Store

This script archives your app & pushes it up to the App Store.

By default, it loads some environment variables from `SPX/.env`, but of course feel free to get them how ever you like, perhaps using [Sh1Password](https://github.com/FullQueueDeveloper/Sh1Password.git).


- `APPSTORECONNECT_API_KEY_ID` your API Key ID from App Store Connect
- `APPSTORECONNECT_ISSUER_ID` your Issuer ID from App Store Connect
- `APPSTORECONNECT_DEVELOPMENT_TEAM` your development team ID in App Store Connect`

You could also use other kinds of credentials for uploading to the App Store, such as username and password, using [LiteralPasswordCredential](https://github.com/FullQueueDeveloper/ShXcrun/blob/trunk/Sources/ShXcrun/Altool/Credential/LiteralPasswordCredential.swift). This will require generate an app-specific password at https://appleid.apple.com.

Be sure to also update the scheme that is built. By default this is `App`. You may also want to update the script if you need to specify a project or workspace to `xcodebuild`.

## App icon

This script uses the SVG at `SPX/AppIcon.svg` by default. You may want to use a different SVG, but this will be useful for pushing to TestFlight.

You may also want to update the output directory to something that makes sense to you. By default, it outputs an `AppIcon.xcassets` to a directory name `App`.

"""#),
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
      dependencies: ["Sh", "ShXcrun"]),
    .executableTarget(
      name: "appicon",
      dependencies: ["SwishXCAssets"]),
  ]
)

"""#),
ScaffoldFile(directory: "SPX/Sources/appstore",
             name: "EnvironmentKeys.swift",
             contents: #"""
import DotEnv
import Foundation

enum EnvironmentKeys: String, CaseIterable {
  case appleTeamId = "APPSTORECONNECT_DEVELOPMENT_TEAM"
  case appstoreconnectIssuerId = "APPSTORECONNECT_ISSUER_ID"
  case appstoreconnectApiKeyId = "APPSTORECONNECT_API_KEY_ID"

  func ensurePresentInEnvironmentOrDotEnv(_ dotEnv: DotEnv) throws {
    if nil == dotEnv.lines.first(where: { $0.key == self.rawValue })
    && nil == ProcessInfo.processInfo.environment[self.rawValue] {
      throw MissingEnvironmentKey(key: self.rawValue)
    }
  }

  func get() throws -> String {
    guard let value = ProcessInfo.processInfo.environment[self.rawValue] else {
      throw MissingEnvironmentKey(key: self.rawValue)
    }

    return value
  }

  static func ensureAllPresentInEnvironmentOrDotEnv(_ dotEnv: DotEnv) throws {
    for key in EnvironmentKeys.allCases {
      try key.ensurePresentInEnvironmentOrDotEnv(dotEnv)
    }
  }

  struct MissingEnvironmentKey: Error, LocalizedError {
    let key: String

    var errorDescription: String? {
      "\(key) not found in `.env` or in environment"
    }
  }
}

"""#),
ScaffoldFile(directory: "SPX/Sources/appstore",
             name: "BuildNumberAction.swift",
             contents: #"""
import Version
import Sh
import Foundation
import Version

struct BuildNumberAction {

  static let tagPrefix: String = "appstore/"

  func updateBuildNumbers(newVersion: Version?) throws {

    if let newVersion = newVersion {
      let completeVersion = CompleteVersion(marketingVersion: newVersion, buildNumber: 1)
      try createNewTag(completeVersion)
      try updateInfoPlist(completeVersion)
    } else {
      let currentCompleteVersion = try getCurrentCompleteVersion()
      let nextVersion = currentCompleteVersion.incrementingBuildNumber()

      try createNewTag(nextVersion)
      try updateInfoPlist(nextVersion)
    }
  }

  enum Errors: Error {
    case gitDidntFindTag
    case gitTagDoesntHavePrefix, gitTagDoesntHaveSuffix
    case gitTagDoesntParseVersionAfterRemovingPrefix, gitTagDoesntParseVersionAfterRemovingSuffix
    case gitTagDoesntParseVersionAfterSplitting(String)
    case malformedTag(String)
    case buildNumberInGitTagMustBeAnInteger(String, String)
  }

  struct CompleteVersion: Equatable {
    let marketingVersion: Version
    let buildNumber: Int

    func incrementingBuildNumber() -> CompleteVersion {
      .init(marketingVersion: self.marketingVersion,
            buildNumber: self.buildNumber + 1)
    }

    init(marketingVersion: Version, buildNumber: Int) {
      self.marketingVersion = marketingVersion
      self.buildNumber = buildNumber
    }

    var gitTag: String {
      tagPrefix + self.marketingVersion.description + "/build-\(buildNumber)"
    }

    init(gitTag: String) throws {
      
      guard let tagPrefixRange = gitTag.range(of: tagPrefix) else {
        throw Errors.gitTagDoesntHavePrefix
      }

      let withoutPrefix = String(gitTag[tagPrefixRange.upperBound...])

      let splits = withoutPrefix.split(separator: "/build-")
      guard splits.count == 2 else {
        throw Errors.malformedTag(gitTag)
      }

      guard let version = Version(splits[0]) else {
        throw Errors.gitTagDoesntParseVersionAfterSplitting(gitTag)
      }

      guard let buildNumber = Int(splits[1]) else {
        throw Errors.buildNumberInGitTagMustBeAnInteger(gitTag, String(splits[1]))
      }

      self.init(marketingVersion: version, buildNumber: buildNumber)
    }
  }

  func getMostRecentTag() throws -> String {
    let cmd = "git tag -l '\(Self.tagPrefix)*' --sort='-version:refname' | head -n1"
    guard let mostRecentTagString = try sh(cmd) else {
      throw Errors.gitDidntFindTag
    }
    return mostRecentTagString
  }

  func getCurrentCompleteVersion() throws -> CompleteVersion {
    let mostRecentTag = try getMostRecentTag()
    return try CompleteVersion(gitTag: mostRecentTag)
  }

  func updateInfoPlist(_ completeVersion: CompleteVersion) throws {
    try sh(.terminal, """
      xcrun plutil \
      -replace CFBundleShortVersionString -string \(completeVersion.marketingVersion) \
      App/Info.plist
      """)
    try sh(.terminal, """
      xcrun plutil \
      -replace CFBundleVersion -string \(completeVersion.buildNumber) \
      App/Info.plist
      """)
  }

  func createNewTag(_ completeVersion: CompleteVersion) throws {
    try sh(.terminal, "git tag \(completeVersion.gitTag)")
  }
}

"""#),
ScaffoldFile(directory: "SPX/Sources/appstore",
             name: "AppStoreScript.swift",
             contents: #"""
import Sh
import ShXcrun
import ShGit
import DotEnv
import Version
import Foundation
import ArgumentParser

/*
USAGE: spx appstore [-n newVersionNumber]

spx appstore: build & push to testflight, incrementing only the build number

spx appstore -n 1.0.1: build & push to testflight, setting the version number and starting the build count at zero.

*/
extension Version: ExpressibleByArgument { }



@main
struct AppStoreScript: ParsableCommand {

  @Option(name: .shortAndLong, help: "The new version number, resetting the build number.")
  var newVersion: Version? = nil

  mutating func run() throws {
    do {
      try setup()
      try ensureCleanRepo()
      try updateBuildNumbers(newVersion: newVersion)
      try archive()
      try exportArchive()
      try upload()
      try pushTags()
      print("Complete!".cyan)
    } catch {
      print("Error".red, error.localizedDescription)
    }
  }

  private var scheme: String { "App" }
  private var logsDir: String { "SPX/logs" }
  private var artifactsPath: String { "SPX/artifacts" }
  private var archivePath: String { "\(artifactsPath)/\(scheme).xcarchive" }

  private func setup() throws {
    try DotEnv.load(path: "SPX/.env")

    try sh(.terminal, "mkdir -p \(artifactsPath)")
    try sh(.terminal, "mkdir -p \(logsDir)")
  }

  private func pushTags() throws {
    try sh(.terminal, "git push --tags")
  }

  private func ensureCleanRepo() throws {
    struct GitRepoNotClean: LocalizedError {
      let errorDescription: String? = "Git repo must be clean to push to App Store"
    }
    guard try Git().isClean() else {
      throw GitRepoNotClean()
    }
  }

  private func updateBuildNumbers(newVersion: Version?) throws {
    try BuildNumberAction().updateBuildNumbers(newVersion: newVersion)
  }

  private func archive() throws {
    let archiveCommand = """
      xcodebuild archive -scheme "\(scheme)" \
      -destination generic/platform=iOS \
      -archivePath "\(archivePath)"
      """

    try sh(.file("\(logsDir)/archive.log"), archiveCommand)
  }

  private func exportArchive() throws {
    let exportOptionsPath = "\(artifactsPath)/\(scheme)-exportOptions.plist"

    let exportOptions = ExportOptions(compileBitcode: false,
                                      manageAppVersionAndBuildNumber: false,
                                      method: .appStore,
                                      teamID: try EnvironmentKeys.appleTeamId.get(),
                                      uploadBitcode: false,
                                      uploadSymbols: true)
    try exportOptions.write(to: exportOptionsPath)

    let exportArchiveCommand = """
      xcodebuild -exportArchive \
      -archivePath "\(archivePath)" \
      -exportPath "\(artifactsPath)" \
      -exportOptionsPlist "\(exportOptionsPath)" \
      -allowProvisioningUpdates
      """
    try sh(.file("\(logsDir)/exportArchive.log"), exportArchiveCommand)
  }

  private func upload() throws{
    let uploadCommand = """
    xcrun altool --upload-app -t ios \
    -f "\(artifactsPath)/\(scheme).ipa" \
    --apiKey $API_KEY_ID \
    --apiIssuer $API_ISSUER_ID
    """

    try sh(.terminal, uploadCommand, environment: [
      "API_KEY_ID": try EnvironmentKeys.appstoreconnectApiKeyId.get(),
      "API_ISSUER_ID": try EnvironmentKeys.appstoreconnectIssuerId.get()
    ])
  }
}

"""#),
ScaffoldFile(directory: "SPX/Sources/appicon",
             name: "main.swift",
             contents: #"""
import SwishXCAssets

let svgPath = "SPX/AppIcon.svg"
try await AppIcon(inputSVG: svgPath, outputDir: "App")
  .render(platforms: [.iPhone, .iPad])

"""#),
ScaffoldFile(directory: "SPX",
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