# `TankUtility`

`TankUtility` is a lightweight Cocoa framework that neatly packages the [Tank Utility API](http://apidocs.tankutility.com) for drop-in usage in macOS, iOS, watchOS and tvOS apps. It handles the following nonsense:

* Persisting Tank Utility authentication securely using [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
* Requesting data from the Tank Utility API via HTTPS
* Returning practical errors when API requests fail
* Modeling device readings and metadata

## Example Usage

To give you an idea how deep the water gets before you wade in, here's the short version:


```swift
import TankUtility

TankUtility.authorize(username: "tanktop@example.com", password: "********") { error in
    guard error == nil else {
        print(error ?? TankUtility.Error.unauthorized)
        return
    }
    TankUtility.devices { devices, error in
        guard error == nil, let id: String = devices.first else {
            print(error ?? TankUtility.Error.notFound)
            return
        }
        TankUtility.device(id: id) { device, error in
            guard let device: Device = device else {
                return
            }
            print("\(device.name): \(String(percent: device.lastReading?.tank) ?? "NA")")
            TankUtility.deauthorize()
        }
    }
}

```

`TankUtility` includes a dummy account that you can view using the email address `tanktop@example.com` and any non-empty string as a password. It behaves exactly like a real Tank Utility account, but the data is being populated from a bundled JSON file, rather than the actual Tank Utility API.

There's also running code in the form of an iOS app that lives in the [Tanktop](../Tanktop) Xcode project that's workspace-adjacent to this one.

## Requirements

`TankUtility` is written in [Swift 5](https://docs.swift.org/swift-book) and requires [Xcode](https://developer.apple.com/xcode) 10.2 or newer to build.
