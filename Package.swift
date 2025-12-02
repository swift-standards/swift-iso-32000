// swift-tools-version: 6.2

import PackageDescription

// ISO 32000: Document management — Portable document format
let package = Package(
    name: "swift-iso-32000",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
    ],
    products: [
        .library(name: "ISO 32000", targets: ["ISO 32000"]),
        .library(name: "ISO 32000 Flate", targets: ["ISO 32000 Flate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-standards", from: "0.8.0"),
        .package(url: "https://github.com/swift-standards/swift-iso-9899", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-incits-4-1986", from: "0.6.0"),
        .package(path: "../swift-rfc-1950"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
    ],
    targets: [
        .target(
            name: "ISO 32000",
            dependencies: [
                .product(name: "Standards", package: "swift-standards"),
                .product(name: "ISO 9899", package: "swift-iso-9899"),
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
            ]
        ),
        .target(
            name: "ISO 32000 Flate",
            dependencies: [
                "ISO 32000",
                .product(name: "RFC 1950", package: "swift-rfc-1950"),
            ]
        ),
        .testTarget(
            name: "ISO 32000".tests,
            dependencies: [
                "ISO 32000",
                "ISO 32000 Flate",
                .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
}
