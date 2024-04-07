// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StrongContractClient",
    platforms: [
       .iOS(.v13), // Specify the minimum platform version (iOS 13 in this example)
       .macOS(.v10_15), // Add other platforms as needed, for example, macOS
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "StrongContractClient",
            targets: ["StrongContractClient"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // Include the Callable library from its GitHub repository
        .package(url: "https://github.com/ElevatedUnderdogs/Callable.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "StrongContractClient",
            dependencies: [
                // Specify the dependencies of this target.
                .product(name: "Callable", package: "Callable"), // Adjust based on the actual product name in the Callable package
            ]),
        .testTarget(
            name: "StrongContractClientTests",
            dependencies: ["StrongContractClient"]),
    ]
)
