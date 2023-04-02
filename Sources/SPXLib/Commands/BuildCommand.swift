import Foundation

final class BuildCommand {

  let announcer: Announcer?, runner: Running, spxDir: String
  init(announcer: Announcer?, runner: Running, spxDir: String) {
    self.announcer = announcer
    self.spxDir = spxDir
    self.runner = runner
  }

  func exec() throws {
    announcer?.building(path: spxDir)
    do {
      try self.removeBuildDir()
      try self.build()
    } catch {
      throw Errors.build(error: error)
    }
  }

  private func removeBuildDir() throws {
    if FileManager.default.fileExists(atPath: "\(spxDir)/.build") {
      try FileManager.default.removeItem(atPath: "\(spxDir)/.build")
    }
  }
  
  private func build() throws {
    try runner.exec(cmd: "swift build --package-path \(spxDir)")
  }

  enum Errors: Error {
    case build(error: Error)
  }
}
