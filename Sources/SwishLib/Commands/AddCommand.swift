import Foundation

final class AddCommand {

  let announcer: Announcer?, swishDir: String
  init(announcer: Announcer?, swishDir: String) {
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

    for file in self.files(name: name) {
      let fullPath = try file.create(in: swishDir)
      announcer?.fileCreated(path: fullPath)
    }

    var packageContents = try String(contentsOfFile: swishDir + "/Package.swift")
    let newTarget =
    """

    package.targets += [
      .target(name: "\(name.capitalized)Lib", dependencies: ["Sh"]),
      .executableTarget(name: "\(name)", dependencies: ["\(name.capitalized)Lib"])
    ]
    """
    packageContents.append(contentsOf: newTarget)
    try packageContents.write(toFile: swishDir + "/Package.swift", atomically: true, encoding: .utf8)
    announcer?.fileModified(path: swishDir + "/Package.swift")
  }

  enum Errors: Error {
    case scriptNameMissing
  }

  func files(name: String) -> [ScaffoldFile] {
    [
      ScaffoldFile(directory: "Sources/\(name)",
                   name: "main.swift",
                   contents:
        """
        import \(name.capitalized)Lib

        let date = try \(name.capitalized)().fetch()
        """ +
        #"print("The date is \(date).")"#
      ),
      ScaffoldFile(directory: "Sources/\(name)Lib",
                   name: "\(name).swift",
                   contents:
      """
      import Sh
      import Foundation

      public struct \(name.capitalized) {
        public init() {}
        public func fetchFromShell() throws -> Date {
          let timeInterval = try sh(TimeInterval.self, "date +%s")
          return Date(timeIntervalSince1970: timeInterval)
        }
      }
      """),
    ]
  }
}
