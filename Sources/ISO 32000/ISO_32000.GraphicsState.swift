// ISO_32000.GraphicsState.swift
// Integration of Graphics State (Section 8.4) with Text State (Section 9.3)

import ISO_32000_8_Graphics
import ISO_32000_9_Text

extension ISO_32000 {
    /// Graphics state namespace (Section 8.4 Graphics state)
    ///
    /// This provides convenient access to graphics state types at the
    /// ISO_32000 level. The authoritative implementation is in
    /// `ISO_32000.8.4.Graphics.State`.
    public enum Graphics {}
}

extension ISO_32000.Graphics {
    /// Graphics state namespace.
    public enum State {}
}

extension ISO_32000.Graphics.State {
    /// Device-independent graphics state parameters (Table 51).
    ///
    /// Concrete type using `ISO_32000.Text.State` for text state.
    public typealias DeviceIndependent = ISO_32000.`8`.`4`.Graphics.State.Device.Independent<ISO_32000.Text.State>

    /// Device-dependent graphics state parameters (Table 52).
    ///
    /// Typealias to `ISO_32000.8.4.Graphics.State.Device.Dependent`.
    public typealias DeviceDependent = ISO_32000.`8`.`4`.Graphics.State.Device.Dependent

    /// Graphics state stack for save/restore (q/Q) operations.
    ///
    /// Generic stack that can hold any state type.
    /// Typealias to `ISO_32000.8.4.Graphics.State.Stack`.
    public typealias Stack<T: Sendable> = ISO_32000.`8`.`4`.Graphics.State.Stack<T>
}

extension ISO_32000 {
    /// PDF Graphics State (Section 8.4 Graphics state)
    ///
    /// The device-independent graphics state containing all parameters
    /// from ISO 32000-2:2020 Table 51: CTM, colors, line styles, text state,
    /// transparency, and rendering parameters.
    ///
    /// This is the concrete type integrating:
    /// - Graphics state structure from Section 8.4
    /// - Text state type from Section 9.3
    ///
    /// ## Usage
    ///
    /// ```swift
    /// var state = ISO_32000.GraphicsState(textState: .init())
    /// state.ctm = ...
    /// state.nonstrokingColor = .rgb(r: 1, g: 0, b: 0)
    /// state.textState.fontSize = 12
    /// state.textState.leading = 14.4  // Line spacing
    /// ```
    ///
    /// ## Stack Operations
    ///
    /// Use `ISO_32000.GraphicsState.Stack` for save/restore (q/Q) operations:
    /// ```swift
    /// typealias Stack = ISO_32000.Graphics.State.Stack<ISO_32000.GraphicsState>
    /// var stack = Stack(initial: .init(textState: .init()))
    /// stack.save()     // q operator
    /// stack.restore()  // Q operator
    /// ```
    public typealias GraphicsState = `8`.`4`.Graphics.State.Device.Independent<Text.State>
}

// MARK: - Default Initializer

extension ISO_32000.GraphicsState {
    /// Create graphics state with default initial values.
    ///
    /// All parameters use their default values per ISO 32000-2:2020 Table 51.
    public init() {
        self.init(textState: .init())
    }
}

// MARK: - Text State Helpers

extension ISO_32000.`8`.`4`.Graphics.State.Stack where State == ISO_32000.GraphicsState {

    /// Set the font size on the current state.
    @inlinable
    public mutating func setFontSize(_ size: ISO_32000.UserSpace.Unit) {
        current.textState.fontSize = size
    }

    /// Set the leading (line spacing) on the current state.
    ///
    /// Leading is the vertical distance between baselines of adjacent lines.
    /// Typical value: 1.2 × fontSize for comfortable reading.
    @inlinable
    public mutating func setLeading(_ leading: ISO_32000.UserSpace.Unit) {
        current.textState.leading = leading
    }

    /// Set the text rise (baseline offset) on the current state.
    ///
    /// Positive values move the baseline up (superscript).
    /// Negative values move the baseline down (subscript).
    @inlinable
    public mutating func setRise(_ rise: ISO_32000.UserSpace.Unit) {
        current.textState.rise = rise
    }

    /// Set the character spacing on the current state.
    @inlinable
    public mutating func setCharacterSpacing(_ spacing: ISO_32000.UserSpace.Unit) {
        current.textState.characterSpacing = spacing
    }

    /// Set the word spacing on the current state.
    @inlinable
    public mutating func setWordSpacing(_ spacing: ISO_32000.UserSpace.Unit) {
        current.textState.wordSpacing = spacing
    }
}
