import Foundation

@main
struct GenerateTemplatesTool {
  static func main() throws {
    let root = CommandLine.arguments[1]

    try "let ttt: Int = \"arst\"".write(toFile: "\(root)/ttt.swift", atomically: true, encoding: .utf8)
  }
}
