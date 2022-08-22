import Foundation

final class ListCommand {

  let announcer: Announcer?, runner: Running, swishDir: String
  init(announcer: Announcer?, runner: Running, swishDir: String) {
    self.announcer = announcer
    self.runner = runner
    self.swishDir = swishDir
  }

  @discardableResult
  func exec() throws -> [SwiftPackageDescription.Target] {
    let package = try SwiftPackageDescription.discover(runner: runner, swishDir: swishDir)
    let targets = package.executableTargets
    announcer?.list(targets: targets)
    return targets
  }
}
