import Foundation

final class AddCommand {

  let announcer: Announcer, swishDir: String
  init(announcer: Announcer, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec(arguments: Array<String>) throws {
    if arguments.count < 1 {
      throw Errors.scriptNameMissing
    }

    try self.exec(name: arguments[0])
  }

  func exec(name: String) throws {

    let file = ScaffoldFile(directory: "Sources/\(name)", name: "main.swift", contents:
      #"""
      import Sh
      import Foundation

      let timeInterval = try sh(TimeInterval.self, "date +%s")
      let date = Date(timeIntervalSince1970: timeInterval)
      print("The date is \(date).")
      """#)
    let fullPath = try file.create(in: swishDir)
    announcer.fileCreated(path: fullPath)

    var packageContents = try String(contentsOfFile: swishDir + "/Package.swift")
    let newTarget =
    """

    package.targets += [
      .executableTarget(name: "\(name)", dependencies: ["Sh"])
    ]

    """
    packageContents.append(contentsOf: newTarget)
    try packageContents.write(toFile: swishDir + "/Package.swift", atomically: true, encoding: .utf8)
    announcer.fileModified(path: swishDir + "/Package.swift")
  }

  enum Errors: Error {
    case scriptNameMissing
  }
}
