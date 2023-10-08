import PackagePlugin
import Foundation

@main
struct GenerateTemplatesPlugin: BuildToolPlugin {
  func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {

    let templatesDir = context.package.directory.appending(subpath: "templates")

    let contents = try FileManager.default.contentsOfDirectory(atPath: templatesDir.string)

    
    let enumerator = FileManager.default.enumerator(atPath: templatesDir.string)
    
    
    let inputFiles = paths(fromEnumerator: enumerator!).map { path in
      templatesDir.appending(path)
    }

    return [
      .buildCommand(
        displayName: "GenerateTemplatesPlugin",
        executable: try context.tool(named: "GenerateTemplatesTool").path,
        arguments: [
          templatesDir.string,
          context.pluginWorkDirectory.string
        ],
        inputFiles: inputFiles,
        outputFiles: [
          context.pluginWorkDirectory.appending("Templates.swift"),
        ] + contents.map({ templateName in
          context.pluginWorkDirectory.appending("\(templateName)Template.swift")
        })
      ),
    ]
  }
  
  func paths(fromEnumerator enumerator: FileManager.DirectoryEnumerator) -> [String] {
    var result: [String] = []
    while let file = enumerator.nextObject() as? String {
      result += [file]
    }
    return result
  }
}
