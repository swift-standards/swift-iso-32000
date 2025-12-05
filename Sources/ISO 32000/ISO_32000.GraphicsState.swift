// ISO_32000.GraphicsState.swift
// Typealias to authoritative implementation in Section 8.4

import ISO_32000_8_Graphics

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
    /// Typealias to `ISO_32000.8.4.Graphics.State.Device.Independent`.
    public typealias DeviceIndependent = ISO_32000.`8`.`4`.Graphics.State.Device.Independent

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
    /// ## Usage
    ///
    /// ```swift
    /// var state = ISO_32000.GraphicsState()
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
    /// var stack = Stack(initial: .init())
    /// stack.save()     // q operator
    /// stack.restore()  // Q operator
    /// ```
    public typealias GraphicsState = `8`.`4`.Graphics.State.Device.Independent
}
