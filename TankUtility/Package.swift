// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TankUtility",
    platforms: [
        .macOS(.v10_16),
        .iOS(.v14),
        .watchOS(.v7),
        .tvOS(.v14)
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
