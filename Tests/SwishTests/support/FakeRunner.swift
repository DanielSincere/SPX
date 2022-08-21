@testable import SwishLib

final class FakeRunner: Running {
 
  var receivedCommands: [String] = []

  func exec(cmd: String) throws {
    receivedCommands.append(cmd)
  }
  
  var returnedSwiftPackageDump: SwiftPackageDump?
  
  func parse(cmd: String) throws -> SwiftPackageDump {
    if let returnedSwiftPackageDump = returnedSwiftPackageDump {
      receivedCommands.append(cmd)
      return returnedSwiftPackageDump
    } else {
      struct SwiftPackageDumpNotSetError: Error {}
      throw SwiftPackageDumpNotSetError()
    }
  }
}
