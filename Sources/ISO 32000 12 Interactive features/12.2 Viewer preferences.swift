// ISO 32000-2:2020, 12.2 Viewer preferences
//
// The ViewerPreferences entry in a document's catalog dictionary (see 7.7.2)
// designates a viewer preferences dictionary (PDF 1.2) controlling the way
// the document shall be presented on the screen or in print.

public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.2 Viewer preferences
    public enum `2` {}
}

// MARK: - Table 147: Viewer Preferences Dictionary

extension ISO_32000.`12`.`2` {
    /// Viewer preferences dictionary (Table 147)
    ///
    /// Controls how the document is presented on screen or in print.
    /// If no viewer preferences dictionary is specified, PDF processors
    /// should behave in accordance with their own current user preference settings.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — Entries in a viewer preferences dictionary
    public struct ViewerPreferences: Sendable, Hashable, Codable {

        // MARK: - UI Visibility Options

        /// A flag specifying whether to hide the interactive PDF processor's
        /// tool bars when the document is active.
        ///
        /// Default value: `false`
        public var hideToolbar: Bool

        /// A flag specifying whether to hide the interactive PDF processor's
        /// menu bar when the document is active.
        ///
        /// Default value: `false`
        public var hideMenubar: Bool

        /// A flag specifying whether to hide user interface elements in the
        /// document's window (such as scroll bars and navigation controls),
        /// leaving only the document's contents displayed.
        ///
        /// Default value: `false`
        public var hideWindowUI: Bool

        // MARK: - Window Behavior Options

        /// A flag specifying whether to resize the document's window to fit
        /// the size of the first displayed page.
        ///
        /// Default value: `false`
        public var fitWindow: Bool

        /// A flag specifying whether to position the document's window in
        /// the centre of the screen.
        ///
        /// Default value: `false`
        public var centerWindow: Bool

        /// A flag specifying whether the window's title bar should display
        /// the document title taken from the dc:title element of the XMP
        /// metadata stream (see 14.3.2, "Metadata streams").
        ///
        /// If `false`, the title bar should instead display the name of the
        /// PDF file containing the document.
        ///
        /// - Note: PDF 1.4
        ///
        /// Default value: `false`
        public var displayDocTitle: Bool

        // MARK: - Page Mode and Direction

        /// The document's page mode, specifying how to display the document
        /// on exiting full-screen mode.
        ///
        /// This entry is meaningful only if the value of the PageMode entry
        /// in the catalog dictionary is FullScreen; it shall be ignored otherwise.
        ///
        /// Default value: `.useNone`
        public var nonFullScreenPageMode: NonFullScreenPageMode

        /// The predominant logical content order for text.
        ///
        /// This entry has no direct effect on the document's contents or page
        /// numbering but may be used to determine the relative positioning of
        /// pages when displayed side by side or printed n-up.
        ///
        /// - Note: PDF 1.3
        ///
        /// Default value: `.leftToRight`
        public var direction: Direction

        // MARK: - Page Boundaries (Deprecated in PDF 2.0)

        /// The name of the page boundary representing the area of a page
        /// that shall be displayed when viewing the document on the screen.
        ///
        /// - Note: PDF 1.4; deprecated in PDF 2.0
        ///
        /// Default value: `.cropBox`
        public var viewArea: PageBoundary

        /// The name of the page boundary to which the contents of a page
        /// shall be clipped when viewing the document on the screen.
        ///
        /// - Note: PDF 1.4; deprecated in PDF 2.0
        ///
        /// Default value: `.cropBox`
        public var viewClip: PageBoundary

        /// The name of the page boundary representing the area of a page
        /// that shall be rendered when printing the document.
        ///
        /// - Note: PDF 1.4; deprecated in PDF 2.0
        ///
        /// Default value: `.cropBox`
        public var printArea: PageBoundary

        /// The name of the page boundary to which the contents of a page
        /// shall be clipped when printing the document.
        ///
        /// - Note: PDF 1.4; deprecated in PDF 2.0
        ///
        /// Default value: `.cropBox`
        public var printClip: PageBoundary

        // MARK: - Print Options

        /// The page scaling option that shall be selected when a print
        /// dialogue is displayed for this document.
        ///
        /// If this entry has an unrecognised value, `.appDefault` shall be used.
        /// If the print dialogue is suppressed and its parameters are provided
        /// from some other source, this entry nevertheless shall be honoured.
        ///
        /// - Note: PDF 1.6
        ///
        /// Default value: `.appDefault`
        public var printScaling: PrintScaling

