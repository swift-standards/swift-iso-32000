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
    traits: [
        .default(enabledTraits: ["Codable"]),
        .trait(
            name: "Codable",
            description: "Include Codable conformances (not compatible with Swift Embedded)"
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-standards", from: "0.20.0", traits: [.trait(name: "Codable", condition: .when(traits: ["Codable"]))]),
        .package(url: "https://github.com/swift-standards/swift-iso-9899", from: "0.2.3"),
        .package(url: "https://github.com/swift-standards/swift-ieee-754", from: "0.3.3"),
        .package(url: "https://github.com/swift-standards/swift-incits-4-1986", from: "0.6.5"),
        .package(url: "https://github.com/swift-standards/swift-rfc-1950", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-iec-61966", from: "0.1.0"),
        .package(path: "../swift-w3c-png"),
        .package(path: "../swift-iso-14496-22"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
    ],
    targets: [
        // MARK: - Shared
        .target(
            name: "ISO 32000 Shared",
            dependencies: [
                .product(name: "Geometry", package: "swift-standards"),
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
                .product(name: "Formatting", package: "swift-standards"),
                .product(name: "IEEE 754", package: "swift-ieee-754"),
            ]
        ),
        .target(
            name: "ISO 32000 8 Graphics",
            dependencies: [
                "ISO 32000 Shared",
                "ISO 32000 7 Syntax",
                .product(name: "IEC 61966", package: "swift-iec-61966"),
                .product(name: "Dimension", package: "swift-standards"),
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
                .product(name: "Standards", package: "swift-standards"),
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
                .product(name: "Standards", package: "swift-standards"),
                .product(name: "Geometry", package: "swift-standards"),
                .product(name: "Formatting", package: "swift-standards"),
                .product(name: "ISO 9899", package: "swift-iso-9899"),
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
                .product(name: "Formatting", package: "swift-standards"),
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
                .product(name: "StandardsTestSupport", package: "swift-standards"),
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
        .define("Codable", .when(traits: ["Codable"])),
    ]
}
