import Sh
import Foundation

struct SwiftPackageDump: Decodable {

  let targets: [Target]

  struct Target: Decodable {
    let name: String
    let type: String
  }

  var executableTargets: [Target] {
    targets.filter { $0.type == "executable" }
  }

  func executableTarget(named name: String) -> Target? {
    targets.first(where: { $0.name == name && $0.type == "executable" })
  }

  static func discover(swishDir: String) throws -> Self {

    guard FileManager.default.isReadableFile(atPath: "\(swishDir)/Package.swift") else {
      throw Errors.couldNotFindPackageDotSwift(path: "\(swishDir)/Package.swift")
    }

    return try sh(SwiftPackageDump.self, "swift package --package-path \(swishDir) dump-package")
  }

  enum Errors: Error, LocalizedError {
    case couldNotParseJson
    case couldNotFindPackageDotSwift(path: String)

    var errorDescription: String? {
      switch self {
      case .couldNotParseJson:
        return "Could not parse Package JSON"
      case .couldNotFindPackageDotSwift(path: let path):
        return "Could not find `Package.swift` at `\(path)`"
      }
    }
  }
}