        /// The paper handling option that shall be used when printing the
        /// PDF file from the print dialogue.
        ///
        /// - Note: PDF 1.7
        ///
        /// Default value: implementation dependent
        public var duplex: Duplex?

        /// A flag specifying whether the PDF page size shall be used to
        /// select the input paper tray.
        ///
        /// This setting influences only the preset values used to populate
        /// the print dialogue presented by an interactive PDF processor.
        /// If `true`, the check box in the print dialogue associated with
        /// input paper tray shall be checked.
        ///
        /// This setting has no effect on operating systems that do not
        /// provide the ability to pick the input tray by size.
        ///
        /// - Note: PDF 1.7
        ///
        /// Default value: implementation dependent
        public var pickTrayByPDFSize: Bool?

        /// The page numbers used to initialise the print dialogue box when
        /// the PDF file is printed.
        ///
        /// Each pair specifies the first and last pages (1-based) in a
        /// sub-range of pages to be printed.
        ///
        /// - Note: PDF 1.7. Although PrintPageRange uses 1-based page
        ///   numbering, other features of PDF use zero-based page numbering.
        ///
        /// Default value: implementation dependent
        public var printPageRange: [PageRange]?

        /// The number of copies that shall be printed when the print dialog
        /// is opened for this PDF file.
        ///
        /// - Note: PDF 1.7
        ///
        /// Default value: implementation dependent, but typically 1
        public var numCopies: Int?

        // MARK: - Enforcement (PDF 2.0)

        /// An array of names of Viewer preference settings that shall be
        /// enforced by PDF processors and that shall not be overridden by
        /// subsequent selections in the application user interface.
        ///
        /// - Note: PDF 2.0
        ///
        /// Default value: empty (no enforcement)
        public var enforce: [EnforceableSetting]

        // MARK: - Initialization

        /// Creates a viewer preferences dictionary with default values.
        public init(
            hideToolbar: Bool = false,
            hideMenubar: Bool = false,
            hideWindowUI: Bool = false,
            fitWindow: Bool = false,
            centerWindow: Bool = false,
            displayDocTitle: Bool = false,
            nonFullScreenPageMode: NonFullScreenPageMode = .useNone,
            direction: Direction = .leftToRight,
            viewArea: PageBoundary = .cropBox,
            viewClip: PageBoundary = .cropBox,
            printArea: PageBoundary = .cropBox,
            printClip: PageBoundary = .cropBox,
            printScaling: PrintScaling = .appDefault,
            duplex: Duplex? = nil,
            pickTrayByPDFSize: Bool? = nil,
            printPageRange: [PageRange]? = nil,
            numCopies: Int? = nil,
            enforce: [EnforceableSetting] = []
        ) {
            self.hideToolbar = hideToolbar
            self.hideMenubar = hideMenubar
            self.hideWindowUI = hideWindowUI
            self.fitWindow = fitWindow
            self.centerWindow = centerWindow
            self.displayDocTitle = displayDocTitle
            self.nonFullScreenPageMode = nonFullScreenPageMode
            self.direction = direction
            self.viewArea = viewArea
            self.viewClip = viewClip
            self.printArea = printArea
            self.printClip = printClip
            self.printScaling = printScaling
            self.duplex = duplex
            self.pickTrayByPDFSize = pickTrayByPDFSize
            self.printPageRange = printPageRange
            self.numCopies = numCopies
            self.enforce = enforce
        }

        /// Default viewer preferences (all defaults per the spec).
        public static let `default` = ViewerPreferences()
    }
}

// MARK: - NonFullScreenPageMode

extension ISO_32000.`12`.`2` {
    /// The document's page mode on exiting full-screen mode (Table 147)
    ///
    /// Specifies how to display the document on exiting full-screen mode.
    /// This entry is meaningful only if the PageMode entry in the catalog
    /// dictionary is FullScreen.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — NonFullScreenPageMode
    public enum NonFullScreenPageMode: String, Sendable, Hashable, Codable, CaseIterable {
        /// Neither document outline nor thumbnail images visible
        case useNone = "UseNone"

        /// Document outline visible
        case useOutlines = "UseOutlines"

        /// Thumbnail images visible
        case useThumbs = "UseThumbs"

        /// Optional content group panel visible
        case useOC = "UseOC"
    }
}

// MARK: - Direction

