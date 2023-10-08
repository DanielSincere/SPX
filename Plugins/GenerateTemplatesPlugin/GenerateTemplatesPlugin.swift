import PackagePlugin
import Foundation

@main
struct GenerateTemplatesPlugin: BuildToolPlugin {
  func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {

    let templatesDir = context.package.directory.appending(subpath: "templates")

    let contents = try FileManager.default.contentsOfDirectory(atPath: templatesDir.string)

    print(contents)

    return [
      .buildCommand(
        displayName: "GenerateTemplatesPlugin",
        executable: try context.tool(named: "GenerateTemplatesTool").path,
        arguments: [
          templatesDir.string,
          context.pluginWorkDirectory.string
        ],
        inputFiles: contents.map { Path($0) },
        outputFiles: [
          context.pluginWorkDirectory.appending("Templates.swift"),
        ] + contents.map({ templateName in
          Path("\(templateName)Template.swift")
        })
      ),
    ]
  }
}
