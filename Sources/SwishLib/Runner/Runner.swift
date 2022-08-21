import Foundation
import Sh

final class Runner: Running {
  func parse(cmd: String) throws -> SwiftPackageDump {
    try sh(SwiftPackageDump.self, cmd)
  }

  func exec(cmd: String) throws {
    try sh(.terminal, cmd)
  }
}
