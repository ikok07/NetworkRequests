// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkRequests",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkRequests",
            targets: ["NetworkRequests"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bernndr/swift-macros.git", branch: "main"),
        .package(url: "https://github.com/ikok07/JSONCoder.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkRequests",
            dependencies: [
                .product(name: "SwiftMacros", package: "swift-macros"),
                .product(name: "JSONCoder", package: "JSONCoder")
            ]
        ),
        .testTarget(
            name: "NetworkRequestsTests",
            dependencies: ["NetworkRequests"]),
    ]
)
