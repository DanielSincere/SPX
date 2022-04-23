import Sh
import Foundation

final class ExecCommand {

  let announcer: Announcer, swishDir: String
  init(announcer: Announcer, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec(targetName: String, targetArguments: Array<String>) throws {
    let package = try SwiftPackageDump.discover(swishDir: swishDir)
    let targetNames = package.executableTargets().map { $0.name }

    guard targetNames.contains(targetName) else {
      throw Errors.targetNotFound(named: targetName, availableTargets: targetNames)
    }

    announcer.running(target: targetName)
    do {
      try sh(.terminal, "swift run --package-path \(swishDir) \(targetName) \(targetArguments.joined(separator: " "))")
    } catch {
      throw Errors.errorRunning(target: targetName, error: error)
    }
  }

  enum Errors: Error {
    case targetNotFound(named: String, availableTargets: [String])
    case errorRunning(target: String, error: Error)
  }
}
