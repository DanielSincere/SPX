# iOS Swish Scripts

These are some scripts for managing your iOS project. Included in this template are a script to generate an app icon from an SVG (`swish appicon`) and a script to push to the App Store (`swish appstore`).

## App Store

This script archives your app & pushes it up to the App Store.

By default, it expects some environment variables, but of course feel free to get them how ever you like, perhaps using [Sh1Password](https://github.com/FullQueueDeveloper/Sh1Password.git).

- `APPLE_TEAM_ID` your development team ID in App Store Connect
- `APPLE_API_KEY_ID` your API Key ID from App Store Connect
- `APPLE_API_ISSUER_ID` your Issuer ID from App Store Connect

You could also use other kinds of credentials for uploading to the App Store, such as username and password, using [LiteralPasswordCredential](https://github.com/FullQueueDeveloper/ShXcrun/blob/trunk/Sources/ShXcrun/Altool/Credential/LiteralPasswordCredential.swift). This will require generate an app-specific password at https://appleid.apple.com.

Be sure to also update the scheme that is built. By default this is `App`. You may also want to update the script if you need to specify a project or workspace to `xcodebuild`.

## App icon

This script uses the SVG at `Swish/AppIcon.svg` by default. You may want to use a different SVG, but this will be useful for pushing to TestFlight.

You may also want to update the output directory to something that makes sense to you. By default, it outputs an `AppIcon.xcassets` to a directory name `App`.
