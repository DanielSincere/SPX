import Foundation

public struct SPX {

  let announcer = Announcer()

  public init() {}

  public func run(_ arguments: [String]) {

    do {
      let defaultScriptsDir = "SPX"
      try self.parse(arguments: Array(arguments.dropFirst()), spxDir: defaultScriptsDir)
    } catch {
      announcer.error(error)
      exit(EXIT_FAILURE)
    }
  }

  private func parse(arguments: Array<String>, spxDir: String) throws {
    if 0 == arguments.count {
      do {
        try ListCommand(announcer: announcer,
                        runner: Runner(),
                        spxDir: spxDir)
        .exec()
      } catch {
        announcer.error(error)

        HelpCommand(spxDir: spxDir)
          .exec()

        exit(EXIT_FAILURE)
      }

    } else if 1 <= arguments.count {
      switch arguments[0] {

      case "--version", "-v":
        print("SPX \(version)")

      case "--help", "-h", "-?":
        HelpCommand(spxDir: spxDir)
          .exec()

      case "--init", "-i":
        let arguments = Array(arguments.dropFirst())
        try InitCommand(announcer: announcer, spxDir: spxDir)
          .exec(arguments: arguments)

      case "--list", "-l":
        try ListCommand(announcer: announcer, runner: Runner(), spxDir: spxDir)
          .exec()

      case "--build", "-b":
        try BuildCommand(announcer: announcer, runner: Runner(), spxDir: spxDir)
          .exec()

      case "--add", "-a":
        let arguments = Array(arguments.dropFirst())
        try AddCommand(announcer: announcer, spxDir: spxDir)
          .exec(arguments: arguments)

      default:
        let targetName = arguments[0]
        let targetArguments = arguments.dropFirst()
        try ExecCommand(announcer: announcer, runner: Runner(), spxDir: spxDir)
          .exec(targetName: targetName, targetArguments: Array(targetArguments))
      }
    } else {
      HelpCommand(spxDir: spxDir)
        .exec()
    }
  }
}
