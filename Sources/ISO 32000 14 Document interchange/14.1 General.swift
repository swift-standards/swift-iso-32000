// ISO 32000-2:2020, 14.1 General

import ISO_32000_Shared

extension ISO_32000.`14` {

}

//
//14 Document interchange
//14.1 General
//The features described in this clause do not affect the final appearance of a document. Rather, these
//features enable a document to include higher-level information useful to the interchange of documents
//among PDF processors:
//• Procedure sets (14.2, "Procedure sets") that define the implementation of PDF operators
//(deprecated in PDF 2.0)
//• Metadata (14.3, "Metadata") consisting of general information about a document or a component
//of a document, such as its title, author, and creation and modification dates
//• File identifiers (14.4, “File identifiers") for reliable reference from one PDF file to another
//• Page-piece dictionaries (14.5, "Page-piece dictionaries") allow a PDF processor to embed private
//data in a PDF document for its own use
//• Marked-content operators (14.6, "Marked content") for identifying portions of a content stream
//and associating them with additional properties or externally specified objects
//• Logical structure facilities (14.7, "Logical structure") for imposing a hierarchical organisation on
//the content of a document
//• Tagged PDF (14.8, "Tagged PDF"), a set of conventions for using marked-content and logical
//structure facilities to enable the extraction and reuse of a document’s content for other purposes
//• Various ways of enhancing the repurposing and accessibility of a document (14.9, "Repurposing
//and accessibility support"), including natural language identification of document content
//• The Web Capture extension (14.10, "Web capture"), which creates PDF files from Internet-based
//or locally resident HTML, PDF, GIF, JPEG, and ASCII text files
//• Facilities supporting prepress production workflows (14.11, "Prepress support"), such as the
//specification of page boundaries and the generation of printer’s marks, colour separations, output
//intents, traps, and low-resolution proxies for high-resolution images
//• Subclause 14.12,
//“Document parts" describes how additional page-level grouping information can
//be added to a PDF file. A primary use of document parts is to facilitate job ticket-based workflows
//that process large documents section by section.
//• Subclause 14.13, "Associated files" describes a means to associate content in other formats with
//selected objects of a PDF file and to identify the relationship between them.
