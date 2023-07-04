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
