import Foundation

final class ListCommand {

  let announcer: Announcing, swishDir: String
  init(announcer: Announcing, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec() throws {
    let package = try SwiftPackageDump.discover(swishDir: swishDir)
    announcer.listTargets(of: package)
  }
}
