import Foundation
import Sh

final class Runner: Running {
  
  func parseSwiftPackage(cmd: String) throws -> SwiftPackageDescription {
    return try sh(SwiftPackageDescription.self, cmd)
  }
  
  func exec(cmd: String) throws {
    return try sh(.terminal, cmd)
  }
}
