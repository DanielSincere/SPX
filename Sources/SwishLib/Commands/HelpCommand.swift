import Foundation

final class HelpCommand {

  let swishDir: String
  init(swishDir: String) {
    self.swishDir = swishDir
  }

  func exec() {
    """
    Swish \(version)

    Regular use:

    \("swish".cyan) \("<target-name>".yellow) [arguments...]

    - \("<target-name>".yellow)  The name of the `executableTarget` in the
                                 `Package.swift` in the `\(swishDir)`
                                 subdirectory of the current working
                                 directory.
    - [arguments...]  Remaining arguments passed to the target

    Available commands:

    \("swish".cyan) \("with no arguments".lightBlack)
        list the available targets

    \("swish".cyan) \("--list".cyan), -l
        list the available targets

    \("swish --version".cyan), -v
        show version and exit

    \("swish --help".cyan), -h
        show this message

    \("swish".cyan) \("--init".cyan), -i
        scaffold a new `Swish` project subdirectory
        in the current directory. The default
        subdirectory name is `\(swishDir.bold)`

    \("swish".cyan) \("--add".cyan) \("<name>".yellow), -a
        add a new script named `\("<name>".yellow)` by
        creating a file at path `\("Sources/<name>/main.swift".yellow)`
        & adding an `.executableTarget` to `Package.swift`

    \("swish".cyan) \("--build".cyan), -b
        update & build the scripts package, as a convenience.
    
    \("swish".cyan) \("--macosx".cyan) \("<target-name>".yellow) [arguments...]
        useful when using \("swish".cyan) in a script step of an Xcode
        project. Run \("<target-name>".yellow), by using
        `xcrun --sdk macosx swift [...]`


    """
    .data(using: .utf8)
    .map(FileHandle.standardError.write(_:))
  }
}
