import Foundation

struct ScaffoldFile {

  let directory: String?
  let name: String
  let contents: String

  func create(in path: String) throws -> String {
    let directory = self.directory(for: path)
    let fullPath = directory + "/" + self.name
    let data = self.contents.data(using: .utf8)!
    try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)
    FileManager.default.createFile(atPath: fullPath, contents: data)
    return fullPath
  }

  func directory(for path: String) -> String {
    if let directory = directory {
      return path + "/" + directory
    } else {
      return path
    }
  }
}
