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

