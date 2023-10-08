import Foundation
import System
import ArgumentParser

@main
struct GenerateTemplatesTool: ParsableCommand {

  @Argument(help: "input dir to read templates from")
  var templatesDir: String

  @Argument(help: "output dir to write to")
  var outputDir: String

  mutating func run() throws {
    let templates: [String: [ScaffoldFile]] = try detectTemplates()
    try generateTemplateEnum(outputDir: outputDir, templates: Array(templates.keys))

    try templates.forEach { template, files in
      try writeContentsFile(outputDir: outputDir, name: template, files: files)
    }
  }

  func generateTemplateEnum(outputDir: String, templates: [String]) throws {

    let path = "\(outputDir)/Templates.swift"
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

  func writeContentsFile(outputDir: String, name: String, files: [ScaffoldFile]) throws {
    let path = "\(outputDir)/\(name)Template.swift"
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

  func detectTemplates() throws -> [String: [ScaffoldFile]] {
    let templateNames = try FileManager.default
      .contentsOfDirectory(atPath: templatesDir)

    return try templateNames.reduce([:]) { result, next in

      let enumerator = FileManager.default.enumerator(atPath: "\(templatesDir)/\(next)")
      guard let enumerator = enumerator else {
        struct CouldNotCreateEnumerator: Error {
          let path: String
        }
        throw CouldNotCreateEnumerator(path: "\(templatesDir)/\(next)")
      }

      var files: [ScaffoldFile] = []
      let rootPath = FilePath("\(templatesDir)/\(next)/")
      while let file = enumerator.nextObject() as? String {

        let filePath = rootPath.appending(file)//"templates/\(next)/\(file)"
        
        guard !filePath.isDirectory else {
          continue
        }
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

extension FilePath {
  var isDirectory: Bool {
    var directory = ObjCBool(false)
    guard FileManager.default.fileExists(atPath: self.string, isDirectory: &directory) else {
      return false
    }
    return directory.boolValue
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
    #if os(Linux)
      return URL(fileURLWithPath: self)
    #else
    if #available(macOS 13.0, *) {
      return URL(filePath: self)
    } else {
      return URL(fileURLWithPath: self)
    }
    #endif
  }
}

struct ScaffoldFile {
  let directory: String
  let name: String
  let contents: String
}
