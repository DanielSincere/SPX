import PackagePlugin
import Foundation

@main
struct GenerateTemplatesPlugin: BuildToolPlugin {
  func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {

    //    let spxlibTarget = try context.package.targets(named: ["SPXLib"]).first!
//    let outputDir = context.pluginWorkDirectory.appending("GeneratedFiles")
    return [
      .buildCommand(
        displayName: "GenerateTemplatesPlugin",
        executable: try context.tool(named: "GenerateTemplatesTool").path,
        arguments: [
          context.pluginWorkDirectory.string
        ],
        outputFiles: [context.pluginWorkDirectory.appending("/ttt.swift")]
      ),

    ]
  }
}