extension ISO_32000.`12`.`2` {
    /// The predominant logical content order for text (Table 147)
    ///
    /// This entry has no direct effect on the document's contents or page
    /// numbering but may be used to determine the relative positioning of
    /// pages when displayed side by side or printed n-up.
    ///
    /// - Note: PDF 1.3
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — Direction
    public enum Direction: String, Sendable, Hashable, Codable, CaseIterable {
        /// Left to right
        case leftToRight = "L2R"

        /// Right to left (including vertical writing systems, such as
        /// Chinese, Japanese, and Korean)
        case rightToLeft = "R2L"
    }
}

// MARK: - PageBoundary

extension ISO_32000.`12`.`2` {
    /// Page boundary names for view/print area and clip settings (Table 147)
    ///
    /// The value is the key designating the relevant page boundary in the
    /// page object (see 7.7.3, "Page tree" and 14.11.2, "Page boundaries").
    ///
    /// - Note: PDF 1.4; deprecated in PDF 2.0
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — ViewArea, ViewClip, PrintArea, PrintClip
    public enum PageBoundary: String, Sendable, Hashable, Codable, CaseIterable {
        /// The media box
        case mediaBox = "MediaBox"

        /// The crop box (default)
        case cropBox = "CropBox"

        /// The bleed box
        case bleedBox = "BleedBox"

        /// The trim box
        case trimBox = "TrimBox"

        /// The art box
        case artBox = "ArtBox"
    }
}

// MARK: - PrintScaling

extension ISO_32000.`12`.`2` {
    /// Page scaling option for print dialogue (Table 147)
    ///
    /// If this entry has an unrecognised value, `.appDefault` shall be used.
    ///
    /// - Note: PDF 1.6
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — PrintScaling
    public enum PrintScaling: String, Sendable, Hashable, Codable, CaseIterable {
        /// No page scaling
        case none = "None"

        /// Interactive PDF processor's default print scaling
        case appDefault = "AppDefault"
    }
}

// MARK: - Duplex

extension ISO_32000.`12`.`2` {
    /// Paper handling option for print dialogue (Table 147)
    ///
    /// - Note: PDF 1.7
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — Duplex
    public enum Duplex: String, Sendable, Hashable, Codable, CaseIterable {
        /// Print single-sided
        case simplex = "Simplex"

        /// Duplex and flip on the short edge of the sheet
        case duplexFlipShortEdge = "DuplexFlipShortEdge"

        /// Duplex and flip on the long edge of the sheet
        case duplexFlipLongEdge = "DuplexFlipLongEdge"
    }
}

// MARK: - PageRange

extension ISO_32000.`12`.`2` {
    /// A range of pages for printing (Table 147)
    ///
    /// Specifies the first and last pages in a sub-range of pages to be printed.
    /// Page numbers are 1-based (the first page of the PDF file is denoted by 1).
    ///
    /// - Note: PDF 1.7. Although PrintPageRange uses 1-based page numbering,
    ///   other features of PDF use zero-based page numbering.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — PrintPageRange
    public struct PageRange: Sendable, Hashable, Codable {
        /// The first page in the range (1-based)
        public var first: Int

        /// The last page in the range (1-based)
        public var last: Int

        /// Creates a page range.
        ///
        /// - Parameters:
        ///   - first: The first page (1-based)
        ///   - last: The last page (1-based)
        public init(first: Int, last: Int) {
            self.first = first
            self.last = last
        }

        /// Creates a single-page range.
        ///
        /// - Parameter page: The page number (1-based)
        public init(page: Int) {
            self.first = page
            self.last = page
        }
    }
}

// MARK: - Table 148: EnforceableSetting

extension ISO_32000.`12`.`2` {
    /// Names that may appear in the Enforce array (Table 148)
    ///
    /// The Enforce array shall only include names that occur in Table 148.
    /// Future additions to this table shall be limited to keys in the viewer
    /// preferences dictionary with the following qualities:
    /// - can be assigned values that cannot be used in a denial-of-service attack
    /// - have default values that cannot be overridden using the application UI
    ///
    /// - Note: PDF 2.0
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 148 — Names defined for an Enforce array
    public enum EnforceableSetting: String, Sendable, Hashable, Codable, CaseIterable {
        /// Enforce the PrintScaling setting.
        ///
        /// This name may appear in the Enforce array only if the corresponding
        /// entry in the viewer preferences dictionary specifies a valid value
        /// other than AppDefault.
        case printScaling = "PrintScaling"
    }
}

// MARK: - Convenience Typealiases

extension ISO_32000 {
    /// Viewer preferences dictionary
    public typealias ViewerPreferences = ISO_32000.`12`.`2`.ViewerPreferences
}
