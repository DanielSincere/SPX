import Foundation
import Sh

final class Runner: Running {
  let isForcingMacOSXSDK: Bool
  init(isForcingMacOSXSDK: Bool = false) {
    self.isForcingMacOSXSDK = isForcingMacOSXSDK
  }
  
  func parseSwiftPackage(cmd: String) throws -> SwiftPackageDescription {
    if isForcingMacOSXSDK {
      return try sh(SwiftPackageDescription.self, "xcrun --sdk macosx " + cmd)
    } else {
      return try sh(SwiftPackageDescription.self, cmd)
    }
  }
  
  func exec(cmd: String) throws {
    if isForcingMacOSXSDK {
      return try sh(.terminal, "xcrun --sdk macosx " + cmd)
    } else {
      return try sh(.terminal, cmd)
    }
  }
}
