// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LCEssentials",
    platforms: [
        .iOS(.v13),
        .tvOS(.v9),
        .macOS(.v10_10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "LCEssentials",
            targets: ["LCEssentials"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "Classes", path: "Sources/LCEssentials/Class"),
        .target(name: "HUDAlert", path: "Sources/LCEssentials/HUDAlert"),
        .target(name: "ImagePicker", path: "Sources/LCEssentials/ImagePicker"),
        .target(name: "ImageZoom", path: "Sources/LCEssentials/ImageZoom"),
        .target(name: "Message", path: "Sources/LCEssentials/Message"),
        .target(name: "SwiftUI", path: "Sources/LCEssentials/SwiftUI")
    ]
)
