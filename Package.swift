// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SBNavigationController",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "SBNavigationController", targets: ["SBNavigationController"]),
    ],
    targets: [
        .target(name: "SBNavigationController", path: "Sources"),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
