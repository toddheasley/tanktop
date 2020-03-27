// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "TankUtility",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(name: "TankUtility", targets: [
            "TankUtility"
        ])
    ],
    targets: [
        .target(name: "TankUtility", dependencies: []),
        .testTarget(name: "TankUtilityTests", dependencies: [
            "TankUtility"
        ])
    ]
)
