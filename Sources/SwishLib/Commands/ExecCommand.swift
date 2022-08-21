import Foundation

final class ExecCommand {

  let announcer: Announcer?, runner: Running, swishDir: String
  init(announcer: Announcer?, runner: Running, swishDir: String) {
    self.runner = runner
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec(targetName: String, targetArguments: Array<String>) throws {
    let package = try SwiftPackageDump.discover(runner: runner, swishDir: swishDir)
    let targetNames = package.executableTargets.map { $0.name }

    guard targetNames.contains(targetName) else {
      throw Errors.targetNotFound(named: targetName, availableTargets: targetNames)
    }

    announcer?.running(target: targetName)

    var cmd = "xcrun --sdk macosx swift run --package-path \(swishDir) \(targetName)"
    if !targetArguments.isEmpty {
      cmd += " \(targetArguments.joined(separator: " "))"
    }

    do {
      try runner.exec(cmd: cmd)
    } catch {
      throw Errors.errorRunning(target: targetName, error: error)
    }
  }

  enum Errors: Error {
    case targetNotFound(named: String, availableTargets: [String])
    case errorRunning(target: String, error: Error)
  }
}
