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
