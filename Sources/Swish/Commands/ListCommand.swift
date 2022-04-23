import Foundation

final class ListCommand {

  let announcer: Announcer, swishDir: String
  init(announcer: Announcer, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec() throws {
    let package = try SwiftPackageDump.discover(swishDir: swishDir)
    announcer.listTargets(of: package)
  }
}
