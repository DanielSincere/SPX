import Foundation
import Sh

final class Runner: Running {
  
  func parseSwiftPackage(cmd: String) throws -> SwiftPackageDump {
#if os(macOS)
    return try sh(SwiftPackageDump.self, "xcrun --sdk macosx \(cmd)")
#else
    return try sh(SwiftPackageDump.self, cmd)
#endif
  }
  
  func exec(cmd: String) throws {
#if os(macOS)
    return try sh(.terminal, "xcrun --sdk macosx \(cmd)")
#else
    return try sh(.terminal, cmd)
#endif
  }
}
