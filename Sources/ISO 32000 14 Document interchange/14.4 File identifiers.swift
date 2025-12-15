// ISO 32000-2:2020, 14.4 File identifiers

import ISO_32000_Shared

// 14.4 File identifiers
// PDF file identifiers shall be defined by the ID entry in a PDF file’s trailer dictionary (see 7.5.5, "File
// trailer"). The value of this entry shall be an array of two byte strings. The first byte string shall be a
// permanent identifier based on the contents of the PDF file at the time it was originally created and
// shall not change when the PDF file is updated. The second byte string shall be a changing identifier
// based on the PDF file’s contents at the time it was last updated (see 7.5.6, "Incremental updates").
// When a PDF file is first written, both identifiers shall be set to the same value. If the first identifier in
// the reference matches the first identifier in the referenced file’s ID entry, and the last identifier in the
// reference matches the last identifier in the referenced file’s ID entry, it is very likely that the correct
// and unchanged PDF file has been found. If only the first identifier matches, a different version of the
// correct PDF file has been found.
// PDF writers should attempt to ensure the uniqueness of file identifiers. This may be achieved by
// computing them by means of a message digest algorithm such as MD5 (described in Internet RFC
// 1321), using the following information:
// • The current time;
// • A string representation of the PDF file’s location;
// • The size of the PDF file in bytes.
