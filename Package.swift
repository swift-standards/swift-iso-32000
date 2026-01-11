// swift-tools-version: 6.2

import PackageDescription

// ISO 32000: Document management — Portable document format
let package = Package(
    name: "swift-iso-32000",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "ISO 32000", targets: ["ISO 32000"]),
        .library(name: "ISO 32000 Flate", targets: ["ISO 32000 Flate"]),
        .library(name: "ISO 32000 Shared", targets: ["ISO 32000 Shared"]),
        .library(name: "ISO 32000 3 Terms and definitions", targets: ["ISO 32000 3 Terms and definitions"]),
        .library(name: "ISO 32000 7 Syntax", targets: ["ISO 32000 7 Syntax"]),
        .library(name: "ISO 32000 8 Graphics", targets: ["ISO 32000 8 Graphics"]),
        .library(name: "ISO 32000 9 Text", targets: ["ISO 32000 9 Text"]),
        .library(name: "ISO 32000 10 Rendering", targets: ["ISO 32000 10 Rendering"]),
        .library(name: "ISO 32000 11 Transparency", targets: ["ISO 32000 11 Transparency"]),
        .library(name: "ISO 32000 12 Interactive features", targets: ["ISO 32000 12 Interactive features"]),
        .library(name: "ISO 32000 13 Multimedia features", targets: ["ISO 32000 13 Multimedia features"]),
        .library(name: "ISO 32000 14 Document interchange", targets: ["ISO 32000 14 Document interchange"]),
        .library(name: "ISO 32000 Annex D", targets: ["ISO 32000 Annex D"]),
    ],
    dependencies: [
        // Primitives
        .package(path: "../../swift-primitives/swift-geometry-primitives"),
        .package(path: "../../swift-primitives/swift-formatting-primitives"),
        .package(path: "../../swift-primitives/swift-dimension-primitives"),
        .package(path: "../../swift-primitives/swift-numeric-primitives"),
        .package(path: "../../swift-primitives/swift-binary-primitives"),
        .package(path: "../../swift-primitives/swift-standard-library-extensions"),
        .package(path: "../../swift-primitives/swift-test-primitives"),
        // Standards
        .package(path: "../swift-iso-9899"),
        .package(path: "../swift-ieee-754"),
        .package(path: "../swift-incits-4-1986"),
        .package(path: "../swift-rfc-1950"),
        .package(path: "../swift-rfc-4648"),
        .package(path: "../swift-iec-61966"),
        .package(path: "../swift-w3c-png"),
        .package(path: "../swift-iso-14496-22"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
    ],
    targets: [
        // MARK: - Shared
        .target(
            name: "ISO 32000 Shared",
            dependencies: [
                .product(name: "Geometry Primitives", package: "swift-geometry-primitives"),
                .product(name: "Numeric Primitives", package: "swift-numeric-primitives"),
            ]
        ),
        
        // MARK: - Clause Targets (literal spec encoding)
        .target(
            name: "ISO 32000 3 Terms and definitions",
            dependencies: ["ISO 32000 Shared"]
        ),
        .target(
            name: "ISO 32000 7 Syntax",
            dependencies: [
                "ISO 32000 Shared",
                "ISO 32000 3 Terms and definitions",
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
                .product(name: "Formatting Primitives", package: "swift-formatting-primitives"),
                .product(name: "Binary Primitives", package: "swift-binary-primitives"),
                .product(name: "IEEE 754", package: "swift-ieee-754"),
            ]
        ),
        .target(
            name: "ISO 32000 8 Graphics",
            dependencies: [
                "ISO 32000 Shared",
                "ISO 32000 7 Syntax",
                .product(name: "IEC 61966", package: "swift-iec-61966"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
            ]
        ),
        .target(
            name: "ISO 32000 9 Text",
            dependencies: [
                "ISO 32000 Shared",
                "ISO 32000 7 Syntax",
                "ISO 32000 8 Graphics",
                "ISO 32000 Annex D",
                .product(name: "ISO 14496-22", package: "swift-iso-14496-22"),
            ]
        ),
        .target(
            name: "ISO 32000 10 Rendering",
            dependencies: ["ISO 32000 Shared", "ISO 32000 7 Syntax", "ISO 32000 8 Graphics"]
        ),
        .target(
            name: "ISO 32000 11 Transparency",
            dependencies: ["ISO 32000 Shared", "ISO 32000 7 Syntax", "ISO 32000 8 Graphics"]
        ),
        .target(
            name: "ISO 32000 12 Interactive features",
            dependencies: ["ISO 32000 Shared", "ISO 32000 7 Syntax", "ISO 32000 8 Graphics"]
        ),
        .target(
            name: "ISO 32000 13 Multimedia features",
            dependencies: ["ISO 32000 Shared", "ISO 32000 7 Syntax"]
        ),
        .target(
            name: "ISO 32000 14 Document interchange",
            dependencies: [
                "ISO 32000 Shared",
                "ISO 32000 7 Syntax",
                .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions"),
                .product(name: "Binary Primitives", package: "swift-binary-primitives"),
            ]
        ),
        .target(
            name: "ISO 32000 Annex D",
            dependencies: ["ISO 32000 Shared"]
        ),

        // MARK: - High-level API
        .target(
            name: "ISO 32000",
            dependencies: [
                "ISO 32000 3 Terms and definitions",
                "ISO 32000 7 Syntax",
                "ISO 32000 8 Graphics",
                "ISO 32000 9 Text",
                "ISO 32000 10 Rendering",
                "ISO 32000 11 Transparency",
                "ISO 32000 12 Interactive features",
                "ISO 32000 13 Multimedia features",
                "ISO 32000 14 Document interchange",
                "ISO 32000 Annex D",
                .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions"),
                .product(name: "Geometry Primitives", package: "swift-geometry-primitives"),
                .product(name: "Formatting Primitives", package: "swift-formatting-primitives"),
                .product(name: "Binary Primitives", package: "swift-binary-primitives"),
                .product(name: "ISO 9899", package: "swift-iso-9899"),
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
                .product(name: "RFC 4648", package: "swift-rfc-4648"),
            ]
        ),
        .target(
            name: "ISO 32000 Flate",
            dependencies: [
                "ISO 32000",
                "ISO 32000 Shared",
                .product(name: "RFC 1950", package: "swift-rfc-1950"),
                .product(name: "W3C PNG", package: "swift-w3c-png"),
            ]
        ),
        .testTarget(
            name: "ISO 32000".tests,
            dependencies: [
                "ISO 32000",
                "ISO 32000 Flate",
                .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Test Primitives", package: "swift-test-primitives"),
            ]
        ),
        .testTarget(
            name: "ISO 32000 Annex D".tests,
            dependencies: [
                "ISO 32000 Annex D",
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
