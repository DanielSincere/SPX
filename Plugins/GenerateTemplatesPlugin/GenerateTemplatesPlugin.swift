import PackagePlugin
import Foundation

@main
struct GenerateTemplatesPlugin: BuildToolPlugin {
  func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
    print("hiello from plugin")

    return [
      .buildCommand(
        displayName: "GenerateTemplatesPlugin",
        executable: try context.tool(named: "GenerateTemplatesTool").path,
        arguments: [])]
//    return [.prebuildCommand(displayName: "Tomato",
//                             executable: try context.tool(named: "GenerateTemplatesTool").path,
//                             arguments: [],
//                             outputFilesDirectory: context.package.directory)]
  }
}
