// Performance Tests.swift

import Testing

@testable import ISO_32000

extension Tag {
    @Tag static var performance: Self
}

@Suite("Performance Tests", .serialized, .tags(.performance))
struct PerformanceTests {

    // MARK: - String Width Calculation

    @Test("String width: 10 chars")
    func stringWidth10() {
        let font = ISO_32000.Font.helvetica
        let text = "Hello World"
        let _ = font.width(of: text, atSize: 12)
    }

    @Test("String width: 100 chars")
    func stringWidth100() {
        let font = ISO_32000.Font.helvetica
        let text = String(repeating: "Lorem ipsum dolor sit amet. ", count: 4)
        let _ = font.width(of: text, atSize: 12)
    }

    @Test("String width: 1000 chars")
    func stringWidth1000() {
        let font = ISO_32000.Font.helvetica
        let text = String(
            repeating: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
            count: 18
        )
        let _ = font.width(of: text, atSize: 12)
    }

    // MARK: - WinAnsi Bytes Width Calculation

    @Test("WinAnsi width: 10 bytes")
    func winAnsiWidth10() {
        let font = ISO_32000.Font.helvetica
        let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x57, 0x6F, 0x72, 0x6C]
        let _ = font.winAnsi.width(of: bytes, atSize: 12)
    }

    @Test("WinAnsi width: 100 bytes")
    func winAnsiWidth100() {
        let font = ISO_32000.Font.helvetica
        let bytes = [UInt8](repeating: 0x61, count: 100)  // 'a' repeated
        let _ = font.winAnsi.width(of: bytes, atSize: 12)
    }

    @Test("WinAnsi width: 1000 bytes")
    func winAnsiWidth1000() {
        let font = ISO_32000.Font.helvetica
        let bytes = [UInt8](repeating: 0x61, count: 1000)
        let _ = font.winAnsi.width(of: bytes, atSize: 12)
    }

    // MARK: - Throughput Tests

    @Test("String width throughput (5s)")
    func stringWidthThroughput() {
        let font = ISO_32000.Font.helvetica
        let text = String(repeating: "Lorem ipsum dolor sit amet. ", count: 4)  // ~100 chars
        let duration: Duration = .seconds(5)
        let start = ContinuousClock.now

        var count = 0
        while ContinuousClock.now - start < duration {
            for _ in 0..<100 {
                let _ = font.width(of: text, atSize: 12)
            }
            count += 100
        }

        let elapsed = ContinuousClock.now - start
        let seconds =
            Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) / 1e18
        let throughput = Double(count) / seconds

        print("📊 String width throughput: \(Int(throughput)) calculations/sec")
    }

    @Test("WinAnsi width throughput (5s)")
    func winAnsiWidthThroughput() {
        let font = ISO_32000.Font.helvetica
        let bytes = [UInt8](repeating: 0x61, count: 100)
        let duration: Duration = .seconds(5)
        let start = ContinuousClock.now

        var count = 0
        while ContinuousClock.now - start < duration {
            for _ in 0..<100 {
                let _ = font.winAnsi.width(of: bytes, atSize: 12)
            }
            count += 100
        }

        let elapsed = ContinuousClock.now - start
        let seconds =
            Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) / 1e18
        let throughput = Double(count) / seconds

        print("📊 WinAnsi width throughput: \(Int(throughput)) calculations/sec")
    }

    // MARK: - Scaling Analysis

    @Test("Width calculation scaling analysis")
    func scalingAnalysis() {
        let font = ISO_32000.Font.helvetica
        let sizes = [10, 100, 500, 1000, 2000]
        var results: [(size: Int, time: Double)] = []

        for size in sizes {
            let bytes = [UInt8](repeating: 0x61, count: size)
            let iterations = max(10, 1000 / size)
            var totalTime: Double = 0

            for _ in 0..<iterations {
                let start = ContinuousClock.now
                let _ = font.winAnsi.width(of: bytes, atSize: 12)
                let elapsed = ContinuousClock.now - start
                totalTime +=
                    Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds)
                    / 1e18
            }

            let avgTime = totalTime / Double(iterations)
            results.append((size, avgTime))
        }

        for (size, time) in results {
            let timeUs = time * 1_000_000
            let perByte = timeUs / Double(size)
            print("Size \(size): \(Int(timeUs)) us total, \(Int(perByte * 1000)) ns/byte")
        }

        // Verify linear scaling: last per-byte cost should not exceed 3x first
        if results.count >= 2 {
            let firstPerByte = results.first!.time / Double(results.first!.size)
            let lastPerByte = results.last!.time / Double(results.last!.size)
            let ratio = lastPerByte / firstPerByte
            #expect(ratio < 3.0, "Width calculation scales worse than O(n): ratio \(ratio)")
        }
    }
}

// MARK: - Regression Guards

@Suite("Regression Guards", .serialized, .tags(.performance))
struct RegressionGuards {

    @Test("Width calculation regression guard")
    func widthCalculationRegression() {
        let font = ISO_32000.Font.helvetica
        let bytes = [UInt8](repeating: 0x61, count: 100)

        // Minimum acceptable: 10,000 calculations/sec for 100-byte strings
        // Baseline (2025-12-17): ~17,000-22,000/sec (varies with system load)
        // Threshold is ~50% of baseline to account for variance
        let minThroughput = 10_000.0

        let duration: Duration = .seconds(2)
        let start = ContinuousClock.now
        var count = 0

        while ContinuousClock.now - start < duration {
            for _ in 0..<100 {
                let _ = font.winAnsi.width(of: bytes, atSize: 12)
            }
            count += 100
        }

        let elapsed = ContinuousClock.now - start
        let seconds =
            Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) / 1e18
        let throughput = Double(count) / seconds

        print(
            "📊 Width calculation throughput: \(Int(throughput)) calculations/sec (minimum: \(Int(minThroughput)))"
        )

        #expect(
            throughput >= minThroughput,
            "Performance regression detected: \(Int(throughput)) < \(Int(minThroughput)) calculations/sec"
        )
    }

    @Test("String width regression guard")
    func stringWidthRegression() {
        let font = ISO_32000.Font.helvetica
        let text = String(repeating: "a", count: 100)

        // Minimum acceptable: 20,000 calculations/sec for 100-char strings
        // Baseline (2025-12-17): ~30,000-65,000/sec (varies with system load)
        // Threshold is ~50% of low-end baseline to account for variance
        let minThroughput = 20_000.0

        let duration: Duration = .seconds(2)
        let start = ContinuousClock.now
        var count = 0

        while ContinuousClock.now - start < duration {
            for _ in 0..<100 {
                let _ = font.width(of: text, atSize: 12)
            }
            count += 100
        }

        let elapsed = ContinuousClock.now - start
        let seconds =
            Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) / 1e18
        let throughput = Double(count) / seconds

        print(
            "📊 String width throughput: \(Int(throughput)) calculations/sec (minimum: \(Int(minThroughput)))"
        )

        #expect(
            throughput >= minThroughput,
            "Performance regression detected: \(Int(throughput)) < \(Int(minThroughput)) calculations/sec"
        )
    }
}
