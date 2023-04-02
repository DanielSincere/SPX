@testable import SPXLib

final class FakeRunner: Running {
 
  var receivedCommands: [String] = []

  func exec(cmd: String) throws {
    receivedCommands.append(cmd)
  }
  
  var returnedSwiftPackageDump: SwiftPackageDescription?
  
  func parseSwiftPackage(cmd: String) throws -> SwiftPackageDescription {
    if let returnedSwiftPackageDump = returnedSwiftPackageDump {
      receivedCommands.append(cmd)
      return returnedSwiftPackageDump
    } else {
      struct SwiftPackageDumpNotSetError: Error {}
      throw SwiftPackageDumpNotSetError()
    }
  }
}
