import Foundation

extension FileManager {
  func resetDir(atPath path: String) throws {
    if FileManager.default.fileExists(atPath: path) {
      try FileManager.default.removeItem(atPath: path)
    }
    try FileManager.default.createDirectory(atPath: path,
                                            withIntermediateDirectories: true)
  }
}
