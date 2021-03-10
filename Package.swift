// swift-tools-version:5.3

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/03/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "CaptureView",
    platforms: [
        .macOS(.v10_13), .iOS(.v14)
    ],
    products: [
        .library(
            name: "CaptureView",
            targets: ["CaptureView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.3.1")
    ],
    targets: [
        .target(
            name: "CaptureView",
            dependencies: []),
        .testTarget(
            name: "CaptureViewTests",
            dependencies: ["CaptureView", "XCTestExtensions"]),
    ]
)
