// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "StrongContractClient",
    platforms: [
       .iOS(.v13), // Specify the minimum platform version (iOS 13 in this example)
       .macOS(.v10_15), // Add other platforms as needed, for example, macOS
    ],
    products: [
        .library(
            name: "StrongContractClient",
            targets: ["StrongContractClient"]),
    ],
    dependencies: [
        // Existing dependencies
        .package(url: "https://github.com/ElevatedUnderdogs/Callable.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/scott-lydon/EncryptDecryptKey.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "StrongContractClient",
            dependencies: [
                .product(name: "Callable", package: "Callable"),
                // Conditional dependency on Vapor for the macOS platform only
                .product(name: "Vapor", package: "vapor", condition: .when(platforms: [.macOS])),
                "EncryptDecryptKey",
            ]),
        .testTarget(
            name: "StrongContractClientTests",
            dependencies: ["StrongContractClient"]),
    ]
)
