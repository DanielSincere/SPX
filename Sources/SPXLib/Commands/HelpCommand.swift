import Foundation

final class HelpCommand {

  let spxDir: String
  init(spxDir: String) {
    self.spxDir = spxDir
  }

  func exec() {
    """
    SPX \(version)

    \("Regular use".bold)

    \("spx".cyan) \("<target-name>".yellow) [arguments...]

    - \("<target-name>".yellow)  The name of the `executableTarget` in the
                                 `Package.swift` in the `\(spxDir)`
                                 subdirectory of the current working
                                 directory.
    - [arguments...]  Remaining arguments passed to the target

    \("Available commands".bold)

    \("spx".cyan) \("with no arguments".lightBlack)
        list the available targets

    \("spx".cyan) \("--list".cyan), -l
        list the available targets

    \("spx --version".cyan), -v
        show version and exit

    \("spx --help".cyan), -h
        show this message

    \("spx".cyan) \("--init".cyan), -i
        scaffold a new `SPX` project subdirectory
        in the current directory. The default
        subdirectory name is `\(spxDir.bold)`

    \("spx".cyan) \("--add".cyan) \("<name>".yellow), -a
        add a new script named `\("<name>".yellow)` by
        creating a file at path `\("Sources/<name>/main.swift".yellow)`
        & a file at path `\("Sources/<Name>Lib/<Name>.swift".yellow)`,
        & adding a their targets to `Package.swift`

    \("spx".cyan) \("--build".cyan), -b
        update & build the scripts package, as a convenience.

    Learn more at \("https://github.com/FullQueueDeveloper/SPX".green)

    """
    .data(using: .utf8)
    .map(FileHandle.standardError.write(_:))
  }
}
