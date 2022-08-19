@testable import SwishLib

final class FakeRunner: Running {

  var receivedCommands: [String] = []

  func exec(cmd: String) throws {
    receivedCommands.append(cmd)
  }
}
