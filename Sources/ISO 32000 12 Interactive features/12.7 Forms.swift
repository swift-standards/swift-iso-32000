// ISO 32000-2:2020, 12.7 Forms

import ISO_32000_Shared

//12.7 Forms
//12.7.1 General
//A PDF document may contain both interactive and non-Interactive forms.
//An interactive form (PDF 1.2) — sometimes referred to as an AcroForm — is a collection of fields for
//gathering information interactively from the user. A PDF document may contain any number of fields
//appearing on any combination of pages, all of which make up a single, global interactive form spanning
//the entire document. Arbitrary subsets of these fields can be imported or exported from the document.
//NOTE Interactive forms are not to be confused with form XObjects (see 8.10, "Form XObjects"). Despite
//the similarity of names, the two are different, unrelated types of objects.
//A non-interactive form (PDF 1.7) is a static representation of form fields. Such forms may have
//originally contained interactive fields such as text fields and radio buttons but were converted into
//non-interactive PDF files, they may represent form fields and/or data converted from external sources,
//or they may have been designed to be printed out and filled in manually. See 12.7.9, "Non-interactive
//forms"
//.
//12.7.2 Interactive Forms
//Each field in a document’s form shall be defined by a field dictionary (see 12.7.4, "Field dictionaries").
//For purposes of definition and naming, the fields can be organised hierarchically and can inherit
//attributes from their ancestors in the field hierarchy. A field’s children in the hierarchy may also
//include widget annotations (see 12.5.6.19,
//"Widget annotations") that define its appearance on the
//page. A field that has children that are fields is called a non-terminal field. A field that does not have
//children that are fields is called a terminal field.
//A terminal field in an interactive form may have children that are widget annotations (see 12.5.6.19,
//"Widget annotations") that define its appearance on the page. As a convenience, when a field has only a
//single associated widget annotation, the contents of the field dictionary and the annotation dictionary
//(12.5.2, "Annotation dictionaries") may be merged into a single dictionary containing entries that
//528 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 529
//pertain to both a field and an annotation. (This presents no ambiguity, since the contents of the two
//kinds of dictionaries do not conflict.) If such an object defines an appearance stream, the appearance
//shall be consistent with the object’s current value as a field.
//NOTE Fields containing text whose contents are not known in advance will need to construct their
//appearance streams dynamically instead of defining them statically in an appearance dictionary;
//see 12.7.4.3, "Variable text"
//.
//12.7.3 Interactive form dictionary
//The contents and properties of a document’s interactive form shall be defined by an interactive form
//dictionary that shall be referenced from the AcroForm entry in the document catalog dictionary (see
//7.7.2, "Document catalog dictionary"). "Table 224 — Entries in the interactive form dictionary" shows
//the contents of this dictionary.
//Table 224 — Entries in the interactive form dictionary
//Key Type Value
//Fields array (Required) An array of references to the document’s root
//fields (those with no ancestors in the field hierarchy).
//NeedAppearances boolean (Optional; deprecated in PDF 2.0) A flag specifying whether
//to construct appearance streams and appearance
//dictionaries for all widget annotations in the document (see
//12.7.4.3, "Variable text"). Default value: false. A PDF writer
//shall include this key, with a value of true, if it has not
//provided appearance streams for all visible widget
//annotations present in the document.
//NOTE Appearance streams are required in PDF 2.0 and later.
//SigFlags integer (Optional; PDF 1.3) A set of flags specifying various
//document-level characteristics related to signature fields
//(see "Table 225 — Signature flags", and 12.7.5.5, "Signature
//fields"). Default value: 0.
//CO array (Required if any fields in the document have additional-
//actions dictionaries containing a C entry; PDF 1.3) An array of
//indirect references to field dictionaries with calculation
//actions, defining the calculation order in which their values
//will be recalculated when the value of any field changes (see
//12.6.3, "Trigger events").
//DR dictionary (Optional) A resource dictionary (see 7.8.3, "Resource
//dictionaries") containing default resources (such as fonts,
//patterns, or colour spaces) that shall be used by form field
//appearance streams. At a minimum, this dictionary shall
//contain a Font entry specifying the resource name and font
//dictionary of the default font for displaying text.
//DA string (Optional) A document-wide default value for the DA
//attribute of variable text fields (see 12.7.4.3, "Variable text").
//Q integer (Optional) A document-wide default value for the Q attribute
//of variable text fields (see 12.7.4.3, "Variable text").
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//530 © ISO 2020 – All rights reserved
//Key Type Value
//XFA stream or array (Optional; deprecated in PDF 2.0) A stream or array
//containing an XFA resource, whose format shall conform to
//the Data Package (XDP) Specification.
//See Annex K,
//“XFA forms”
//.
//The value of the interactive form dictionary’s SigFlags entry is an unsigned 32-bit integer containing
//flags specifying various document-level characteristics related to signature fields (see 12.7.5.5,
//"Signature fields"). Bit positions within the flag word shall be numbered from 1 (low-order) to 32
//(high-order). "Table 225 — Signature flags" shows the meanings of the flags; all undefined flag bits
//shall be reserved and shall be set to 0.
//Table 225 — Signature flags
//Bit position Name Meaning
//1 SignaturesExist If set, the document contains at least one signature field. This
//flag allows an interactive PDF processor to enable user
//interface items (such as menu items or push-buttons) related to
//signature processing without having to scan the entire
//document for the presence of signature fields.
//2 AppendOnly If set, the document contains signatures that may be invalidated
//if the PDF file is saved (written) in a way that alters its previous
//contents, as opposed to an incremental update. Merely updating
//the PDF file by appending new information to the end of the
//previous version is safe (see H.7, "Updating example").
//Interactive PDF processors may use this flag to inform a user
//requesting a full save that signatures will be invalidated and
//require explicit confirmation before continuing with the
//operation.
//12.7.4 Field dictionaries
//12.7.4.1 General
//Each field in a document’s interactive form shall be defined by a field dictionary, which shall be an
//indirect object. The field dictionaries may be organised hierarchically into one or more tree structures.
//Many field attributes are inheritable, meaning that if they are not explicitly specified for a given field,
//their values are taken from those of its parent in the field hierarchy. Such inheritable attributes shall be
//designated as such in the "Table 226 — Entries common to all field dictionaries" and "Table 227 —
//Field flags common to all field types". The designation (Required; inheritable) means that an attribute
//shall be defined for every field, whether explicitly in its own field dictionary or by inheritance from an
//ancestor in the hierarchy. The inheritable behavior of field dictionaries are similar to that of Pages (see
//7.7.3.4, "Inheritance of page attributes"). An interactive PDF processor shall not limit the range of
//inheritance for field dictionaries. "Table 226 — Entries common to all field dictionaries" shows those
//entries that are common to all field dictionaries, regardless of type. Entries that pertain only to a
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//particular type of field are described in the relevant subclauses referred to in "Table 226 — Entries
//common to all field dictionaries"
//.
//Table 226 — Entries common to all field dictionaries
//Key Type Value
//FT name (Required for terminal fields; inheritable) The type of field that this dictionary
//describes:
//Btn Button (see 12.7.5.2, "Button fields")
//Tx Text (see 12.7.5.3, "Text fields")
//Ch Choice (see 12.7.5.4, "Choice fields")
//Sig (PDF 1.3) Signature (see 12.7.5.5, "Signature fields")
//This entry may be present in a non-terminal field (one whose descendants are fields)
//to provide an inheritable FT value. However, a non-terminal field does not logically
//have a type of its own; it is merely a container for inheritable attributes that are
//intended for descendant terminal fields of any type.
//Parent dictionary (Required if this field is the child of another in the field hierarchy; absent otherwise) The
//field that is the immediate parent of this one (the field, if any, whose Kids array
//includes this field). A field can have at most one parent; that is, it can be included in
//the Kids array of at most one other field.
//Kids array (Sometimes required, as described below) An array of indirect references to the
//immediate children of this field.
//In a non-terminal field, the Kids array shall refer to field dictionaries that are
//immediate descendants of this field. In a terminal field, the Kids array ordinarily shall
//refer to one or more separate widget annotations that are associated with this field.
//However, if there is only one associated widget annotation, and its contents have been
//merged into the field dictionary, Kids shall be omitted.
//T text string (Required) The partial field name (see 12.7.4.2, "Field names").
//TU text string (Optional; PDF 1.3) An alternative field name that shall be used in place of the actual
//field name wherever the field shall be identified in the user interface (such as in error
//or status messages referring to the field). This text is also useful when extracting the
//document’s contents in support of accessibility to users with disabilities or for other
//purposes (see 14.9.3, "Alternate descriptions").
//TM text string (Optional; PDF 1.3) The mapping name that shall be used when exporting interactive
//form field data from the document.
//Ff integer (Optional; inheritable) A set of flags specifying various characteristics of the field (see
//"Table 227 — Field flags common to all field types"). Default value: 0.
//V (various) (Optional; inheritable) The field’s value, whose format varies depending on the field
//type. See the descriptions of individual field types for further information.
//DV (various) (Optional; inheritable) The default value to which the field reverts when a reset-form
//action is executed (see 12.7.6.3, "Reset-form action"). The format of this value is the
//same as that of V.
//AA dictionary (Optional; PDF 1.2) An additional-actions dictionary defining the field’s behaviour in
//response to various trigger events (see 12.6.3, "Trigger events"). This entry has
//exactly the same meaning as the AA entry in an annotation dictionary (see 12.5.2,
//"Annotation dictionaries").
//© ISO 2020 – All rights reserved 531
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//532 © ISO 2020 – All rights reserved
//The value of the field dictionary’s Ff entry is an unsigned 32-bit integer containing flags specifying
//various characteristics of the field. Bit positions within the flag word shall be numbered from 1 (low-
//order) to 32 (high-order). The flags shown in "Table 227 — Field flags common to all field types" are
//common to all types of fields. Flags that apply only to specific field types are discussed in the
//subclauses describing those types. All undefined flag bits shall be reserved and shall be set to 0.
//Table 227 — Field flags common to all field types
//Bit position Name Meaning
//1 ReadOnly If set, an interactive PDF processor shall not allow a user to change the value of
//the field. Additionally, any associated widget annotations should not interact with
//the user; that is, they should not respond to mouse clicks nor change their
//appearance in response to mouse motions.
//NOTE: This flag is useful for fields whose values are computed or imported from a
//database.
//2 Required If set, the field shall have a value at the time it is exported by a submit-form action
//(see 12.7.6.2, "Submit-form action").
//3 NoExport If set, the field shall not be exported by a submit-form action (see 12.7.6.2,
//"Submit-form action").
//12.7.4.2 Field names
//The T entry in the field dictionary (see "Table 226 — Entries common to all field dictionaries" holds a
//text string defining the field’s partial field name. The fully qualified field name is not explicitly defined
//but shall be constructed from the partial field names of the field and all of its ancestors. For a field with
//no parent, the partial and fully qualified names are the same. For a field that is the child of another
//field, the fully qualified name shall be formed by appending the child field’s partial name to the parent’s
//fully qualified name, separated by a PERIOD (2Eh) as shown:
//parent’s_full_name.child’s_partial_name
//EXAMPLE If a field with the partial field name PersonalData has a child whose partial name is Address, which in turn
//has a child with the partial name ZipCode, the fully qualified name of this last field is
//PersonalData.Address.ZipCode
//Because the PERIOD is used as a separator for fully qualified names, a partial name shall not contain a
//PERIOD character. Thus, all fields descended from a common ancestor share the ancestor’s fully
//qualified field name as a common prefix in their own fully qualified names.
//A field dictionary that does not have a partial field name (T entry) of its own shall not be considered a
//field but simply a Widget annotation. Such annotations are different representations of the same
//underlying field; they should differ only in properties that specify their visual appearance. In addition,
//actual field dictionaries with the same fully qualified field name shall have the same field type (FT),
//value (V), and default value (DV).
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//EXAMPLE A field with the fully qualified field name of PersonalData.Address.ZipCode can have multiple unnamed
//children representing different Widget annotations in multiple locations. Such children, although visually
//different, would represent the same field value to users.
//12.7.4.3 Variable text
//When the contents and properties of a field are known in advance, its visual appearance can be
//specified by an appearance stream defined in the PDF file (see 12.5.5, "Appearance streams" and
//12.5.6.19, "Widget annotations"). In some cases, however, the field may contain text whose value is not
//known until viewing time.
//NOTE Examples include text fields to be filled in with text typed by the user from the keyboard,
//scrollable list boxes whose contents are determined interactively at the time the document is
//displayed and fields containing current dates or values calculated by an ECMAScript.
//In such cases, the PDF document cannot provide a statically defined appearance stream for displaying
//the field. Instead, the PDF processor shall construct an appearance stream dynamically at rendering
//time. The dictionary entries shown in "Table 228 — Additional entries common to all fields containing
//variable text" provide general information about the field’s appearance that can be combined with the
//specific text it contains to construct an appearance stream.
//Table 228 — Additional entries common to all fields containing variable text
//Key Type Value
//DA string (Required; inheritable) The default appearance string containing a sequence
//of valid page-content graphics or text state operators that define such
//properties as the field’s text size and colour.
//Q integer (Optional; inheritable) A code specifying the form of quadding
//(justification) that shall be used in displaying the text:
//0 Left-justified
//1 Centred
//2 Right-justified
//Default value: 0 (left-justified).
//DS text string (Optional; PDF 1.5) A default style string, as described in Adobe XML
//Architecture, XML Forms Architecture (XFA) Specification, version 3.3.
//RV text string or
//text stream
//(Optional; PDF 1.5) A rich text string, as described in Adobe XML
//Architecture, XML Forms Architecture (XFA) Specification, version 3.3.
//The new appearance stream becomes the normal appearance (N) in the appearance dictionary
//associated with the field’s widget annotation (see "Table 170 — Entries in an appearance dictionary").
//In PDF 1.5, form fields that have the RichText flag set (see "Table 231 — Field flags specific to text
//fields") specify formatting information as described in Adobe XML Architecture, XML Forms Architecture
//(XFA) Specification, version 3.3. For these fields, the following conventions are not used, and the entire
//annotation appearance shall be regenerated each time the value is changed.
//For non-rich text fields, the appearance stream — which, like all appearance streams, is a form XObject
//— has the contents of its form dictionary initialised as follows:
//© ISO 2020 – All rights reserved 533
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//• The resource dictionary (Resources) shall be created using resources from the interactive form
//dictionary’s DR entry (see "Table 224 — Entries in the interactive form dictionary").
//• The lower-left corner of the bounding box (BBox) is set to coordinates (0, 0) in the form
//coordinate system. The box’s top and right coordinates are taken from the dimensions of the
//annotation rectangle (the Rect entry in the widget annotation dictionary).
//• All other entries in the appearance stream’s form dictionary are set to their default values (see
//8.10, "Form XObjects").
//EXAMPLE The appearance stream includes the following section of marked-content, which represents the portion of
//the stream that draws the text:
///Tx BMC %Begin marked-content with tag Tx
//q %Save graphics state
//… Any required graphics state changes, such as clipping …
//BT %Begin text object
//… Default appearance string ( DA ) …
//… Text-positioning and text-showing operators to show the variable text …
//ET %End text object
//Q %Restore graphics state
//EMC %End marked-content
//The BMC (begin marked-content) and EMC (end marked-content) operators are discussed in 14.6, "Marked
//content"
//, q (save graphics state) and Q (restore graphics state) are discussed in 8.4.4, "Graphics state
//operators"
//, BT (begin text object) and ET (end text object) are discussed in 9.4, "Text objects". See the
//Example in 12.7.5.3, "Text fields" for an example of their use.
//The default appearance string (DA) contains any graphics state or text state operators needed to
//establish the graphics state parameters, such as text size and colour, for displaying the field’s variable
//text. Only operators that are allowed within text objects shall occur in this string (see "Figure 9 —
//Graphics objects"). At a minimum, the string shall include a Tf (text font) operator along with its two
//operands, font and size. The specified font value shall match a resource name in the Font entry of the
//default resource dictionary (referenced from the DR entry of the interactive form dictionary; see
//"Table 224 — Entries in the interactive form dictionary"). A zero value for size means that the font
//shall be auto-sized: its size shall be computed as an implementation dependent function.
//The default appearance string shall contain at most one Tm (text matrix) operator. If this operator is
//present, the interactive PDF processor shall replace the horizontal and vertical translation components
//with positioning values it determines to be appropriate, based on the field value, the quadding (Q)
//attribute, and any layout rules it employs. If the default appearance string contains no Tm operator,
//the viewer shall insert one in the appearance stream (with appropriate horizontal and vertical
//translation components) after the default appearance string and before the text-positioning and text-
//showing operators for the variable text.
//To update an existing appearance stream to reflect a new field value, the interactive PDF processor
//shall first copy any needed resources from the document’s DR dictionary (see "Table 224 — Entries in
//the interactive form dictionary") into the stream’s Resources dictionary. (If the DR and Resources
//dictionaries contain resources with the same name, the one already in the Resources dictionary shall
//be left intact, not replaced with the corresponding value from the DR dictionary.) The interactive PDF
//processor shall then replace the existing contents of the appearance stream from /Tx BMC to the
//matching EMC with the corresponding new contents as shown in Example 1 in 12.7.5.2.3, "Check
//boxes"
//, 12.7.5, "Field types" (If the existing appearance stream contains no marked-content with tag
//Tx, the new contents shall be appended to the end of the original stream.)
//534 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 535
//12.7.5 Field types
//12.7.5.1 General
//Interactive forms support the following field types:
//• Button fields represent interactive controls on the screen that the user can manipulate with the
//mouse. They include push-buttons, check boxes, and radio buttons.
//• Text fields are boxes or spaces in which the user can enter text from the keyboard.
//• Choice fields contain several text items, at most one of which may be selected as the field value.
//They include scrollable list boxes and combo boxes.
//• Signature fields represent digital signatures and optional data for authenticating the name of the
//signer and the document’s contents.
//The following subclauses describe each of these field types in detail.
//12.7.5.2 Button fields
//12.7.5.2.1 General
//A button field (field type Btn) represents an interactive control on the screen that the user can
//manipulate with the mouse. There are three types of button fields:
//• A push-button is a purely interactive control that responds immediately to user input without
//retaining a permanent value (see 12.7.5.2.2, "Push-buttons").
//• A check box toggles between two states, on and off (see 12.7.5.2.3, "Check boxes").
//• Radio button fields contain a set of related buttons that can each be on or off. Typically, at most
//one radio button in a set may be on at any given time, and selecting any one of the buttons
//automatically deselects all the others. (There are exceptions to this rule, as noted in 12.7.5.2.4,
//"Radio buttons")
//For button fields, bits 15, 16, 17, and 26 shall indicate the intended behaviour of the button field. An
//interactive PDF processor shall follow the intended behaviour, as defined in "Table 229 — Field flags
//specific to button fields" and clauses 12.7.5.2.2, "Push-buttons", and 12.7.5.2.4, "Radio buttons"
//.
//Table 229 — Field flags specific to button fields
//Bit position Name Meaning
//15 NoToggleToOff (Radio buttons only) If set, exactly one radio button shall be
//selected at all times; selecting the currently selected button has
//no effect. If clear, clicking the selected button deselects it,
//leaving no button selected.
//16 Radio If set, the field is a set of radio buttons; if clear, the field is a
//check box. This flag may be set only if the Pushbutton flag is
//clear.
//17 Pushbutton If set, the field is a push-button that does not retain a
//permanent value.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//536 © ISO 2020 – All rights reserved
//Bit position Name Meaning
//26 RadiosInUnison (PDF 1.5) If set, a group of radio buttons within a radio button
//field that use the same value for the on state will turn on and off
//in unison; that is if one is checked, they are all checked. If clear,
//the buttons are mutually exclusive (the same behaviour as
//HTML radio buttons).
//12.7.5.2.2 Push-buttons
//A push-button field shall have a field type of Btn and the Pushbutton flag (see "Table 229 — Field flags
//specific to button fields") set to one. Because this type of retains no permanent value, it shall not use
//the V and DV entries in the field dictionary (see "Table 226 — Entries common to all field
//dictionaries").
//12.7.5.2.3 Check boxes
//A check box field represents one or more check boxes that toggle between two states, on and off, when
//manipulated by the user with the mouse or keyboard. Its field type shall be Btn and its Pushbutton and
//Radio flags (see "Table 229 — Field flags specific to button fields") shall both be clear. Each state can
//have a separate appearance, which shall be defined by an appearance stream in the appearance
//dictionary of the field’s widget annotation (see 12.5.5, "Appearance streams"). The appearance for the
//off state is optional but, if present, shall be stored in the appearance dictionary under the name Off.
//The V entry in the field dictionary (see "Table 226 — Entries common to all field dictionaries") holds a
//name object representing the check box’s appearance state, which shall be used to select the
//appropriate appearance from the appearance dictionary. The value of the V key shall also be the value
//of the AS key. If they are not equal, then the value of the AS key shall be used instead of the V key to
//determine which appearance to use.
//EXAMPLE 1 This example shows a typical check box definition.
//1 0 obj
//<</Type /Annot
///Subtype /Widget
///Rect [100 100 120 120]
///FT /Btn
///T (Urgent)
///V /Yes
///AS /Yes
///AP <</N <</Yes 2 0 R /Off 3 0 R>>
//>>
//endobj
//2 0 obj
//<</Type /XObject
///Subtype /Form
///BBox [0 0 20 20]
///Resources 20 0 R
///Length 104
//>>
//stream
//q
//0 0 1 rg
//BT
///ZaDb 12 Tf
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 537
//0 0 Td
//(4) Tj
//ET
//Q
//endstream
//endobj
//3 0 obj
//<</Type /XObject
///Subtype /Form
///BBox [0 0 20 20]
///Resources 20 0 R
///Length 104
//>>
//stream
//q
//0 0 1 rg
//BT
///ZaDb 12 Tf
//0 0 Td
//(8) Tj
//ET
//Q
//endstream
//endobj
//Beginning with PDF 1.4, the field dictionary for check boxes and radio buttons may contain an optional
//Opt entry (see "Table 230 — Additional entry specific to check box and radio button fields"). If present,
//the Opt entry shall be an array of text strings representing the export value of each annotation in the
//field. It may be used for the following purposes:
//• To represent the export values of check box and radio button fields in non-Latin writing systems
//(because name objects in the appearance dictionary cannot represent non-Latin text).
//• To allow radio buttons or check boxes to be checked independently, even if they have the same
//export value.
//EXAMPLE 2 A group of check boxes may be duplicated on more than one page such that the desired behaviour is that
//when a user checks a box, the corresponding boxes on each of the other pages are also checked. In this case,
//each of the corresponding check boxes is a widget in the Kids array of a check box field.
//For radio buttons, the same behaviour shall occur only if the RadiosInUnison flag is set. If it is not set, at
//most one radio button in a field shall be set at a time.
//Table 230 — Additional entry specific to check box and radio button fields
//Key Type Value
//Opt array of text
//strings
//(Optional; inheritable; PDF 1.4) An array containing one entry for each
//widget annotation in the Kids array of the radio button or check box field.
//Each entry shall be a text string representing the on state of the
//corresponding widget annotation.
//When this entry is present, the names used to represent the on state in the
//AP dictionary of each annotation may use numerical position (starting with
//0) of the annotation in the Kids array, encoded as a name object (for
//example: /0, /1). This allows distinguishing between the annotations even if
//two or more of them have the same value in the Opt array.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.7.5.2.4 Radio buttons
//A radio button field is a set of related buttons. Like check boxes, individual radio buttons have two
//states, on and off. A single radio button may not be turned off directly but only as a result of another
//button being turned on. Typically, a set of radio buttons (annotations that are children of a single radio
//button field) have at most one button in the on state at any given time; selecting any of the buttons
//automatically deselects all the others.
//NOTE An exception occurs when multiple radio buttons in a field have the same on state and the
//RadiosInUnison flag is set. In that case, turning on one of the buttons turns on all of them.
//The field type is Btn, the Pushbutton flag (see "Table 229 — Field flags specific to button fields") is
//clear, and the Radio flag is set. This type of button field has an additional flag, NoToggleToOff, which
//specifies, if set, that exactly one of the radio buttons shall be selected at all times. In this case, clicking
//the currently selected button has no effect; if the NoToggleToOff flag is clear, clicking the selected
//button deselects it, leaving no button selected.
//The Kids entry in the radio button field’s field dictionary (see "Table 226 — Entries common to all field
//dictionaries") holds an array of widget annotations representing the individual buttons in the set. The
//parent field’s V entry holds a name object corresponding to the appearance state of whichever child
//field is currently in the on state; the default value for this entry is Off. The value of the V key shall also
//be the value of the AS key. If they are not equal, then the value of the AS key shall be used instead of the
//V key to determine which appearance to use.
//EXAMPLE This example shows the object definitions for a set of radio buttons.
//10 0 obj %Radio button field
//<</Type /Annot
///Subtype /Widget
///Rect [100 100 120 120]
///FT /Btn
///Ff … %…Radio flag = 16, Pushbutton = 17 …
///T (Credit card)
///V /cardbrand1
///Kids [11 0 R 12 0 R]
//>>
//endobj
//11 0 obj %First radio button
//<</Parent 10 0 R
///AS /cardbrand1
///AP <</N <</cardbrand1 8 0 R
///Off 9 0 R
//>>
//>>
//>>
//endobj
//12 0 obj %Second radio button
//<</Type /Annot
///Subtype /Widget
///Rect [200 200 220 220]
///Parent 10 0 R
///AS /Off
///AP <</N <</cardbrand2 8 0 R
///Off 9 0 R
//>>
//>>
//>>
//538 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//endobj
//8 0 obj %Appearance stream for "on" state
//<</Type /XObject
///Subtype /Form
///BBox [0 0 20 20]
///Resources 20 0 R
///Length 104
//stream
//q
//>>
//0 0 1 rg
//BT
///ZaDb 12 Tf
//0 0 Td
//(8) Tj
//ET
//Q
//endstream
//endobj
//9 0 obj %Appearance stream for "off" state
//<</Type /XObject
///Subtype /Form
///BBox [0 0 20 20]
///Resources 20 0 R
///Length 104
//stream
//q
//>>
//0 0 1 rg
//BT
///ZaDb 12 Tf
//0 0 Td
//(4) Tj
//ET
//Q
//endstream
//endobj
//Like a check box field, a radio button field may use the optional Opt entry in the field dictionary (PDF
//1.4) to define export values for its constituent radio buttons, using Unicode encoding for non-Latin
//characters (see "Table 230 — Additional entry specific to check box and radio button fields").
//12.7.5.3 Text fields
//A text field (field type Tx) is a box or space for text fill-in data typically entered from a keyboard. The
//text may be restricted to a single line or may be permitted to span multiple lines, depending on the
//setting of the Multiline flag in the field dictionary’s Ff entry. "Table 231 — Field flags specific to text
//fields" shows the flags pertaining to this type of field. A text field shall have a field type of Tx. A
//conforming PDF file, and an interactive PDF processor shall obey the usage guidelines in "Table 231 —
//Field flags specific to text fields"
//.
//Table 231 — Field flags specific to text fields
//Bit position Name Meaning
//13 Multiline If set, the field may contain multiple lines of text; if clear, the field’s text
//shall be restricted to a single line.
//© ISO 2020 – All rights reserved 539
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//540 © ISO 2020 – All rights reserved
//Bit position Name Meaning
//14 Password If set, the field is intended for entering a secure password that should
//not be echoed visibly to the screen. Characters typed from the keyboard
//shall instead be echoed in some unreadable form, such as asterisks or
//bullet characters.
//NOTE To protect password confidentiality, it is imperative that PDF
//processors never store the value of the text field in the PDF file if this
//flag is set.
//21 FileSelect (PDF 1.4) If set, the text entered in the field represents the pathname of
//a file whose contents shall be submitted as the value of the field.
//23 DoNotSpellCheck (PDF 1.4) If set, text entered in the field shall not be spell-checked.
//24 DoNotScroll (PDF 1.4) If set, the field shall not scroll (horizontally for single-line
//fields, vertically for multiple-line fields) to accommodate more text than
//fits within its annotation rectangle. Once the field is full, no further text
//shall be accepted for interactive form filling; for non-interactive form
//filling, the filler should take care not to add more character than will
//visibly fit in the defined area.
//25 Comb (PDF 1.5) May be set only if the MaxLen entry is present in the text field
//dictionary (see "Table 232 — Additional entry specific to a text field")
//and if the Multiline, Password, and FileSelect flags are clear. If set, the
//field shall be automatically divided into as many equally spaced
//positions, or combs, as the value of MaxLen, and the text is laid out into
//those combs.
//26 RichText (PDF 1.5) If set, the value of this field shall be a rich text string (see
//Adobe XML Architecture, XML Forms Architecture (XFA) Specification,
//version 3.3). If the field has a value, the RV entry of the field dictionary
//("Table 228 — Additional entries common to all fields containing
//variable text") shall specify the rich text string.
//The field’s text shall be held in a text string (or, beginning with PDF 1.5, a stream) in the V (value) entry
//of the field dictionary. The contents of this text string or stream shall be used to construct an
//appearance stream for displaying the field, as described under 12.7.4.3, "Variable text" The text shall
//be presented in a single style (font, size, colour, and so forth), as specified by the DA (default
//appearance) string.
//If the FileSelect flag (PDF 1.4) is set, the field shall function as a file-select control. In this case, the
//field’s text represents the pathname of a file whose contents shall be submitted as the field’s value:
//• For fields submitted in HTML Form format, the submission shall use the MIME content type
//multipart / form-data, as described in Internet RFC 2045.
//• For Forms Data Format (FDF) submission, the value of the V entry in the FDF field dictionary (see
//12.7.8.3.2, "FDF fields") shall be a file specification (7.11, "File specifications") identifying the
//selected file.
//• XML is not supported for file-select controls; therefore, no value shall be submitted in this case.
//Besides the usual entries common to all fields (see "Table 226 — Entries common to all field
//dictionaries") and to fields containing variable text (see "Table 228 — Additional entries common
//to all fields containing variable text"), the field dictionary for a text field may contain the
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//additional entry shown in "Table 232 — Additional entry specific to a text field"
//.
//Table 232 — Additional entry specific to a text field
//Key Type Value
//MaxLen integer (Optional; inheritable) The maximum length of the field’s text, in characters.
//EXAMPLE The following example shows the object definitions for a typical text field.
//6 0 obj
//<</Type /Annot
///Subtype /Widget
///Rect [100 100 400 220]
///FT /Tx
///Ff … %Set Multiline flag
///T (Silly prose)
///DA (0 0 1 rg /Ti 12 Tf)
///V (The quick brown fox ate the lazy mouse)
///AP <</N 5 0 R>>
//>>
//endobj
//5 0 obj
//<</Type /XObject
///Subtype /Form
///BBox [0 0 300 120]
///Resources 21 0 R
///Length 172
//>>
//stream
///Tx BMC
//q
//BT
//0 0 1 rg
///Ti 12 Tf
//1 0 0 1 100 100 Tm
//0 0 Td
//(The quick brown fox) Tj
//0 -13 Td
//(ate the lazy mouse.) Tj
//ET
//Q
//EMC
//endstream
//endobj
//12.7.5.4 Choice fields
//A choice field shall have a field type of Ch that contains several text items, one or more of which shall be
//selected as the field value. The items may be presented to the user in one of the following two forms:
//• A scrollable list box
//• A combo box consisting of a drop-down list. The combo box may be accompanied by an editable
//text box in which the user can type a value other than the predefined choices, as directed by the
//value of the Edit bit in the Ff entry.
//The various types of choice fields are distinguished by flags in the Ff entry, as shown in "Table 233 —
//Field flags specific to choice fields"
//.
//"Table 234 — Additional entries specific to a choice field" shows
//the field dictionary entries specific to choice fields.
//© ISO 2020 – All rights reserved 541
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//542 © ISO 2020 – All rights reserved
//Table 233 — Field flags specific to choice fields
//Bit position Name Meaning
//18 Combo If set, the field is a combo box; if clear, the field is a list box.
//19 Edit If set, the combo box shall include an editable text box as
//well as a drop-down list; if clear, it shall include only a drop-
//down list. This flag shall be used only if the Combo flag is
//set.
//20 Sort If set, the field’s option items shall be sorted alphabetically.
//This flag is intended for use by PDF writers, not by PDF
//readers. PDF readers shall display the options in the order
//in which they occur in the Opt array (see "Table 234 —
//Additional entries specific to a choice field").
//22 MultiSelect (PDF 1.4) If set, more than one of the field’s option items
//may be selected simultaneously; if clear, at most one item
//shall be selected.
//23 DoNotSpellCheck (PDF 1.4) If set, text entered in the field shall not be spell-
//checked. This flag shall not be used unless the Combo and
//Edit flags are both set.
//27 CommitOnSelChange (PDF 1.5) If set, the new value shall be committed as soon as
//a selection is made (commonly with the pointing device). In
//this case, supplying a value for a field involves three actions:
//selecting the field for fill-in, selecting a choice for the fill-in
//value, and leaving that field, which finalizes or "commits"
//the data choice and triggers any actions associated with the
//entry or changing of this data. If this flag is on, then
//processing does not wait for leaving the field action to
//occur, but immediately proceeds to the third step.
//This option enables applications to perform an action once a
//selection is made, without requiring the user to exit the
//field. If clear, the new value is not committed until the user
//exits the field.
//Table 234 — Additional entries specific to a choice field
//Key Type Value
//Opt array (Optional) An array of options that shall be presented to the user. Each
//element of the array is either a text string representing one of the available
//options or an array consisting of two text strings: the option’s export value
//and the text that shall be displayed as the name of the option.
//If this entry is not present, no choices should be presented to the user.
//TI integer (Optional) For scrollable list boxes, the top index (the index in the Opt array
//of the first option visible in the list). Default value: 0.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//I array (Sometimes required, otherwise optional; PDF 1.4) For choice fields that allow
//multiple selection (MultiSelect flag set), an array of integers, sorted in
//ascending order, representing the zero-based indices in the Opt array of the
//currently selected option items. This entry shall be used when two or more
//elements in the Opt array have different names but the same export value or
//when the value of the choice field is an array. If the items identified by this
//entry differ from those in the V entry of the field dictionary (see discussion
//following this Table), the V entry shall be used.
//The Opt array specifies the list of options in the choice field, each of which shall be represented by a
//text string that shall be displayed on the screen. Each element of the Opt array contains either this text
//string by itself or a two-element array, whose second element is the text string and whose first element
//is a text string representing the export value that shall be used when exporting interactive form field
//data from the document.
//The field dictionary’s V (value) entry (see "Table 226 — Entries common to all field dictionaries")
//identifies the item or items currently selected in the choice field. If the field does not allow multiple
//selection — that is, if the MultiSelect flag (PDF 1.4) is not set — or if multiple selection is supported but
//only one item is currently selected, V is a text string representing the selected item, as given in the field
//dictionary’s Opt array. If multiple items are selected, V is an array of such strings. (For items
//represented in the Opt array by a two-element array, the name string is the second of the two array
//elements.) The default value of V is null, indicating that no item is currently selected.
//EXAMPLE The following example shows a typical choice field definition.
//<</FT /Ch
///Ff …
///T (Body Color)
///V (Blue)
///Opt [(Red)
//(My favourite color)
//(Blue)
//]
//>>
//12.7.5.5 Signature fields
//A signature field (PDF 1.3) is a form field that contains a digital signature (see 12.8, "Digital
//signatures"). The field dictionary representing a signature field may contain the additional entries
//listed in "Table 235 — Additional entries specific to a signature field", as well as the standard entries
//described in "Table 226 — Entries common to all field dictionaries". The field type (FT) shall be Sig,
//and the field value (V), if present, shall be a signature dictionary containing the signature and
//specifying various attributes of the signature field (see "Table 255 — Entries in a signature
//dictionary").
//NOTE 1 This signature form field serves two primary purposes. The first is to define the form field that
//provides the visual signing properties for display, and it can also hold information needed later
//when the actual signing takes place, such as the signature technology to use. This carries
//information from the author of the document to the software that later does the signing.
//© ISO 2020 – All rights reserved 543
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//544 © ISO 2020 – All rights reserved
//NOTE 2 Filling in (signing) the signature field entails updating at least the V entry and usually also the AP
//entry of the associated widget annotation. Exporting a signature field typically exports the T, V,
//and AP entries.
//Like any other field, a signature field may be described by a widget annotation dictionary containing
//entries pertaining to an annotation as well as a field (12.5.6.19, "Widget annotations"). The annotation
//rectangle (Rect) in such a dictionary shall give the position of the field on its page. Signature fields that
//are not intended to be visible shall have an annotation rectangle that has zero height and width. PDF
//processors shall treat such signatures as not visible. PDF processors shall also treat signatures as not
//visible if either the Hidden bit or the NoView bit of the F entry is true. The F entry is described in
//"Table 166 — Entries common to all annotation dictionaries", and annotation flags are described in
//"Table 167 — Annotation flags"
//.
//The location of a signature within a document can have a bearing on its legal meaning. For this reason,
//signature fields shall never refer to more than one annotation.
//NOTE 3 If more than one location is associated with a signature, the meaning can become ambiguous.
//For signature fields that are visible, the appearance dictionary (AP) for the widget annotation of these
//fields should be created at the time of signature creation. This dictionary defines the field’s visual
//appearance on the page (see 12.5.5, "Appearance streams"), but the information included in the
//appearance dictionary shall not be used by a signature verification handler at the time of signature
//verification. It is there strictly for the purpose of providing a way for a human verifier to perform their
//own verification of the visual representation. A PDF processor shall not incorporate the validation
//status of a signature (e.g. a checkmark for passed or an X for failed) into the appearance of the
//signature field.
//Table 235 — Additional entries specific to a signature field
//Key Type Value
//Lock dictionary (Optional; shall be an indirect reference; PDF 1.5) A signature field lock
//dictionary that specifies a set of form fields that shall be locked when this
//signature field is signed. "Table 236 — Entries in a signature field lock
//dictionary" lists the entries in this dictionary.
//SV dictionary (Optional; shall be an indirect reference; PDF 1.5) A seed value dictionary
//(see "Table 237 — Entries in a signature field seed value dictionary")
//containing information that constrains the properties of a signature that
//is applied to this field.
//The signature field lock dictionary (described in "Table 236 — Entries in a signature field lock
//dictionary") contains the names of form fields whose values shall no longer be changed after this
//signature has been signed.
//Table 236 — Entries in a signature field lock dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes; if present,
//shall be SigFieldLock for a signature field lock dictionary.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 545
//Key Type Value
//Action name (Required) A name which, in conjunction with Fields, indicates the set of
//fields that should be locked. The value shall be one of the following:
//All All fields in the document
//Include All fields specified in Fields
//Exclude All fields except those specified in Fields
//Fields array (Required if the value of Action is Include or Exclude) An array of text
//strings containing field names.
//P number (Optional; PDF 2.0) The access permissions granted for this document.
//Valid values shall be:
//1 No changes to the document are permitted; any change to the
//document shall invalidate the signature.
//2 Permitted changes shall be filling in forms, instantiating page
//templates, and signing; other changes shall invalidate the signature.
//3 Permitted changes are the same as for 2, as well as annotation
//creation, deletion, and modification; other changes shall invalidate
//the signature.
//There is no default value; absence of this key shall result in no effect on
//signature validation rules.
//If MDP permission is already in effect from an earlier incremental save
//section or the original part of the document, the number shall specify
//permissions less than or equal to the permissions already in effect based
//on signatures earlier in the document. That is, permissions can be denied
//but not added. If the number specifies greater permissions than an MDP
//value already in effect, the new number is ignored.
//If the document does not have an author signature, the initial permissions
//in effect are those based on the number 3.
//The new permission applies to any incremental changes to the document
//following the signature of which this key is part.
//The value of the SV entry in the field dictionary is a seed value dictionary whose entries (see "Table
//237 — Entries in a signature field seed value dictionary") provide constraining information that shall
//be used at the time the signature is applied. The Ff entry in this signature field seed value dictionary
//specifies whether the other entries in the dictionary shall be honoured or whether they are merely
//recommendations.
//Table 237 — Entries in a signature field seed value dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes; if present,
//shall be SV for a seed value dictionary.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//546 © ISO 2020 – All rights reserved
//Key Type Value
//Ff integer (Optional) A set of bit flags specifying the interpretation of specific entries
//in this dictionary. A value of 1 for the flag indicates that the associated entry
//is a required constraint. A value of 0 indicates that the associated entry is
//an optional constraint. Bit positions are 1 (Filter); 2 (SubFilter); 3 (V); 4
//(Reasons); 5 (LegalAttestation); 6 (AddRevInfo); and 7 (DigestMethod).
//For PDF 2.0 the following bit flags are added: 8 (Lockdocument); and 9
//(AppearanceFilter). Default value: 0.
//Filter name (Optional) The signature handler that shall be used to sign the signature
//field. Beginning with PDF 1.7, if Filter is specified and the Ff entry indicates
//this entry is a required constraint, then the signature handler specified by
//this entry shall be used when signing; otherwise, signing shall not take
//place. If Ff indicates that this is an optional constraint, this handler may be
//used if it is available. If it is not available, a different handler may be used
//instead.
//SubFilter array (Optional) An array of names indicating encodings to use when signing. The
//first name in the array that matches an encoding supported by the
//signature handler shall be the encoding that is actually used for signing. If
//SubFilter is specified and the Ff entry indicates that this entry is a required
//constraint, then the first matching encodings shall be used when signing;
//otherwise, signing shall not take place. If Ff indicates that this is an optional
//constraint, then the first matching encoding shall be used if it is available. If
//none is available, a different encoding may be used.
//DigestMethod array (Optional; PDF 1.7) An array of names indicating acceptable digest
//algorithms to use while signing. The value shall be one of SHA1 (deprecated
//with PDF 2.0), SHA256, SHA384, SHA512 and RIPEMD160. The default value
//is implementation-specific.
//This property is only applicable if the digital credential signing contains
//RSA public/private keys. If it contains DSA public/ private keys, the digest
//algorithm is always SHA-1 and this attribute shall be ignored.
//V integer (Optional) The minimum required capability of the signature field seed
//value dictionary parser. A value of 1 specifies that the parser shall be able
//to recognise all seed value dictionary entries in a PDF 1.5 file. A value of 2
//specifies that it shall be able to recognise all seed value dictionary entries
//specified. A value of 3 specifies that it shall be able to recognise all seed
//value dictionary entries specified in PDF 2.0 and earlier.
//The Ff entry indicates whether this shall be treated as a required
//constraint.
//Cert dictionary (Optional) A certificate seed value dictionary (see "Table 238 — Entries in a
//certificate seed value dictionary") containing information about the
//characteristics of the certificate that shall be used when signing.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 547
//Key Type Value
//Reasons array (Optional) An array of text strings that specifying possible reasons for
//signing a document. If specified, the reasons supplied in this entry replace
//those used by interactive PDF processors.
//If the Reasons array is provided and the Ff entry indicates that Reasons is
//a required constraint, one of the reasons in the array shall be used for the
//signature dictionary; otherwise, signing shall not take place. If the Ff entry
//indicates Reasons is an optional constraint, one of the reasons in the array
//may be chosen or a custom reason can be provided.
//If the Reasons array is omitted or contains a single entry with the value
//PERIOD (2Eh) and the Ff entry indicates that Reasons is a required
//constraint, the Reason entry shall be omitted from the signature dictionary
//(see "Table 255 — Entries in a signature dictionary").
//MDP dictionary (Optional; PDF 1.6) A dictionary containing a single entry whose key is P
//and whose value is an integer between 0 and 3. A value of 0 defines the
//signature as an approval signature (see 12.8, "Digital signatures"). The
//values 1 through 3 shall be used for certification signatures and correspond
//to the value of P in a DocMDP transform parameters dictionary (see "Table
//257 — Entries in the DocMDP transform parameters dictionary").
//If this MDP key is not present or the MDP dictionary does not contain a P
//entry, no rules shall be defined regarding the type of signature or its
//permissions.
//TimeStamp dictionary (Optional; PDF 1.6) A timestamp dictionary containing two entries:
//URL An ASCII string specifying the URL of a timestamping server,
//providing a timestamp that is compliant with Internet RFC 3161 as
//updated by Internet RFC 5816.
//Ff An integer whose value is 1 (the signature shall have a timestamp)
//or 0 (the signature need not have a timestamp). Default value: 0.
//NOTE 1 Please see 12.8.3.3, "CMS (PKCS #7) signatures" for more details about
//hashing.
//LegalAttestation array (Optional; PDF 1.6) An array of text strings specifying possible legal
//attestations (see 12.8.7, "Legal content attestations"). The value of the
//corresponding flag in the Ff entry indicates whether this is a required
//constraint.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//AddRevInfo boolean (Optional; PDF 1.7) A flag indicating whether revocation checking shall be
//carried out. If AddRevInfo is true, the PDF processor shall perform the
//following additional tasks when signing the signature field:
//• Perform revocation checking of the certificate (and the corresponding issuing
//certificates) used to sign.
//• Include the revocation information within the signature value.
//Three SubFilter values have been defined. For those values the
//AddRevInfo value shall be true only if SubFilter is adbe.pkcs7.detached or
//adbe.pkcs7.sha1. If SubFilter is adbe.x509.rsa_sha1, this entry shall be
//omitted or set to false. Additional SubFilter values may be defined that also
//use AddRevInfo values.
//If AddRevInfo is true and the Ff entry indicates this is a required
//constraint, then the preceding tasks shall be performed. If they cannot be
//performed, then signing shall fail.
//Default value: false
//NOTE 2 Revocation information is carried in the signature data as specified by
//PKCS #7. See 12.8.3.3, "CMS (PKCS #7) signatures"
//.
//NOTE 3 adbe.pkcs7.detached and adbe.pkcs7.sha1 are deprecated in PDF 2.0.
//LockDocument name (Optional; PDF 2.0) A name value supplying the author’s intent for whether
//the signing dialogue should allow the user to lock the document at the time
//of signing. The value shall be one of true, false, and auto, as follows:
//true the document should be locked at the time of signing. If the Ff entry
//indicates that LockDocument is not a required constraint, the user
//may choose to override this at the time of signing; otherwise, the
//document is locked after signing.
//false the document should not be locked after signing. Again, the
//required flag, Ff, determines whether this is a required constraint.
//auto the consuming application decided whether to present the lock
//user interface for the document and whether to honour the
//required flag, Ff, based on the properties of the document.
//Default value: auto
//AppearanceFilter text string (Optional; PDF 2.0) A text string naming the appearance that shall be used
//when signing the signature field. interactive PDF processors may choose to
//maintain a list of named signature appearances. This text string provides
//authors with a means of specifying which appearance should be used to
//sign the signature field.
//If the required bit AppearanceFilter in Ff is set, the appearance shall be
//available to sign the document and is used.
//A seed value dictionary may also include seed values for private entries belonging to multiple handlers.
//A given handler shall use only those private entries that are pertinent to itself and ignore any other
//private entries.
//For optional keys that are not present, no constraint shall be placed upon the signature handler for that
//property when signing.
//548 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 549
//Table 238 — Entries in a certificate seed value dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary
//describes; if present, shall be SVCert for a certificate seed
//value dictionary.
//Ff integer (Optional) A set of bit flags specifying the interpretation of
//specific entries in this dictionary. A value of 1 for the flag
//means that a signer shall be required to use only the
//specified values for the entry. A value of 0 means that
//other values are permissible. Bit positions are 1 (Subject);
//2 (Issuer); 3 (OID); 4 (SubjectDN); 5 (Reserved); 6
//(KeyUsage); 7 (URL). Default value: 0.
//Subject array (Optional) An array of byte strings containing DER-
//encoded X.509v3 certificates that are acceptable for
//signing. X.509v3 certificates are described in Internet RFC
//5280. The value of the corresponding flag in the Ff entry
//indicates whether this is a required constraint.
//SignaturePolicyOID ASCII string (Optional: PDF 2.0) The string representation of the OID of
//the signature policy to use when signing.
//SignaturePolicyHashValue string (Optional: PDF 2.0) The computed hash value of the
//signature policy, computed the same way as hashValue of
//sigPolicyHash in clause 5.2.9 of CAdES (ETSI EN 319 122-
//1), according to the hash algorithm specified by
//SignaturePolicyHashAlgorithm.
//SignaturePolicyHashAlgorithm name (Optional: PDF 2.0) The hash function used to compute the
//value of the SignaturePolicyHashValue entry. Entries
//shall be represented the same way as SubFilter values
//specified in "Table 260 — SubFilter value algorithm
//support"
//.
//SignaturePolicyCommitmentType Array of
//ASCII
//strings
//(Optional: PDF 2.0) If the SignaturePolicyOID is present,
//this array defines the commitment types that may be used
//within the signature policy. An empty string may be used
//to indicate that all commitments defined by the signature
//policy may be used.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//550 © ISO 2020 – All rights reserved
//Key Type Value
//SubjectDN array of
//dictionaries
//(Optional; PDF 1.7) An array of dictionaries, each
//specifying a Subject Distinguished Name (DN) that shall be
//present within the certificate for it to be acceptable for
//signing. The certificate ultimately used for the digital
//signature shall contain all the attributes specified in each
//of the dictionaries in this array. (PDF keys and values are
//mapped to certificate attributes and values.) The certificate
//is not constrained to use only attribute entries from these
//dictionaries but may contain additional attributes. The
//Subject Distinguished Name is described in Internet RFC
//5280. The key can be any valid attribute identifier (OID).
//Attribute names shall contain characters in the set a-z A-Z
//0-9 and PERIOD.
//Certificate attribute names are used as key names in the
//dictionaries in this array. Values of the attributes are used
//as values of the keys. Values shall be text strings.
//The value of the corresponding flag in the Ff entry
//indicates whether this entry is a required constraint.
//KeyUsage array of
//ASCII
//strings
//(Optional; PDF 1.7) An array of ASCII strings, where each
//string specifies an acceptable key-usage extension that
//shall be present in the signing certificate. Multiple strings
//specify a range of acceptable key-usage extensions. The
//key-usage extension is described in Internet RFC 5280.
//Each character in a string represents a key-usage type,
//where the order of the characters indicates the key-usage
//extension it represents. The first through ninth characters
//in the string, from left to right, represent the required
//value for the following key-usage extensions:
//1 digitalSignature 4 dataEncipherment 7
//cRLSign
//2 non-Repudiation 5 keyAgreement 8
//encipherOnly
//3 keyEncipherment 6 keyCertSign 9
//decipherOnly
//Any additional characters shall be ignored. Any missing
//characters or characters that are not one of the following
//values, shall be treated as ‘X’. The following character
//values shall be supported:
//0 Corresponding key-usage shall not be set.
//1 Corresponding key-usage shall be set.
//X State of the corresponding key-usage does not matter.
//EXAMPLE 1 The string values ‘1’ and ‘1XXXXXXXX’
//represent settings where the key-usage type
//digitalSignature is set and the state of all other
//key-usage types do not matter.
//The value of the corresponding flag in the Ff entry
//indicates whether this is a required constraint.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//Goto errata
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 551
//Key Type Value
//Issuer array (Optional) An array of byte strings containing DER-
//encoded X.509v3 certificates of acceptable issuers. If the
//signer’s certificate refers to any of the specified issuers
//(either directly or indirectly), the certificate shall be
//considered acceptable for signing. The value of the
//corresponding flag in the Ff entry indicates whether this is
//a required constraint.
//This array may contain self-signed certificates.
//OID array (Optional) An array of byte strings that contain Object
//Identifiers (OIDs) of the certificate policies that shall be
//present in the signing certificate.
//EXAMPLE 2 An example of such a string is:
//(2.16.840.1.113733.1.7.1.1)
//This field shall only be used if the value of Issuer is not
//empty. The certificate policies extension is described in
//Internet RFC 5280. The value of the corresponding flag in
//the Ff entry indicates whether this is a required constraint.
//URL ASCII string (Optional) A URL, the use for which shall be defined by the
//URLType entry.
//URLType Name (Optional; PDF 1.7) A name indicating the usage of the URL
//entry. There are standard uses and there can be
//implementation-specific uses for this URL. The following
//value specifies a valid standard usage:
//Browser – The URL references content that shall
//be displayed in a web browser to allow enrolling
//for a new credential if a matching credential is not
//found. The Ff attribute’s URL bit shall be ignored
//for this usage.
//Third parties may extend the use of this attribute with
//their own attribute values, which shall conform to the
//guidelines described in Annex E, "Extending PDF".
//The default value is Browser.
//If the SignaturePolicyOID is absent, the SignaturePolicyHashValue,
//SignaturePolicyHashAlgorithm and SignaturePolicyCommitmentType fields shall be ignored. If
//the SignaturePolicyOID is present but the SignaturePolicyCommitmentType is absent, all
//commitments defined by the signature policy may be used.
//NOTE The above entries allow the creation of a signature-policy-identifier as in CAdES (ETSI 319 122-
//1). All rules defined in CAdES apply. In particular, CAdES allows the creation of a EPES signature
//when the signature policy hash is not available, therefore, the absence of the
//SignaturePolicyHashValue does not preclude the creation of a PAdES-EPES signature.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//552 © ISO 2020 – All rights reserved
//12.7.6 Form actions
//12.7.6.1 General
//Interactive forms also support special types of actions in addition to those described in 12.6.4, "Action
//types"
//:
//• submit-form action
//• reset-form action
//• import-data action
//12.7.6.2 Submit-form action
//Upon invocation of a submit-form action, an interactive PDF processor shall transmit the names and
//values of selected interactive form fields to a specified uniform resource locator (URL).
//NOTE Presumably, the URL is the address of a Web server that will process them and send back a
//response.
//The value of the action dictionary’s Flags entry shall be an non-negative integer containing flags
//specifying various characteristics of the action. Bit positions within the flag word shall be numbered
//starting with 1 (low-order). "Table 240 — Flags for submit-form actions" shows the meanings of the
//flags; all undefined flag bits shall be reserved and shall be set to 0.
//Table 239 — Additional entries specific to a submit-form action
//Key Type Value
//S name (Required) The type of action that this dictionary describes; shall be
//SubmitForm for a submit-form action.
//F file
//specification
//(Required) A URL file specification (see 7.11.5, "URL specifications")
//giving the uniform resource locator (URL) of the script at the Web server
//that will process the submission.
//Fields array (Optional) An array identifying which fields to include in the submission
//or which to exclude, depending on the setting of the Include/Exclude flag
//in the Flags entry (see "Table 240 — Flags for submit-form actions").
//Each element of the array shall be either an indirect reference to a field
//dictionary or (PDF 1.3) a text string representing the fully qualified name
//of a field. Elements of both kinds may be mixed in the same array.
//If this entry is omitted, the Include/Exclude flag shall be ignored, and all
//fields in the document’s interactive form shall be submitted except those
//whose NoExport flag (see "Table 227 — Field flags common to all field
//types") is set. Fields with no values may also excluded, as dictated by the
//value of the IncludeNoValueFields flag; see "Table 240 — Flags for
//submit-form actions"
//.
//Flags integer (Optional; inheritable) A set of flags specifying various characteristics of
//the action (see "Table 240 — Flags for submit-form actions"). Default
//value: 0.
//CharSet string (Optional; inheritable; PDF 2.0) Supported values include: utf-8, utf-16,
//Shift-JIS, BigFive, GBK, or UHC.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 553
//Table 240 — Flags for submit-form actions
//Bit position Name Meaning
//1 Include/Exclude If clear, the Fields array (see "Table 239 — Additional entries
//specific to a submit-form action") specifies which fields to
//include in the submission. (All descendants of the specified
//fields in the field hierarchy shall be submitted as well.)
//If set, the Fields array tells which fields to exclude. All fields in
//the document’s interactive form shall be submitted except
//those listed in the Fields array and those whose NoExport flag
//(see "Table 227 — Field flags common to all field types") is set
//and fields with no values if the IncludeNoValueFields flag is
//clear.
//2 IncludeNoValueFields If set, all fields designated by the Fields array and the
//Include/Exclude flag shall be submitted, regardless of whether
//they have a value (V entry in the field dictionary). For fields
//without a value, only the field name shall be transmitted.
//If clear, fields without a value shall not be submitted.
//3 ExportFormat Meaningful only if the SubmitPDF and XFDF flags are clear. If
//set, field names and values shall be submitted in HTML Form
//format. If clear, they shall be submitted in Forms Data Format
//(FDF); see 12.7.8, "Forms data format"
//.
//4 GetMethod If set, field names and values shall be submitted using an
//HTTP GET request. If clear, they shall be submitted using a
//POST request. This flag is meaningful only when the
//ExportFormat flag is set; if ExportFormat is clear, this flag
//shall also be clear.
//5 SubmitCoordinates If set, the coordinates of the mouse click that caused the
//submit-form action shall be transmitted as part of the form
//data. The coordinate values are relative to the upper-left
//corner of the field’s widget annotation rectangle. They shall be
//represented in the data in the format name . x = xval & name .
//y = yval where name is the field’s mapping name (TM in the
//field dictionary) if present; otherwise, name is the field name.
//If the value of the TM entry is a single ASCII SPACE (20h)
//character, both the name and the ASCII PERIOD (2Eh)
//following it shall be suppressed, resulting in the format x =
//xval & y = yval
//This flag shall be used only when the ExportFormat flag is set.
//If ExportFormat is clear, this flag shall also be clear.
//6 XFDF (PDF 1.4) shall be used only if the SubmitPDF flags are clear. If
//set, field names and values shall be submitted as XFDF.
//7 IncludeAppendSaves (PDF 1.4) shall be used only when the form is being submitted
//in Forms Data Format (that is, when both the XFDF and
//ExportFormat flags are clear). If set, the submitted FDF file
//shall include the contents of all incremental updates to the
//underlying PDF document, as contained in the Differences
//entry in the FDF dictionary (see "Table 246 — Entries in the
//FDF dictionary"). If clear, the incremental updates shall not be
//included.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//554 © ISO 2020 – All rights reserved
//Bit position Name Meaning
//8 IncludeAnnotations (PDF 1.4) shall be used only when the form is being submitted
//in Forms Data Format (that is, when both the XFDF and
//ExportFormat flags are clear). If set, the submitted FDF file
//shall include includes all markup annotations in the
//underlying PDF document (see 12.5.6.2, "Markup
//annotations"). If clear, markup annotations shall not be
//included.
//9 SubmitPDF (PDF 1.4) If set, the document shall be submitted as PDF, using
//the MIME media type application/pdf as defined by Internet
//RFC 8118. If set, all other flags shall be ignored except
//GetMethod.
//10 CanonicalFormat (PDF 1.4) If set, any submitted field values representing dates
//shall be converted to the standard format described in 7.9.4,
//"Dates"
//.
//NOTE 1 The interpretation of a form field as a date is not specified
//explicitly in the field itself but only in the ECMAScript code
//that processes it.
//11 ExclNonUserAnnots (PDF 1.4) shall be used only when the form is being submitted
//in Forms Data Format (that is, when both the XFDF and
//ExportFormat flags are clear) and the IncludeAnnotations flag
//is set. If set, it shall include only those markup annotations
//whose T entry (see "Table 172 — Additional entries in an
//annotation dictionary specific to markup annotations")
//matches the name of the current user, as determined by the
//remote server to which the form is being submitted.
//NOTE 2 The T entry for markup annotations specifies the text label
//that is displayed in the title bar of the annotation’s popup
//window and is assumed to represent the name of the user
//authoring the annotation.
//NOTE 3 This allows multiple users to collaborate in annotating a
//single remote PDF document without affecting one
//another’s annotations.
//12 ExclFKey (PDF 1.4) shall be used only when the form is being submitted
//in Forms Data Format (that is, when both the XFDF and
//ExportFormat flags are clear). If set, the submitted FDF shall
//exclude the F entry.
//14 EmbedForm (PDF 1.5) shall be used only when the form is being submitted
//in Forms Data Format (that is, when both the XFDF and
//ExportFormat flags are clear). If set, the F entry of the
//submitted FDF shall be a file specification containing an
//embedded file stream representing the PDF file from which
//the FDF is being submitted.
//The set of fields whose names and values are to be submitted shall be defined by the Fields array in
//the action dictionary ("Table 239 — Additional entries specific to a submit-form action") together with
//the Include/Exclude and IncludeNoValueFields flags in the Flags entry ("Table 240 — Flags for submit-
//form actions"). Each element of the Fields array shall identify an interactive form field, either by an
//indirect reference to its field dictionary or (PDF 1.3) by its fully qualified field name (see 12.7.4.2,
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//"Field names"). If the Include/Exclude flag is clear, the submission consists of all fields listed in the
//Fields array, along with any descendants of those fields in the field hierarchy. If the Include/Exclude
//flag is set, the submission shall consist of all fields in the document’s interactive form except those
//listed in the Fields array.
//The NoExport flag in the field dictionary’s Ff entry (see "Table 226 — Entries common to all field
//dictionaries" and "Table 227 — Field flags common to all field types") takes precedence over the
//action’s Fields array and Include/ Exclude flag. Fields whose NoExport flag is set shall not be included
//in a submit-form action.
//Field names and values may be submitted in any of the following formats, depending on the settings of
//the action’s ExportFormat, SubmitPDF, and XFDF flags:
//• HTML Form format (described in the HTML 4.01 Specification).
//• Forms Data Format (FDF), which is described in 12.7.8, "Forms data format"
//.
//• XFDF, a version of FDF based on XML as defined by ISO 19444-1.
//• PDF (in this case, the entire document shall be submitted rather than individual fields and values).
//The name submitted for each field shall be its fully qualified name (see 12.7.4.2, "Field names"), and
//the value shall be specified by the V entry in its field dictionary.
//For push-button fields submitted in FDF, the value submitted shall be that of the AP entry in the field’s
//widget annotation dictionary. If the submit-form action dictionary contains no Fields entry, such push-
//button fields shall not be submitted.
//Fields with no value (that is, whose field dictionary does not contain a V entry) are ordinarily not
//included in the submission. The submit-form action’s IncludeNoValueFields flag may override this
//behaviour. If this flag is set, such valueless fields shall be included in the submission by name only, with
//no associated value.
//12.7.6.3 Reset-form action
//Upon invocation of a reset-form action, an interactive PDF processor shall reset selected interactive
//form fields to their default values; that is, it shall set the value of the V entry in the field dictionary to
//that of the DV entry (see "Table 226 — Entries common to all field dictionaries"). If no default value is
//defined for a field, its V entry shall be removed. For fields that can have no value (such as push-
//buttons), the action has no effect. "Table 241 — Additional entries specific to a reset-form action"
//shows the action dictionary entries specific to this type of action.
//The value of the action dictionary’s Flags entry is a non-negative containing flags specifying various
//characteristics of the action. Bit positions within the flag word shall be numbered starting from 1 (low-
//order). Only one flag is defined for this type of action. All undefined flag bits shall be reserved and shall
//be set to 0.
//© ISO 2020 – All rights reserved 555
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//556 © ISO 2020 – All rights reserved
//Table 241 — Additional entries specific to a reset-form action
//Key Type Value
//S name (Required) The type of action that this dictionary describes;
//shall be ResetForm for a reset-form action.
//Fields array (Optional) An array identifying which fields to reset or
//which to exclude from resetting, depending on the setting
//of the Include/ Exclude flag in the Flags entry (see "Table
//242 — Flag for reset-form actions"). Each element of the
//array shall be either an indirect reference to a field
//dictionary or (PDF 1.3) a text string representing the fully
//qualified name of a field. Elements of both kinds may be
//mixed in the same array.
//If this entry is omitted, the Include/Exclude flag shall be
//ignored; all fields in the document’s interactive form are
//reset.
//Flags integer (Optional; inheritable) A set of flags specifying various
//characteristics of the action (see "Table 242 — Flag for
//reset-form actions"). Default value: 0.
//Table 242 — Flag for reset-form actions
//Bit position Name Meaning
//1 Include/Exclude If clear, the Fields array (see "Table 241 — Additional
//entries specific to a reset-form action") specifies which fields
//to reset. (All descendants of the specified fields in the field
//hierarchy are reset as well.) If set, the Fields array indicates
//which fields to exclude from resetting; that is, all fields in the
//document’s interactive form shall be reset except those listed
//in the Fields array.
//12.7.6.4 Import-data action
//Upon invocation of an import-data action, a PDF processor shall import data (see “Table 243 —
//Additional entries specific to an import-data action”) from Forms Data Format (FDF), XFDF (XML-
//based Forms Data Format according to ISO 19444-1) or any other data format that it supports into the
//document’s interactive form from a specified file.
//Table 243 — Additional entries specific to an import-data action
//Key Type Value
//S name (Required) The type of action that this dictionary describes; shall be
//ImportData for an import-data action.
//F file specification (Required) The FDF, XFDF or any other data format file from which to
//import the data.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.7.7 Named pages
//The optional Pages entry (PDF 1.3) in a document’s name dictionary (see 7.7.4, "Name dictionary")
//contains a name tree that maps name strings to individual pages within the document. Naming a page
//allows it to be referenced in two different ways:
//• An import-data action can add the named page to the document into which FDF is being imported,
//either as a page or as a button appearance.
//• A script executed by an ECMAScript action can add the named page to the current document as a
//regular page.
//A named page that is intended to be visible to a user shall be left in the page tree (see 7.7.3, "Page
//tree"), and there shall be a reference to it in the appropriate leaf node of the name dictionary’s Pages
//tree. If the page is not intended to be displayed by the PDF processor, it shall be referenced from the
//name dictionary’s Templates tree instead. Such invisible pages shall have an object type of Template
//rather than Page and shall have no Parent or B entry (see "Table 31 — Entries in a page object").
//12.7.8 Forms data format
//12.7.8.1 General
//This subclause describes Forms Data Format (FDF), the file format used for interactive form data (PDF
//1.2). FDF can be used when submitting form data to a server, receiving the response, and incorporating
//it into the interactive form. It can also be used to export form data to stand-alone files that can be
//stored, transmitted electronically, and imported back into the corresponding PDF interactive form. In
//addition, beginning in PDF 1.3, FDF can be used to define a container for annotations that are separate
//from the PDF document to which they apply.
//FDF is based on PDF; it uses the same syntax and has essentially the same file structure (7.5, "File
//structure"). However, it differs from PDF in the following ways:
//• The cross-reference table (7.5.4, "Cross-reference table") is optional.
//• FDF files shall not be updated (see 7.5.6, "Incremental updates"). Objects shall only be of
//generation 0, and no two objects within an FDF file shall have the same object number.
//• The document structure is much simpler than PDF, since the body of an FDF document consists of
//only one required object.
//• The length of a stream shall not be specified by an indirect object.
//FDF shall use the MIME media type application/vnd.fdf. On the Microsoft WindowsTM and UNIX
//platforms, FDF files shall have the extension .fdf; on Mac OS, they shall have file type 'FDF'.
//12.7.8.2 FDF file structure
//12.7.8.2.1 General
//An FDF file shall be structured in essentially the same way as a PDF file but contains only those
//elements required for the export and import of interactive form and annotation data. It consists of
//three required elements and one optional element (see "Figure 85 — FDF file structure"):
//© ISO 2020 – All rights reserved 557
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//• A one-line header identifying the version number of the PDF specification to which the file
//conforms
//• A body containing the objects that make up the content of the file
//• An optional cross-reference table containing information about the indirect objects in the file
//• An optional trailer giving the location of the cross-reference table and of certain special objects
//within the body of the file
//Figure 85 — FDF file structure
//12.7.8.2.2 FDF header
//The first line of an FDF file shall be a header, which shall contain
//%FDF-1.2
//The version number is given by the Version entry in the FDF catalog dictionary (see 12.7.8.3, "FDF
//catalog").
//12.7.8.2.3 FDF body
//The body of an FDF file shall consist of a sequence of indirect objects representing the file’s catalog
//dictionary (see 12.7.8.3, "FDF catalog") and any additional objects that the catalog dictionary
//references. The objects are of the same basic types described in 7.5, "File structure" (other than the
//%PDF–n.m and %%EOF comments described in 7.5, "File structure") have no semantics. They are not
//necessarily preserved by PDF processors. Just as in PDF, objects in FDF can be direct or indirect.
//12.7.8.2.4 FDF trailer
//The trailer of an FDF file enables an interactive PDF processor to find significant objects quickly within
//the body of the file. The last line of the file contains only the end-of-file marker, %%EOF. This marker
//shall be preceded by the FDF trailer dictionary, consisting of the keyword trailer followed by a series
//558 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 559
//of one or more key-value pairs enclosed in double angle brackets (<<…>>) (using LESS-THAN SIGNs
//(3Ch) and GREATER-THAN SIGNs (3Eh)). The only required key is Root whose value shall be an
//indirect reference to the file’s catalog dictionary (see "Table 244 — Entry in the FDF trailer
//dictionary"). The trailer may optionally contain additional entries for objects that are referenced from
//within the catalog dictionary.
//Table 244 — Entry in the FDF trailer dictionary
//Key Type Value
//Root dictionary (Required; shall be an indirect reference) The catalog dictionary object
//for this FDF file (see 12.7.8.3, "FDF catalog").
//Thus, the trailer has the overall structure
//trailer
//<</Root c 0 R
//key2 value2
//…
//keyn valuen
//>>
//%%EOF
//where c is the object number of the file’s catalog dictionary.
//12.7.8.3 FDF catalog
//12.7.8.3.1 General
//The root node of an FDF file’s object hierarchy is the catalog dictionary, located by means of the Root
//entry in the file’s trailer dictionary (see 12.7.8.2.4, "FDF trailer"). As shown in "Table 245 — Entries in
//the FDF catalog dictionary", the only required entry in the catalog dictionary is FDF; its value shall be
//an FDF dictionary ("Table 246 — Entries in the FDF dictionary"), which in turn shall contain references
//to other objects describing the file’s contents. The catalog dictionary may also contain an optional
//Version entry identifying the version of the PDF specification to which this FDF file conforms. “Table
//245 — Entries in the FDF catalog dictionary” describes the entries in the FDF catalog dictionary.
//Table 245 — Entries in the FDF catalog dictionary
//Key Type Value
//Version name (Optional; PDF 1.4) The version of the FDF specification to
//which this FDF file conforms (for example, 1.4) if later
//than the version specified in the file’s header (see
//12.7.8.2.2, "FDF header"). If the header specifies a later
//version, or if this entry is absent, the document conforms
//to the version specified in the header.
//The value of this entry is a name object, not a number, and
//therefore shall be preceded by a slash character (/) when
//written in the FDF file (for example, /1.4).
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//560 © ISO 2020 – All rights reserved
//Key Type Value
//FDF dictionary (Required) The FDF dictionary for this file (see "Table 246
//— Entries in the FDF dictionary").
//Table 246 — Entries in the FDF dictionary
//Key Type Value
//F file specification (Optional) The source file or target file: the PDF document file that
//this FDF file was exported from or is intended to be imported into.
//ID array (Optional) An array of two byte strings constituting a file identifier
//(see 14.4,
//"File identifiers") for the source or target file designated
//by F, taken from the ID entry in the file’s trailer dictionary (see
//7.5.5, "File trailer").
//Fields array (Optional) An array of FDF field dictionaries (see 12.7.8.3.2, "FDF
//fields" in 12.7.8.3, "FDF catalog") describing the root fields (those
//with no ancestors in the field hierarchy) that shall be exported or
//imported. This entry and the Pages entry shall not both be present.
//Status PDFDocEncoded
//string
//(Optional) A status string that shall be displayed indicating the
//result of an action, typically a submit-form action (see 12.7.6.2,
//"Submit-form action"). The string shall be encoded with
//PDFDocEncoding. This entry and the Pages entry shall not both be
//present.
//Pages array (Optional; PDF 1.3) An array of FDF page dictionaries (see
//12.7.8.3.3, "FDF pages") describing pages that shall be added to a
//PDF target document. The Fields and Status entries shall not be
//present together with this entry.
//Encoding name (Optional; PDF 1.3) The encoding that shall be used for any FDF
//field value or option (V or Opt in the field dictionary; see "Table
//249 — Entries in an FDF field dictionary") or field name that is a
//string and does not begin with the Unicode prefix ZERO WIDTH
//NO-BREAK SPACE (U+FEFF).
//Default value: PDFDocEncoding.
//Other allowed values include Shift_JIS, BigFive, GBK, UHC, utf_8,
//utf_16
//Annots array (Optional; PDF 1.3) An array of FDF annotation dictionaries (see
//12.7.8.3.4, "FDF annotation dictionaries" in 12.7.8.3, "FDF catalog").
//The array may include annotations of any of the standard types
//listed in "Table 171 — Annotation types" except Link, Movie,
//Widget, PrinterMark, Screen, and TrapNet.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 561
//Key Type Value
//Differences stream (Optional; PDF 1.4) A stream containing all the bytes in all
//incremental updates made to the underlying PDF document since it
//was opened (see 7.5.6, "Incremental updates"). If a submit-form
//action submitting the document to a remote server as FDF has its
//IncludeAppendSaves flag set (see 12.7.6.2, "Submit-form action"),
//the contents of this stream shall be included in the submission.
//This allows any digital signatures (see 12.8, "Digital signatures") to
//be transmitted to the server. An incremental update shall be
//automatically performed just before the submission takes place, in
//order to capture all changes made to the document.
//The submission shall include the full set of incremental updates
//back to the time the document was first opened, even if some of
//them may already have been included in intervening submissions.
//Although a Fields or Annots entry (or both) may be present along
//with Differences, there is no requirement that their contents will
//be consistent with each other. In particular, if Differences contains
//a digital signature, only the values of the form fields given in the
//Differences stream shall be considered trustworthy under that
//signature.
//Target string (Optional; PDF 1.4) The name of a browser frame in which the
//underlying PDF document shall be opened. This mimics the
//behaviour of the target attribute in HTML <href> tags.
//EmbeddedFDFs array (Optional; PDF 1.4) An array of file specifications (see 7.11, "File
//specifications") representing other FDF files embedded within this
//one (7.11.4, "Embedded file streams").
//JavaScript dictionary (Optional; PDF 1.4) An ECMAScript dictionary (see "Table 248 —
//Entries in the ECMAScript dictionary") defining document-level
//ECMAScript scripts.
//Although deprecated in PDF 2.0, embedded FDF files specified in the FDF dictionary’s EmbeddedFDFs
//entry may be encrypted. Besides the usual entries for an embedded file stream, the stream dictionary
//representing such an encrypted FDF file shall contain the additional entry shown in "Table 247 —
//Additional entry in an embedded file stream dictionary for an encrypted FDF file" to identify the
//revision number of the FDF encryption algorithm used to encrypt the file. Although the FDF encryption
//mechanism is separate from the one for PDF file encryption described in 7.6, "Encryption" revision 1
//(the only one defined) uses a similar RC4 encryption algorithm based on a 40-bit encryption key. The
//key shall be computed by means of an MD5 hash, using a padded user-supplied password as input. The
//computation shall be identical to steps (a) and (b) of the "Algorithm 2: Computing a file encryption key
//in order to encrypt a document (revision 4 and earlier)" in 7.6.4.3, "File encryption key algorithm"; the
//first 5 bytes of the result shall be the file encryption key for the embedded FDF file.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//562 © ISO 2020 – All rights reserved
//Table 247 — Additional entry in an embedded file stream dictionary for an encrypted FDF file
//Key Type Value
//EncryptionRevision integer (Required if the FDF file is encrypted; deprecated in PDF 2.0) The
//revision number of the FDF encryption algorithm used to encrypt
//the file. This value shall be 1.
//The JavaScript entry in the FDF dictionary holds an ECMAScript dictionary containing ECMAScript
//scripts that shall be defined globally at the document level, rather than associated with individual
//fields. The dictionary may contain scripts defining ECMAScript functions for use by other scripts in the
//document, as well as scripts that shall be executed immediately before and after the FDF file is
//imported. "Table 248 — Entries in the ECMAScript dictionary" shows the contents of this dictionary.
//Table 248 — Entries in the ECMAScript dictionary
//Key Type Value
//Before text string or
//text stream
//(Optional) A text string or text stream containing an
//ECMAScript script that shall be executed just before the FDF
//file is imported.
//After text string or
//text stream
//(Optional) A text string or text stream containing an
//ECMAScript script that shall be executed just after the FDF file
//is imported.
//AfterPermsReady text string or
//text stream
//(Optional; PDF 1.6) A text string or text stream containing an
//ECMAScript script that shall be executed after the FDF file is
//imported and the usage rights in the PDF document have been
//determined (see 12.8.2.3, "UR").
//Doc Array (Optional) An array defining additional ECMAScript scripts that
//shall be added to those defined in the JavaScript entry of the
//document’s name dictionary (see 7.7.4, "Name dictionary").
//The array shall contain an even number of elements, organised
//in pairs. The first element of each pair shall be a name and the
//second shall be a text string or text stream defining the script
//corresponding to that name. Each of the defined scripts shall be
//added to those already defined in the name dictionary and shall
//then be executed before the script defined in the Before entry
//is executed.
//NOTE As described in 12.6.4.17, "ECMAScript actions" these
//scripts are used to define ECMAScript functions for use by
//other scripts in the document.
//12.7.8.3.2 FDF fields
//Each field in an FDF file shall be described by an FDF field dictionary.
//"Table 249 — Entries in an FDF
//field dictionary" shows the contents of this type of dictionary. Most of the entries have the same form
//and meaning as the corresponding entries in a field dictionary ("Table 226 — Entries common to all
//field dictionaries"
//,
//"Table 228 — Additional entries common to all fields containing variable text"
//,
//"Table 232 — Additional entry specific to a text field", and "Table 234 — Additional entries specific to a
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 563
//choice field") or a widget annotation dictionary ("Table 170 — Entries in an appearance dictionary"
//and "Table 191 — Additional entries specific to a widget annotation"). Unless otherwise indicated in
//the table, importing a field causes the values of the entries in the FDF field dictionary to replace those
//of the corresponding entries in the field with the same fully qualified name in the target document.
//Table 249 — Entries in an FDF field dictionary
//Key Type Value
//Kids array (Optional) An array containing the immediate children of this field.
//Unlike the children of fields in a PDF file, which shall be specified as
//indirect object references, those of an FDF field may be either direct or
//indirect objects.
//T text string (Required) The partial field name (see 12.7.4.2, "Field names").
//V (various) (Optional) The field’s value, whose format varies depending on the field
//type; see the descriptions of individual field types in 12.7.5, "Field types"
//for further information.
//Ff integer (Optional) A set of flags specifying various characteristics of the field (see
//"Table 227 — Field flags common to all field types"
//,
//"Table 229 — Field
//flags specific to button fields"
//,
//"Table 231 — Field flags specific to text
//fields", and "Table 233 — Field flags specific to choice fields"). When
//imported into an interactive form, the value of this entry shall replace that
//of the Ff entry in the form’s corresponding field dictionary. If this field is
//present, the SetFf and ClrFf entries, if any, shall be ignored.
//SetFf integer (Optional) A set of flags to be set (turned on) in the Ff entry of the form’s
//corresponding field dictionary. Bits equal to 1 in SetFf shall cause the
//corresponding bits in Ff to be set to 1. This entry shall be ignored if an Ff
//entry is present in the FDF field dictionary.
//ClrFf integer (Optional) A set of flags to be cleared (turned off) in the Ff entry of the
//form’s corresponding field dictionary. Bits equal to 1 in ClrFf shall cause
//the corresponding bits in Ff to be set to 0. If a SetFf entry is also present in
//the FDF field dictionary, it shall be applied before this entry. This entry
//shall be ignored if an Ff entry is present in the FDF field dictionary.
//F integer (Optional) A set of flags specifying various characteristics of the field’s
//widget annotation (see 12.5.3, "Annotation flags"). When imported into an
//interactive form, the value of this entry shall replace that of the F entry in
//the form’s corresponding annotation dictionary. If this field is present, the
//SetF and ClrF entries, if any, shall be ignored.
//SetF integer (Optional) A set of flags to be set (turned on) in the F entry of the form’s
//corresponding widget annotation dictionary. Bits equal to 1 in SetF shall
//cause the corresponding bits in F to be set to 1. This entry shall be ignored
//if an F entry is present in the FDF field dictionary.
//ClrF integer (Optional) A set of flags to be cleared (turned off) in the F entry of the
//form’s corresponding widget annotation dictionary. Bits equal to 1 in ClrF
//shall cause the corresponding bits in F to be set to 0. If a SetF entry is also
//present in the FDF field dictionary, it shall be applied before this entry.
//This entry shall be ignored if an F entry is present in the FDF field
//dictionary.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//564 © ISO 2020 – All rights reserved
//Key Type Value
//AP dictionary (Optional) An appearance dictionary specifying the appearance of a push-
//button field (see 12.7.5.2.2, "Push-buttons"). The appearance dictionary’s
//contents are as shown in "Table 170 — Entries in an appearance
//dictionary", except that the values of the N, R, and D entries shall all be
//streams.
//APRef dictionary (Optional; PDF 1.3) A dictionary holding references to external PDF files
//containing the pages to use for the appearances of a push-button field.
//This dictionary is similar to an appearance dictionary (see "Table 170 —
//Entries in an appearance dictionary"), except that the values of the N, R,
//and D entries shall all be named page reference dictionaries ("Table 253
//— Entries in an FDF named page reference dictionary"). This entry shall
//be ignored if an AP entry is present.
//IF dictionary (Optional; PDF 1.3; button fields only) An icon fit dictionary (see "Table 250
//— Entries in an icon fit dictionary") specifying how to display a button
//field’s icon within the annotation rectangle of its widget annotation.
//Opt array (Required; choice fields only) An array of options that shall be presented to
//the user. Each element of the array shall take one of two forms:
//A text string representing one of the available options
//A two-element array consisting of a text string representing one of the
//available options and a default appearance string for constructing the
//item’s appearance dynamically at viewing time (12.7.4.3, "Variable text").
//A dictionary (Optional) An action that shall be performed when this field’s widget
//annotation is activated (see 12.6, "Actions").
//AA dictionary (Optional) An additional-actions dictionary defining the field’s behaviour
//in response to various trigger events (see 12.6.3, "Trigger events").
//RV text string or
//text stream
//(Optional; PDF 1.5) A rich text string, as in Adobe XML Architecture, XML
//Forms Architecture (XFA) Specification, version 3.3.
//In an FDF field dictionary representing a button field, the optional IF entry holds an icon fit dictionary
//(PDF 1.3) specifying how to display the button’s icon within the annotation rectangle of its widget
//annotation. "Table 250 — Entries in an icon fit dictionary" shows the contents of this type of
//dictionary.
//Table 250 — Entries in an icon fit dictionary
//Key Type Value
//SW name (Optional) The circumstances under which the icon shall be scaled inside the
//annotation rectangle:
//A Always scale.
//B Scale only when the icon is bigger than the annotation rectangle.
//S Scale only when the icon is smaller than the annotation rectangle.
//N Never scale.
//Default value: A.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 565
//Key Type Value
//S name (Optional) The type of scaling that shall be used:
//A Anamorphic scaling: Scale the icon to fill the annotation rectangle
//exactly, without regard to its original aspect ratio (ratio of width to
//height).
//P Proportional scaling: Scale the icon to fit the width or height of the
//annotation rectangle while maintaining the icon’s original aspect ratio.
//If the required horizontal and vertical scaling factors are different, use
//the smaller of the two, centring the icon within the annotation
//rectangle in the other dimension.
//Default value: P.
//A array (Optional) An array of two numbers that shall be between 0.0 and 1.0
//indicating the fraction of leftover space to allocate at the left and bottom of
//the icon. A value of [0.0 0.0] shall position the icon at the bottom-left corner
//of the annotation rectangle. A value of [0.5 0.5] shall centre it within the
//rectangle. This entry shall be used only if the icon is scaled proportionally.
//Default value: [0.5 0.5].
//FB boolean (Optional; PDF 1.5) If true, indicates that the button appearance shall be
//scaled to fit fully within the bounds of the annotation without taking into
//consideration the line width of the border. Default value: false.
//12.7.8.3.3 FDF pages
//The optional Pages field in an FDF dictionary (see "Table 246 — Entries in the FDF dictionary") shall
//contain an array of FDF page dictionaries (PDF 1.3) describing new pages that shall be added to the
//target document. "Table 251 — Entries in an FDF page dictionary" shows the contents of this type of
//dictionary.
//Table 251 — Entries in an FDF page dictionary
//Key Type Value
//Templates array (Required) An array of FDF template dictionaries (see "Table 252 —
//Entries in an FDF template dictionary") that shall describe the named
//pages that serve as templates on the page.
//Info dictionary (Optional) An FDF page information dictionary that shall contain
//additional information about the page.
//An FDF template dictionary shall contain information describing a named page that serves as a
//template. "Table 252 — Entries in an FDF template dictionary" shows the contents of this type of
//dictionary.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//566 © ISO 2020 – All rights reserved
//Table 252 — Entries in an FDF template dictionary
//Key Type Value
//TRef dictionary (Required) A named page reference dictionary (see "Table 253 —
//Entries in an FDF named page reference dictionary") that shall
//specify the location of the template.
//Fields array (Optional) An array of references to FDF field dictionaries (see "Table
//249 — Entries in an FDF field dictionary") describing the root fields
//that shall be imported (those with no ancestors in the field
//hierarchy).
//Rename boolean (Optional) A flag that shall specify whether fields imported from the
//template shall be renamed in the event of name conflicts with
//existing fields.
//If this flag is true, fields with such conflicting names shall be renamed
//to guarantee their uniqueness. If false, the fields shall not be
//renamed; this results in multiple fields with the same name in the
//target document. Each time the FDF file provides attributes for a
//given field name, all fields with that name shall be updated. See the
//Note in this subclause for further discussion.
//Default value: true.
//NOTE The names of fields imported from a template can sometimes conflict with those of existing fields
//in the target document. This can occur, for example, if the same template page is imported more
//than once or if two different templates have fields with the same names.
//Although the Rename flag does not define a renaming algorithm, this might be implemented by a PDF
//processor renaming fields by prepending a page number, a template name, and an ordinal number to
//the field name.
//The TRef entry in an FDF template dictionary shall hold a named page reference dictionary that shall
//describe the location of external templates or page elements. "Table 253 — Entries in an FDF named
//page reference dictionary" shows the contents of this type of dictionary.
//Table 253 — Entries in an FDF named page reference dictionary
//Key Type Value
//Name string (Required) The name of the referenced page.
//F file specification (Optional) The file containing the named page. If this entry is
//absent, it shall be assumed that the page resides in the associated
//PDF file.
//12.7.8.3.4 FDF annotation dictionaries
//Each annotation dictionary in an FDF file shall have a Page entry (see "Table 254 — Additional entry
//for annotation dictionaries in an FDF file") that shall indicate the page of the source document to which
//the annotation is attached.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 254 — Additional entry for annotation dictionaries in an FDF file
//Key Type Value
//Page integer (Required for annotations in FDF files) The ordinal page number on
//which this annotation shall appear, where page 0 is the first page.
//12.7.9 Non-interactive forms
//Unlike interactive forms, non-interactive forms do not use widget annotations but are represented
//with page content. Non-interactive forms are defined by the PrintField attrib0ute (14.8.5.6, "PrintField
//attributes") for repurposing and accessibility purposes.
