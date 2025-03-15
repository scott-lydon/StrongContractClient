// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "StrongContractClient",
    platforms: [
       .iOS(.v13),
       .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "StrongContract",
            targets: ["StrongContract"]
        ),
        .library(
            name: "StrongContractServer",
            targets: ["StrongContractServer"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ElevatedUnderdogs/Callable.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/scott-lydon/EncryptDecryptKey.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0") // ✅ Vapor is included conditionally below
    ],
    targets: [
        .target(
            name: "StrongContract",
            dependencies: [
                .product(name: "Callable", package: "Callable"),
                "EncryptDecryptKey"
            ]
        ),
        .target(
            name: "StrongContractServer",
            dependencies: [
                .target(name: "StrongContract"), // ✅ Added StrongContract as a dependency
                .product(name: "Callable", package: "Callable"),
                "EncryptDecryptKey",
                .product(name: "Vapor", package: "vapor", condition: .when(platforms: [.macOS, .linux]))
            ]
        ),
        .testTarget(
            name: "StrongContractTests",
            dependencies: ["StrongContract"]
        ),
    ]
)
