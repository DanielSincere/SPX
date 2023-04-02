import Foundation
import Sh
import System

@main
struct GenerateMain {

  static func main() throws {
    let templates: [String: [ScaffoldFile]] = try detectTemplates()
    try generateTemplateEnum(templates: Array(templates.keys))

    try templates.forEach { template, files in
      try writeContentsFile(name: template, files: files)
    }
    try sh(.terminal, "swift build")
  }

  static func generateTemplateEnum(templates: [String]) throws {
    try FileManager.default.resetDir(atPath: "Sources/SPXLib/templates-generated/")

    try sh(.terminal, "rm -fr ./**/.build")

    let path = "Sources/SPXLib/templates-generated/Templates.swift"
    let contents =
    """
    enum Templates: String, CaseIterable {
    \(templates
      .map { "\tcase \($0)" }
      .joined(separator: "\n"))

      var files: [ScaffoldFile] {
        switch self {
        \(templates.map { "\tcase .\($0): return Self.\($0)Files" }.joined(separator: "\n"))
        }
      }
    }
    """
    try contents.data(using: .utf8)!.write(to: path.asURL)
  }

  static func writeContentsFile(name: String, files: [ScaffoldFile]) throws {
    let path = "Sources/SPXLib/templates-generated/-.\(name)Files.swift"
    let contents =
    """
    extension Templates {
      static let \(name)Files: [ScaffoldFile] = [
        \(files.map {
          """
          ScaffoldFile(directory: "\($0.directory)",
                       name: "\($0.name)",
                       contents: #\"\"\"
          \($0.contents)
          \"\"\"#),
          """
    }.joined(separator: "\n"))
      ]
    }
    """
    try contents.data(using: .utf8)!.write(to: path.asURL)
  }

  static func detectTemplates() throws -> [String: [ScaffoldFile]] {
    let templateNames = try FileManager.default
      .contentsOfDirectory(atPath: "templates")

    return try templateNames.reduce([:]) { result, next in

      let enumerator = FileManager.default.enumerator(atPath: "templates/\(next)")
      guard let enumerator = enumerator else {
        struct CouldNotCreateEnumerator: Error {
          let path: String
        }
        throw CouldNotCreateEnumerator(path: "templates/\(next)")
      }

      var files: [ScaffoldFile] = []
      let rootPath = FilePath("templates/\(next)/")
      while let file = enumerator.nextObject() as? String {

        let filePath = rootPath.appending(file)//"templates/\(next)/\(file)"
        do {
          let contents = try String(contentsOfFile: filePath.string)
          let name = filePath.lastComponent!

          var directory = filePath.removingLastComponent()
          _ = directory.removePrefix(rootPath)

          print("Directory", directory)
          print("\tname", name)
          files.append(ScaffoldFile(directory: directory.string,
                                    name: name.string,
                                    contents: contents))
        } catch {
          print("could not open \(filePath)", error.localizedDescription)
        }
      }

      return result.merging([next: files]) { lhs, rhs in
        return rhs
      }
    }
  }
}

extension String {
  var isDirectory: Bool {
    var directory = ObjCBool(false)
    guard FileManager.default.fileExists(atPath: self, isDirectory: &directory) else {
      return false
    }
    return directory.boolValue
  }

  var asURL: URL {
    if #available(macOS 13.0, *) {
      return URL(filePath: self)
    } else {
      return URL(fileURLWithPath: self)
    }
  }
}

struct ScaffoldFile {
  let directory: String
  let name: String
  let contents: String
}
