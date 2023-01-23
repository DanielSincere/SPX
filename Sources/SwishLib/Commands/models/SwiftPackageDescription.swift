import Sh
import Foundation

struct SwiftPackageDescription: Decodable {

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

  static func discover(runner: Running, swishDir: String) throws -> Self {

    guard FileManager.default.isReadableFile(atPath: "\(swishDir)/Package.swift") else {
      throw Errors.couldNotFindPackageDotSwift(path: "\(swishDir)/Package.swift")
    }
    
    return try runner.parseSwiftPackage(cmd: "swift package --package-path \(swishDir) dump-package")
  }

  enum Errors: Error {
    case couldNotFindPackageDotSwift(path: String)
  }
}
