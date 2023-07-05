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
