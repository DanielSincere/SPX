import Foundation

struct ScaffoldFile {

  let directory: String?
  let name: String
  let contents: String

  func create(in path: String) throws -> String {
    let directory = self.directory(for: path)
    let fullPath = directory + "/" + self.name


    try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)


    let nsstring = NSString(string: self.contents)
    try nsstring.write(toFile: fullPath,
                       atomically: true,
                       encoding: String.Encoding.utf8.rawValue)

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
