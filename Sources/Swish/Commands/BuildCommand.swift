import Sh
import Foundation

final class BuildCommand {

  let announcer: Announcer, swishDir: String
  init(announcer: Announcer, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec() throws {
    announcer.building(path: swishDir)
    do {
      try sh(.terminal, "rm -fr \(swishDir)/.build")
      try sh(.terminal, "swift build --package-path \(swishDir)")
    } catch {
      throw Errors.build(error: error)
    }
  }

  enum Errors: Error {
    case build(error: Error)
  }
}
