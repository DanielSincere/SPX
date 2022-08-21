protocol Running {
  func exec(cmd: String) throws
  func parse(cmd: String) throws -> SwiftPackageDump
}
