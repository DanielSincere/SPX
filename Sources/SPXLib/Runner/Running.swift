protocol Running {
  func exec(cmd: String) throws
  func parseSwiftPackage(cmd: String) throws -> SwiftPackageDescription
}
