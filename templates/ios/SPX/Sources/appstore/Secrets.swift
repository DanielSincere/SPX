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
