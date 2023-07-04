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
