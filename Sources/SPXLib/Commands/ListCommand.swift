import Foundation

final class ListCommand {

  let announcer: Announcer?, runner: Running, spxDir: String
  init(announcer: Announcer?, runner: Running, spxDir: String) {
    self.announcer = announcer
    self.runner = runner
    self.spxDir = spxDir
  }

  @discardableResult
  func exec() throws -> [SwiftPackageDescription.Target] {
    let package = try SwiftPackageDescription.discover(runner: runner, spxDir: spxDir)
    let targets = package.executableTargets
    announcer?.list(targets: targets)
    return targets
  }
}
