import Foundation
import Sh

final class Runner: Running {

  func exec(cmd: String) throws {
    try sh(.terminal, cmd)
  }
}
