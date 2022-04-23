import Sh
import Foundation

struct SwiftPackageDump: Decodable {

  let targets: [Target]

  struct Target: Decodable {
    let name: String
    let type: String
  }

  func executableTargets() -> [Target] {
    targets.filter({ $0.type == "executable" })
  }

  func target(named name: String) -> Target? {
    targets.first(where: { $0.name == name && $0.type == "executable" })
  }

  static func discover(swishDir: String) throws -> Self {

    guard FileManager.default.isReadableFile(atPath: "\(swishDir)/Package.swift") else {
      throw Errors.couldNotFindPackageDotSwift(path: "\(swishDir)/Package.swift")
    }

//     guard let json: String = try sh("swift package --package-path \(swishDir) dump-package") else {
//       throw Errors.couldNotParseJson
//     }
//
//     return try JSONDecoder().decode(SwiftPackageDump.self, from: json.data(using: .utf8)!)

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
