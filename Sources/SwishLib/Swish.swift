import Foundation

public struct Swish {

  let announcer = Announcer()

  public init() {}
  
  public func run(_ arguments: [String]) {
    do {
      let defaultScriptsDir = "Swish"
      try self.parse(arguments: Array(arguments.dropFirst()), swishDir: defaultScriptsDir)
    } catch {
      announcer.error(error)
      exit(EXIT_FAILURE)
    }
  }

  private func parse(arguments: Array<String>, swishDir: String) throws {
    if 0 == arguments.count {
      try ListCommand(announcer: announcer, runner: Runner(), swishDir: swishDir)
        .exec()

    } else if 1 <= arguments.count {
      switch arguments[0] {

      case "--version", "-v":
        print("Swish \(version)")

      case "--help", "-h", "-?":
        HelpCommand(swishDir: swishDir)
          .exec()

      case "--init", "-i":
        try InitCommand(announcer: announcer, swishDir: swishDir)
          .exec()

      case "--list", "-l":
        try ListCommand(announcer: announcer, runner: Runner(), swishDir: swishDir)
          .exec()

      case "--build", "-b":
        try BuildCommand(announcer: announcer, runner: Runner(), swishDir: swishDir)
          .exec()

      case "--add", "-a":
        let arguments = Array(arguments.dropFirst())
        try AddCommand(announcer: announcer, swishDir: swishDir)
          .exec(arguments: arguments)
      
      case "--macosx":
        let arguments = Array(arguments.dropFirst())
        guard !arguments.isEmpty else {
          HelpCommand(swishDir: swishDir)
            .exec()
          exit(EXIT_FAILURE)
        }
        let targetName = arguments[0]
        let targetArguments = arguments.dropFirst()
        let runner = Runner(isForcingMacOSXSDK: true)
        try ExecCommand(announcer: announcer, runner: runner, swishDir: swishDir)
          .exec(targetName: targetName, targetArguments: Array(targetArguments))
      default:
        let targetName = arguments[0]
        let targetArguments = arguments.dropFirst()
        try ExecCommand(announcer: announcer, runner: Runner(), swishDir: swishDir)
          .exec(targetName: targetName, targetArguments: Array(targetArguments))
      }
    } else {
      HelpCommand(swishDir: swishDir)
        .exec()
    }
  }
}
