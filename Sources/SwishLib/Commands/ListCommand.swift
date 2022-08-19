import Foundation

final class ListCommand {

  let announcer: Announcer, swishDir: String
  init(announcer: Announcer, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec() throws -> [SwiftPackageDump.Target] {
    try SwiftPackageDump.discover(swishDir: swishDir).executableTargets
  }

  func announce() throws {
    announcer.list(targets: try self.exec())
  }
}
