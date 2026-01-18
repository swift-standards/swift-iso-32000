// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-iso-32000-tests",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    dependencies: [
        // Parent package
        .package(path: "../"),
        // Testing framework
        .package(path: "../../../swift-foundations/swift-testing"),
        // Test primitives (for test utilities)
        .package(path: "../../../swift-primitives/swift-test-primitives"),
        .package(path: "../../../swift-foundations/swift-snapshot-testing"),
    ],
    targets: [
        .testTarget(
            name: "ISO 32000 Tests",
            dependencies: [
                .product(name: "ISO 32000", package: "swift-iso-32000"),
                .product(name: "Testing", package: "swift-testing"),
                .product(name: "Test Primitives", package: "swift-test-primitives"),
                .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
            ],
            path: "Sources/ISO 32000 Tests"
        ),
        .testTarget(
            name: "ISO 32000 Annex D Tests",
            dependencies: [
                .product(name: "ISO 32000", package: "swift-iso-32000"),
                .product(name: "Testing", package: "swift-testing"),
                .product(name: "Test Primitives", package: "swift-test-primitives"),
            ],
            path: "Sources/ISO 32000 Annex D Tests"
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
