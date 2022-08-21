@testable import SwishLib

final class ParsingFakeRunner: Running {
  
  var receivedCommands: [String] = []
  
  func exec(cmd: String) throws {
    receivedCommands.append(cmd)
  }
  
  func parseSwiftPackage(cmd: String) throws -> SwiftPackageDescription {
    try Runner().parseSwiftPackage(cmd: cmd)
  }
}
