import Foundation

final class AddCommand {

  let announcer: Announcer?, spxDir: String
  init(announcer: Announcer?, spxDir: String) {
    self.announcer = announcer
    self.spxDir = spxDir
  }

  func exec(arguments: Array<String>) throws {
    if arguments.count < 1 {
      throw Errors.scriptNameMissing
    }

    try self.exec(name: arguments[0])
  }

  func exec(name: String) throws {

    for file in self.files(name: name) {
      let fullPath = try file.create(in: spxDir)
      announcer?.fileCreated(path: fullPath)
    }

    var packageContents = try String(contentsOfFile: spxDir + "/Package.swift")
    let newTarget =
    """

    package.targets += [
      .target(name: "\(name.capitalized)Lib", dependencies: ["Sh"]),
      .executableTarget(name: "\(name)", dependencies: ["\(name.capitalized)Lib"])
    ]
    """
    packageContents.append(contentsOf: newTarget)
    try packageContents.write(toFile: spxDir + "/Package.swift", atomically: true, encoding: .utf8)
    announcer?.fileModified(path: spxDir + "/Package.swift")
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

        let date = try \(name.capitalized)().fetchFromShell()

        """ +
        #"print("The date is \(date).")"#
      ),
      ScaffoldFile(directory: "Sources/\(name.capitalized)Lib",
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
