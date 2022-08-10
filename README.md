# Swish

Swish is a Swift script running tool. Easily run Swift packages in a supporting relative dir named `Swish`

Swish pairs nicely with [Sh](https://github.com/FullQueueDeveloper/Sh) to run shell commands and process shell output from your Swift scripts.

For a full example of using Swish, [Sh](https://github.com/FullQueueDeveloper/Sh), and [ShXcrun](https://github.com/FullQueueDeveloper/ShXcrun) on your iOS project, please see https://github.com/FullQueueDeveloper/SwishExampleiOSProject

## Motivation

There's currently not a great solution to declare some targets as dev dependencies or support scripts in a `Package.swift`. So what if we had a subdirectory with our Swift support scripts? `$PROJECT_ROOT/support-dir/Package.swift`?

But there's currently not a great solution to running Swift packages in another directory. We can type `swift run --package-path path/to/dir targetName`, but that's a lot for quick scripts. We could store that in a `.sh` script file, but I would prefer not to get shell scripts involved with Swift tools.

And if we're running this script during an Xcode build for an iOS project, we need to pass along an SDK flag, to build the Swift script for MacOS.

This is all doable. And this becomes repetitive across multiple projects.

## Installation

Swish is currently available through [Mint](https://github.com/yonaskolb/Mint) or manual installation.

### Mint

Install with [Mint](https://github.com/yonaskolb/Mint)

    mint install FullQueueDeveloper/Swish

### Manual

    git clone https://github.com/FullQueueDeveloper/Swish.git
    cd swish
    swift build -c release

And then add `.build/release/` to your `$PATH`.

## Getting started

    swish --init

Will scaffold a new Swish project in the `swish` subdirectory of your current working directory. This is what it will look like.

    CWD
     |
     +- Swish
          |
          +- Package.swift
          +- .gitignore
          +- Sources/script1/main.swift

Then you can run `swish` or `swish --list` to see the current executable targets. Then you can run `swish script1` to run the simple sample script named `script1`.

## Usage

### Regular use

    swish <target-name> [arguments...]

    - <target-name>  The name of the `executableTarget` in the
                                `Package.swift` in the `scripts`
                                subdirectory of the current working
                                directory.
    - [arguments...]  Arguments passed to the target

### Available commands

    swish
        list the available targets

    swish --list
        list the available targets

    swish --version
        show version and exit

    swish --help
        show this message

    swish --init
        scaffold a new Swish scripts subdirectory in
        the current directory. The default scripts
        subdirectory is `scripts`

    swish --add <name>
        add a new script named <name> by
        creating a file at path `Sources/<name>/main.swift`
        & adding an `.executableTarget` to `Package.swift`

    swish --build
        update & build the scripts package, as a convenience.

## Demos

There is an example project in the `demos` folder

- The `VaporDemo` is a [Vapor](https://vapor.codes) app. It can be a handful to type out a full `docker build` command with all flags and arguments. This example is short, but still meaningful. Running `swish docker` from the `demos/VaporDemo` directory will build the docker container for this small vapor app.
