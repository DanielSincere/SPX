import Foundation

final class InitCommand {

  let announcer: Announcer?, swishDir: String
  init(announcer: Announcer?, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
  }

  func exec() throws {

    announcer?.scaffolding(path: swishDir)

    for file in files {
      let fullPath = try file.create(in: swishDir)
      announcer?.fileCreated(path: fullPath)
    }
  }

  private var files: [ScaffoldFile] {
    [
      .init(directory: "Sources/date", name: "main.swift", contents:
        #"""
        import DateLib
        import Foundation

        let date = try fetchDateFromShell()
        print("The date is \(date).")
        """#
      ),
      .init(directory: "Sources/DateLib", name: "fetchDateFromShell.swift", contents:
        #"""
        import Sh
        import Foundation

        public func fetchDateFromShell() throws -> Date {
          let timeInterval = try sh(TimeInterval.self, "date +%s")
          let date = Date(timeIntervalSince1970: timeInterval)
          return date
        }

        """#
      ),
      .init(directory: nil, name: "Package.swift", contents:
        """
        // swift-tools-version:5.7

        import PackageDescription

        let package = Package(
          name: "Scripts",
          platforms: [.macOS(.v12)],
          products: [
            .executable(name: "date", targets: ["date"]),
          ],
          dependencies: [
            .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.0.0"),
          ],
          targets: [
            .executableTarget(
              name: "date",
              dependencies: ["DateLib"]),
            .target(
              name: "DateLib",
              dependencies: ["Sh"]),
          ]
        )
        """
      ),
      .init(directory: nil, name: ".gitignore", contents:
        """
        .build
        .DS_Store
        .swiftpm
        """
      )
    ]
  }
}
