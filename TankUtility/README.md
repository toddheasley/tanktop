# `TankUtility`

`TankUtility` is a Swift package that wraps the [Tank Utility API](http://apidocs.tankutility.com) and handles the following nonsense:

* Persisting Tank Utility authentication securely using [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
* Requesting data from the Tank Utility API via HTTPS
* Returning practical errors when API requests fail
* Modeling device readings and metadata

## Requirements

Supports apps targeting [iOS](https://developer.apple.com/ios)/[iPadOS](https://developer.apple.com/ipad)/[tvOS ](https://developer.apple.com/tvos) 13, as well as [watchOS](https://developer.apple.com/watchos) 6 and [macOS](https://developer.apple.com/macos) 10.15 Catalina.

It's written in [Swift](https://developer.apple.com/documentation/swift) 5.1 using the [Foundation](https://developer.apple.com/documentation/foundation), [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks) and [WatchConnectivity](https://developer.apple.com/documentation/watchconnectivity) frameworks and requires [Xcode](https://developer.apple.com/xcode) 11 or newer to build.

## Examples

Access the bundled example account by authenticating with the email address `tankutility@example.com` and any non-empty string as the password. The example account behaves just like a real Tank Utility account but makes no networking requests to the Tank Utility API.
