import Foundation

final class BuildCommand {

  let announcer: Announcer?, runner: Running, swishDir: String
  init(announcer: Announcer?, runner: Running, swishDir: String) {
    self.announcer = announcer
    self.swishDir = swishDir
    self.runner = runner
  }

  func exec() throws {
    announcer?.building(path: swishDir)
    do {
      try self.removeBuildDir()
      try runner.exec(cmd: "xcrun --sdk macosx swift build --package-path \(swishDir)")
    } catch {
      throw Errors.build(error: error)
    }
  }

  private func removeBuildDir() throws {
    if FileManager.default.fileExists(atPath: "\(swishDir)/.build") {
      try FileManager.default.removeItem(atPath: "\(swishDir)/.build")
    }
  }

  enum Errors: Error {
    case build(error: Error)
  }
}
