import Foundation

final class ListCommand {

  let announcer: Announcer?, swishDir: String
  init(announcer: Announcer?, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  @discardableResult
  func exec() throws -> [SwiftPackageDump.Target] {
    let result = try SwiftPackageDump.discover(swishDir: swishDir).executableTargets
    announcer?.list(targets: result)
    return result
  }
}
