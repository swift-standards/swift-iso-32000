// ISO 32000-2:2020, 12.8 Digital signatures

import ISO_32000_Shared

//12.8 Digital signatures
//12.8.1 General
//A digital signature (PDF 1.3) may be used to verify the integrity of the document’s contents using
//verification information related to a signer. The signature may be purely mathematical, such as a
//public/private-key encrypted document digest, or it may be a biometric form of identification, such as
//a handwritten signature, fingerprint, or retinal scan. The specific form of authentication used shall be
//implemented by a special software module called a signature handler. Signature handlers shall be
//identified in accordance with the rules defined in Annex E, "Extending PDF".
//Digital signatures in PDF support four activities:
//• the addition of a digital signature to a document,
//• the verification of the validity of a signature added to a document,
//• the addition of DSS dictionaries and of validation related information (VRI) to allow for later
//verifications (see 12.8.4.4, "Validation-related information (VRI)"), and
//• the addition of document timestamp dictionaries (DTS) to allow for later verifications (see 12.8.5,
//"Document timestamp (DTS) dictionary").
//PDF 2.0 processors should support digital signatures based on the Cryptographic Message Syntax
//(CMS) and CAdES (ETSI EN 319 122).
//Signature information shall be contained in a signature dictionary, whose entries are listed in "Table
//255 — Entries in a signature dictionary". Signature handlers may use or omit those entries that are
//marked optional in the table but should use them in a standard way if they are used at all. In addition,
//signature handlers may add private entries of their own. To avoid name duplication, the keys for all
//such private entries shall be prefixed with the registered handler name followed by a PERIOD (2Eh).
//Signatures shall be created using an appropriate signature handler. That signature handler shall match
//with the type of the signature that is intended to be created. It shall compute a digest using a
//cryptographic hash function over the data of the document, and store it in the document.
//To verify the signature, an appropriate signature handler is required. That signature handler shall
//match with the type of the signature that has been created. The signer’s certificate shall be determined
//and verified by the signature handler to match with any of the validation parameters and other
//© ISO 2020 – All rights reserved 567
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//conditions. If the verification fails, the signature shall be considered invalid. The digest shall be re-
//computed and compared with the one stored in the document. Differences between the two indicates
//that modifications have been made since the document was signed and thus the signature shall be
//considered invalid.
//NOTE 1 If a signed document is modified and saved by incremental update (see 7.5.6, "Incremental
//updates"), the data corresponding to the byte range of the original signature is preserved.
//Therefore, if the signature is valid, the state of the document can be recreated as it existed at the
//time of signing.
//There are two defined techniques for computing a digital signature of the contents of a PDF file:
//• A byte range digest shall be computed over a range of bytes in the PDF file, that shall be indicated
//by the ByteRange entry in the signature dictionary. This range should be the entire PDF file,
//including the signature dictionary but excluding the signature value itself (the Contents entry). In
//case of multiple digital signatures this range shall be the sequence of bytes starting from the
//"%PDF-" comment at the beginning of the PDF document to the end of the "%%EOF" comment,
//possibly followed by an optional EOL marker, terminating the incremental update that adds the
//digital signature dictionary to the document. When a byte range digest is present, all values in the
//signature dictionary shall be direct objects.
//• Additionally, modification detection may be specified by a signature reference dictionary. The
//TransformMethod entry shall specify the general method for modification detection, and the
//TransformParams entry shall specify the variable portions of the method.
//A PDF document may contain the following standard types of signatures:
//• At most one usage rights signature (PDF 1.5, deprecated in PDF 2.0). It shall only be applied if no
//other type of signature is already present. Its signature dictionary shall be referenced from the
//UR3 (PDF 1.6) entry in the permissions dictionary, whose entries are listed in "Table 263 —
//Entries in a permissions dictionary", (not from a signature field). The signature dictionary shall
//contain a Reference entry whose value is a signature reference dictionary that has a UR
//transform method. See 12.8.2.3,
//"UR" for information on how these signatures shall be created
//and validated. When a usage rights signature is present, it is up to the PDF processor or to the
//signature handler to process it or not.
//• At most one certification signature (also known as author signature) (PDF 1.5). The signature
//dictionary of a certification signature shall be the value of a signature field and shall contain a
//ByteRange entry. It may also be referenced from the DocMDP entry in the permissions
//dictionary (see Table 263 — Entries in a permissions dictionary). The signature dictionary shall
//contain a signature reference dictionary (see "Table 256 — Entries in a signature reference
//dictionary") that has a DocMDP transform method. See 12.8.2.2,
//"DocMDP" for information on
//how these signatures shall be created and validated.
//• One or more approval signatures (also known as recipient signatures). These shall follow the
//certification signature if one is present. The signature dictionary of an approval signature shall be
//the value of a signature field and shall contain a ByteRange entry.
//NOTE 2 A signature dictionary for a certification or approval signature can also have a signature
//reference dictionary with a FieldMDP transform method; see 12.8.2.4, "FieldMDP"
//.
//• Any number of document timestamp signatures, see 12.8.5, "Document timestamp (DTS)
//dictionary"
//. The timestamp signature dictionary of a document timestamp signature shall be the
//value of a signature field and shall contain a ByteRange entry.
//A signature dictionary is used by all of these types of signatures.
//568 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 255 — Entries in a signature dictionary
//Key Type Value
//Type name (Optional if Sig; Required if DocTimeStamp) The type of PDF object that this
//dictionary describes; if present, shall be Sig for a signature dictionary or
//DocTimeStamp for a timestamp signature dictionary.
//The default value is: Sig.
//Filter name (Required; inheritable) The name of the preferred signature handler to use
//when validating this signature. If the Prop_Build entry is not present, it shall
//be also the name of the signature handler that was used to create the
//signature. If Prop_Build is present, it may be used to determine the name of
//the handler that created the signature (which is typically the same as Filter
//but is not needed to be). A PDF processor may substitute a different handler
//when verifying the signature, as long as it supports the specified SubFilter
//format. Example signature handlers are Adobe.PPKLite, Entrust.PPKEF,
//CICI.SignIt, and VeriSign.PPKVS. The name of the filter (i.e. signature handler)
//shall be identified in accordance with the rules defined in Annex E, "Extending
//PDF".
//SubFilter name (Optional) A name that describes the encoding of the signature value and key
//information in the signature dictionary. A PDF processor may use any handler
//that supports this format to validate the signature.
//(PDF 1.6) The following values for public-key cryptographic signatures should
//be used: adbe.x509.rsa_sha1, adbe.pkcs7.detached, adbe.pkcs7.sha1,
//ETSI.CAdES.detached (PDF 2.0) and ETSI.RFC3161 (PDF 2.0).
//(PDF 2.0) When the Type of this dictionary is DocTimeStamp, the SubFilter
//value should be ETSI.RFC3161 and when the Type of this dictionary is Sig
//(possibly by default) any of the values may be used except ETSI.RFC3161 (see
//12.8.3, "Signature interoperability"). Other values may be defined by
//developers, and when used, shall be prefixed with the registered developer
//identification. All prefix names shall be registered (see Annex E, "Extending
//PDF"). The prefix "adbe" and the prefix "ETSI" have been registered by Adobe
//Systems and ETSI, respectively, and the subfilter names listed above and
//defined in 12.8.3, "Signature interoperability" and 12.8.5, "Document
//timestamp (DTS) dictionary" may be used by any developer.
//The values adbe.x509.rsa_sha1 and adbe.pkcs7.sha1 have been deprecated
//with PDF 2.0. To support backward compatibility, PDF readers should process
//these values for this key, but PDF writers shall not use this value for this key.
//Contents byte
//string
//(Required) The signature value. When ByteRange is present, the value shall
//be a hexadecimal string (see 7.3.4.3, "Hexadecimal strings") representing the
//value of the byte range digest.
//For public-key signatures, Contents should be either a DER-encoded PKCS #1
//binary data object, a DER-encoded CMS binary data object or a DER-encoded
//CMS SignedData binary data object.
//For document timestamp signatures, Contents shall be the TimeStampToken
//as specified in Internet RFC 3161 as updated by Internet RFC 5816. The value
//of the messageImprint field within the TimeStampToken shall be a hash of
//the bytes of the document indicated by the ByteRange and the ByteRange
//shall specify the complete PDF file contents (excepting the Contents value).
//Space for the Contents value shall be allocated before the message digest is
//computed (see 7.3.4,
//"String objects").
//© ISO 2020 – All rights reserved 569
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//570 © ISO 2020 – All rights reserved
//Key Type Value
//Cert byte
//string or
//array
//(Required when SubFilter is adbe.x509.rsa_sha1) An array of byte strings that
//shall represent the X.509 certificate chain used when signing and verifying
//signatures that use public-key cryptography, or a byte string if the chain has
//only one entry. The signing certificate shall appear first in the array; it shall be
//used to verify the signature value in Contents, and the other certificates shall
//be used to verify the authenticity of the signing certificate.
//If SubFilter is adbe.pkcs7.detached or adbe.pkcs7.sha1, this entry shall not be
//used, and the certificate chain shall be put in the CMS envelope in Contents.
//If SubFilter is ETSI.CAdES.detached or ETSI.RFC3161, this entry shall not be
//used, and the certificate chain shall be put in the DER-encoded CMS
//SignedData object in Contents.
//ByteRange array (Required for all signatures that are part of a signature field and usage rights
//signatures referenced from the UR3 entry in the permissions dictionary; shall be
//direct objects) An array of pairs of integers (starting byte offset, length in
//bytes) that shall describe the exact byte range for the digest calculation.
//Multiple discontiguous byte ranges shall be used to describe a digest that does
//not include the signature value (the Contents entry) itself.
//If SubFilter is ETSI.CAdES.detached or ETSI.RFC3161, the ByteRange shall
//cover the entire PDF file, including the signature dictionary but excluding the
//Contents value.
//When a byte range digest is present, all values in the signature dictionary shall
//be direct objects.
//Reference array (Optional; PDF 1.5) An array of signature reference dictionaries (see "Table
//256 — Entries in a signature reference dictionary"). If SubFilter is
//ETSI.RFC3161, this entry shall not be used.
//Changes array (Optional) An array of three integers that shall specify changes to the
//document that have been made between the previous signature and this
//signature: in this order, the number of pages altered, the number of fields
//altered, and the number of fields filled in.
//The ordering of signatures shall be determined by the value of ByteRange.
//Since each signature results in an incremental save, later signatures have a
//greater length value.
//If SubFilter is ETSI.RFC3161, this entry shall not be used.
//Name text string (Optional) The name of the person or authority signing the document. This
//value should be used only when it is not possible to extract the name from the
//signature.
//EXAMPLE 1 From the certificate of the signer.
//If SubFilter is ETSI.RFC3161, this entry should not be used and should be
//ignored by a PDF processor.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 571
//Key Type Value
//M date (Optional) The time of signing. Depending on the signature handler, this may
//be a normal unverified computer time or a time generated in a verifiable way
//from a secure time server.
//This value should be used only when the time of signing is not available in the
//signature. If SubFilter is ETSI.RFC3161, this entry should not be used and
//should be ignored by a PDF processor.
//EXAMPLE 2 A timestamp can be embedded in a CMS binary data object (see
//12.8.3.3, "CMS (PKCS #7) signatures").
//Location text string (Optional) The CPU host name or physical location of the signing. If SubFilter
//is ETSI.RFC3161, this entry should not be used and should be ignored by a PDF
//processor.
//Reason text string (Optional) The reason for the signing, such as ( I agree…). If SubFilter is
//ETSI.RFC3161, this entry should not be used and should be ignored by a PDF
//processor.
//ContactInfo text string (Optional) Information provided by the signer to enable a recipient to contact
//the signer to verify the signature. If SubFilter is ETSI.RFC3161, this entry
//should not be used and should be ignored by a PDF processor.
//EXAMPLE 3 A phone number.
//R integer (Optional; deprecated in PDF 2.0) The version of the signature handler that
//was used to create the signature. (PDF 1.5) This entry shall not be used, and
//the information shall be stored in the Prop_Build dictionary.
//V integer (Optional; PDF 1.5) The version of the signature dictionary format. It
//corresponds to the usage of the signature dictionary in the context of the
//value of SubFilter. The value is 1 if the Reference dictionary shall be
//considered critical to the validation of the signature.
//If SubFilter is ETSI.RFC3161, this V value shall be 0 (possibly by default).
//Default value: 0.
//Prop_Build dictionary (Optional; PDF 1.5) A dictionary that may be used by a signature handler to
//record information that captures the state of the computer environment used
//for signing, such as the name of the handler used to create the signature,
//software build date, version, and operating system.
//The use of this dictionary is defined by Adobe PDF Signature Build Dictionary
//Specification, which provides implementation guidelines.
//Prop_AuthTime integer (Optional; PDF 1.5) The number of seconds since the signer was last
//authenticated, used in claims of signature repudiation. It should be omitted if
//the value is unknown. If SubFilter is ETSI.RFC3161, this entry shall not be
//used.
//Prop_AuthType name (Optional; PDF 1.5) The method that shall be used to authenticate the signer,
//used in claims of signature repudiation. Valid values shall be PIN, Password,
//and Fingerprint. If SubFilter is ETSI.RFC3161, this entry shall not be used.
//NOTE 3 The entries in the signature dictionary can be conceptualized as being in different dictionaries;
//they are in one dictionary for historical and cryptographic reasons. The categories are signature
//properties (R, M, Name, Reason, Location, Prop_Build, Prop_AuthTime, and
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//572 © ISO 2020 – All rights reserved
//Prop_AuthType); key information (Cert and portions of Contents when the signature value is a
//CMS object, CMS object, or a document timestamp token); reference (Reference and
//ByteRange); and signature value (Contents when the signature value is a PKCS #1 object).
//Table 256 — Entries in a signature reference dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary
//describes; if present, shall be SigRef for a signature
//reference dictionary.
//TransformMethod name (Required) The name of the transform method (see 12.8.2,
//"Transform methods") that shall guide the modification
//analysis that takes place when the signature is validated.
//Valid values shall be:
//DocMDP Used to detect modifications to a document
//relative to a signature field that is signed by
//the originator of a document; see 12.8.2.2,
//"DocMDP"
//UR (Deprecated in PDF 2.0) Used to detect
//modifications to a document that would
//invalidate a signature in a rights-enabled
//document; see 12.8.2.3, "UR"
//FieldMDP Used to detect modifications to a list of form
//fields specified in TransformParams; see
//12.8.2.4, "FieldMDP"
//TransformParams dictionary (Optional) A dictionary specifying transform parameters
//(variable data) for the transform method specified by
//TransformMethod. Each method takes its own set of
//parameters. See each of the subclauses specified
//previously for details on the individual transform
//parameter dictionaries.
//Data (various) (Required when TransformMethod is FieldMDP, shall be
//an indirect reference) An indirect reference to the object in
//the document upon which the object modification analysis
//should be performed. For transform methods other than
//FieldMDP, this object is implicitly defined.
//DigestMethod name (Required) A name identifying the algorithm that shall be
//used when computing the digest if not specified in the
//certificate. Valid values are MD5, SHA1 SHA256, SHA384,
//SHA512 and RIPEMD160.
//NOTE (2020) The use of MD5 and SHA1 are deprecated with
//PDF 2.0. The DigestMethod key was also corrected to
//be required as no default value is defined.
//Default value for PDF 1.5-1.7: MD5.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.8.2 Transform methods
//12.8.2.1 General
//Transform methods, along with transform parameters, shall determine which objects are included and
//excluded in revision comparison. The following subclauses discuss the types of transform methods,
//their transform parameters, and when they shall be used.
//12.8.2.2 DocMDP
//12.8.2.2.1 General
//The DocMDP transform method shall be used to detect modifications relative to a signature field that
//is signed by the author of a document (the person applying a certification signature). A document can
//contain only one signature field that contains a DocMDP transform method. It enables the author to
//specify what changes shall be permitted to be made to the document and what changes invalidate the
//author’s signature.
//NOTE As discussed earlier, "MDP" stands for Modification Detection and Prevention. Certification
//signatures that use the DocMDP transform method enable detection of disallowed changes
//specified by the author. In addition, disallowed changes can also be prevented when the
//signature dictionary is referred to by the DocMDP entry in the permissions dictionary (see
//"Table 263 — Entries in a permissions dictionary").
//A certification signature should have a legal attestation dictionary (see 12.8.7, "Legal content
//attestations") that specifies all content that might result in unexpected rendering of the document
//contents, along with the author’s attestation to such content. This dictionary may be used to establish
//an author’s intent if the integrity of the document is questioned.
//The P entry in the DocMDP transform parameters dictionary (see "Table 257 — Entries in the
//DocMDP transform parameters dictionary") shall indicate the author’s specification of which changes
//to the document will invalidate the signature. (These changes to the document shall also be prevented
//if the signature dictionary is referred from the DocMDP entry in the permissions dictionary.) A value
//of 1 for P indicates that the document shall be final; that is, any changes shall invalidate the signature
//with the exception of subsequent DSS (see 12.8.4.3, "Document Security Store (DSS)") and/or
//document timestamp (see 12.8.5, "Document timestamp (DTS) dictionary") incremental updates. The
//values 2 and 3 shall permit modifications that are appropriate for form field or comment workflows as
//well as subsequent DSS and/or document timestamp incremental updates.
//12.8.2.2.2 Validating signatures that use the DocMDP transform method
//To validate a signature that uses the DocMDP transform method, a PDF processor first shall verify the
//byte range digest. Next, it shall verify that any modifications that have been made to the document are
//permitted by the transform parameters.
//Once the byte range digest is validated, the portion of the document specified by the ByteRange entry
//in the signature dictionary (see "Table 255 — Entries in a signature dictionary") is known to
//correspond to the state of the document at the time of signing. Therefore, PDF processors may
//compare the signed and current versions of the document to see whether there have been
//modifications to any objects that are not permitted by the transform parameters.
//© ISO 2020 – All rights reserved 573
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//574 © ISO 2020 – All rights reserved
//Table 257 — Entries in the DocMDP transform parameters dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes; if present,
//shall be TransformParams for a transform parameters dictionary.
//P number (Optional) The access permissions granted for this document. Changes to
//a PDF that are incremental updates which include only the data necessary
//to add DSS’s 12.8.4.3, "Document Security Store (DSS)" and/or document
//timestamps 12.8.5, "Document timestamp (DTS) dictionary" to the
//document shall not be considered as changes to the document as defined
//in the choices below.
//Valid values shall be:
//1 No changes to the document shall be permitted; any change to the
//document shall invalidate the signature.
//2 Permitted changes shall be filling in forms, instantiating page
//templates, and signing; other changes shall invalidate the signature.
//3 Permitted changes shall be the same as for 2, as well as annotation
//creation, deletion, and modification; other changes shall invalidate
//the signature.
//Default value: 2.
//V name (Optional) The DocMDP transform parameters dictionary version. The
//only valid value shall be 1.2.
//NOTE This value is a name object, not a number.
//Default value: 1.2.
//12.8.2.3 UR
//The features described in this subclause are deprecated with PDF 2.0.
//The UR transform method (deprecated in PDF 2.0) shall be used to detect changes to a document that
//shall invalidate a usage rights signature, which is referred to from the UR3 entry in the permissions
//dictionary (see "Table 263 — Entries in a permissions dictionary"). The transform parameters
//dictionary (see "Table 258 — Entries in the UR transform parameters dictionary") specifies the
//additional rights that shall be enabled if the signature is valid. If the signature is invalid because the
//document has been modified in a way that is not permitted or the identity of the signer is not granted
//the extended permissions, additional rights shall not be granted.
//A PDF processor that modifies a PDF, with a UR signature in excess of the rights that are granted by
//that signature, should remove that signature prior to writing the newly modified PDF.
//UR3 (PDF 1.6, deprecated in PDF 2.0): The ByteRange entry in the signature dictionary (see "Table 255
//— Entries in a signature dictionary") shall be present. First, a PDF processor shall verify the byte range
//digest to determine whether the portion of the document specified by ByteRange corresponds to the
//state of the document at the time of signing. Next, a PDF processor shall examine the current version of
//the document to see whether there have been modifications to any objects that are not permitted by
//the transform parameters.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 575
//Table 258 — Entries in the UR transform parameters dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes; if present,
//shall be TransformParams for a transform parameters dictionary.
//Document array (Optional) An array of names specifying additional document-wide usage
//rights for the document. The only defined value shall be FullSave, which
//permits a user to save the document along with modified form and/or
//annotation data. (PDF 1.5) Any usage right that permits the document to
//be modified implicitly shall enable the FullSave right.
//If the PDF document contains a UR3 dictionary, only rights specified by
//the Annots entry that permit the document to be modified shall implicitly
//enable the FullSave right. For all other rights, FullSave shall be explicitly
//enabled in order to save the document. (Signature rights shall permit
//saving as part of the signing process but not otherwise).
//Msg text
//string
//(Optional) A text string that may be used to specify any arbitrary
//information, such as the reason for adding usage rights to the document.
//V name (Optional) The UR transform parameters dictionary version. The value
//shall be 2.2. If an unknown version is present, no rights shall be enabled.
//NOTE This value is a name object, not a number.
//Default value: 2.2.
//Annots array (Optional) An array of names specifying additional annotation-related
//usage rights for the document. Valid names (PDF 1.5) are Create, Delete,
//Modify, Copy, Import, and Export, which shall permit the user to perform
//the named operation on annotations.
//The following names (PDF 1.6) are also permitted (see "Table 263 —
//Entries in a permissions dictionary"):
//Online Permits online commenting; that is, the ability to upload
//or download markup annotations from a server.
//SummaryView Permits a user interface to be shown that summarises the
//comments (markup annotations) in a document.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//576 © ISO 2020 – All rights reserved
//Key Type Value
//Form array (Optional) An array of names specifying additional form-field-related
//usage rights for the document. Valid names (PDF 1.5) are:
//Add Permits the user to add form fields to the document.
//Delete Permits the user to delete form fields to the
//document.
//FillIn Permits the user to save a document on which form
//fill-in has been done.
//Import Permits the user to import form data files in FDF,
//XFDF and text (CSV/TSV) formats.
//Export Permits the user to export form data files as FDF or
//XFDF.
//SubmitStandalone Permits the user to submit form data when the
//document is not open in a Web browser.
//SpawnTemplate Permits new pages to be instantiated from named
//page templates.
//The following names (PDF 1.6) are also valid:
//BarcodePlaintext Permits text form field data to be encoded as a
//plaintext two-dimensional barcode.
//Online Permits the use of forms-specific online mechanisms
//such as SOAP or Active Data Object.
//Signature array (Optional) An array of names specifying additional signature-related
//usage rights for the document. The only defined value shall be Modify,
//which permits a user to apply a digital signature to an existing signature
//form field or clear a signed signature form field.
//EF array (Optional; PDF 1.6) An array of names specifying additional usage rights
//for named embedded files in the document. Valid names shall be Create,
//Delete, Modify, and Import, which shall permit the user to perform the
//named operation on named embedded files.
//P boolean (Optional; PDF 1.6) If false, any possible restriction may be ignored.
//Default value: false.
//12.8.2.4 FieldMDP
//The FieldMDP transform method shall be used to detect changes to the values of a list of form fields.
//The entries in its transform parameters dictionary are listed in "Table 259 — Entries in the FieldMDP
//transform parameters dictionary"
//.
//Table 259 — Entries in the FieldMDP transform parameters dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes; if present,
//shall be TransformParams for a transform parameters dictionary.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//Action name (Required) A name that, along with the Fields array, describes which form
//fields do not permit changes after the signature is applied.
//Valid values shall be:
//All All form fields.
//Include Only those form fields specified in Fields.
//Exclude Only those form fields not specified in Fields.
//Fields array (Required if Action is Include or Exclude) An array of text strings
//containing field names.
//V name (Optional; required for PDF 1.5 and later) The transform parameters
//dictionary version. The value for PDF 1.5 and later shall be 1.2.
//NOTE This value is a name object, not a number.
//Default value: 1.2.
//On behalf of a document author creating a document containing both form fields and signatures the
//following shall be supported by PDF writers:
//• The author specifies that form fields shall be filled in without invalidating the approval or
//certification signature. The P entry of the DocMDP transform parameters dictionary shall be set
//to either 2 or 3 (see "Table 257 — Entries in the DocMDP transform parameters dictionary").
//• The author can also specify that after a specific recipient has signed the document, any
//modifications to specific form fields shall invalidate that recipient’s signature. There shall be a
//separate signature field for each designated recipient, each having an associated signature field
//lock dictionary (see "Table 236 — Entries in a signature field lock dictionary") specifying the form
//fields that shall be locked for that user.
//• When the recipient signs the field, the signature, signature reference, and transform parameters
//dictionaries shall be created. The Action and Fields entries in the transform parameters
//dictionary shall be copied from the corresponding fields in the signature field lock dictionary.
//NOTE This copying is done because all objects in a signature dictionary are direct objects if the
//dictionary contains a byte range signature. Therefore, the transform parameters dictionary
//cannot reference the signature field lock dictionary indirectly.
//FieldMDP signatures shall be validated in a similar manner to DocMDP signatures. See 12.8.2.2.2,
//"Validating signatures that use the DocMDP transform method" for details.
//12.8.3 Signature interoperability
//12.8.3.1 General
//It is intended that PDF processors allow interoperability between signature handlers; that is, a PDF file
//signed with a handler from one vendor should be able to be validated with a handler from a different
//vendor when they use the same set of validation parameters. PDF 2.0 defines new signature formats
//for PAdES signatures (PDF Advanced Electronic Signatures) as defined by ETSI EN 319 142-1 and ETSI
//EN 319 142-2.
//If present, the SubFilter entry in the signature dictionary shall specify the encoding of the signature
//© ISO 2020 – All rights reserved 577
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//578 © ISO 2020 – All rights reserved
//value and key information, while the Filter entry shall specify the preferred handler that should be
//used to validate the signature. When handlers are being registered according to Annex E, "Extending
//PDF" they shall specify the SubFilter encodings they support enabling handlers other than the
//preferred handler to validate the signatures that the preferred handler creates.
//There are several defined values for the SubFilter entry, all based on public-key cryptographic
//standards published by RSA Security and also as part of the standards issued by the Internet
//Engineering Task Force (IETF) Public Key Infrastructure (PKIX) working group and the European
//Telecommunications Standards Institute (ETSI). PDF 2.0 introduced Elliptic Curve Digital Signature
//Algorithm (ECDSA) support as defined by Internet RFC 5480.
//"Table 260 — SubFilter value algorithm support" shows an overview of the SubFilter values along
//with the algorithms that are supported for each SubFilter.
//Table 260 — SubFilter value algorithm support
//SubFilter values adbe.pkcs7.detached,
//ETSI.CAdES.detached or
//ETSI.RFC3161
//adbe.pkcs7.sha1c adbe.x509.rsa_sha1a
//Message Digest SHA1 (PDF 1.3) d
//SHA256 (PDF 1.6)
//SHA384 (PDF 1.7)
//SHA512 (PDF 1.7)
//RIPEMD160 (PDF 1.7)
//SHA1 (PDF 1.3)b SHA1 (PDF 1.3)
//SHA256 (PDF 1.6)
//SHA384 (PDF 1.7)
//SHA512 (PDF 1.7)
//RIPEMD160 (PDF 1.7)
//RSA Algorithm Support Up to 1024-bit (PDF 1.3)
//Up to 2048-bit (PDF 1.5)
//Up to 4096-bit (PDF 1.5)
//See adbe.pkcs7.detached See adbe.pkcs7.detached
//DSA Algorithm Support Up to 4096-bits (PDF 1.6) See adbe.pkcs7.detached No
//ECDSA Algorithm Support
//(defined by Internet RFC
//5480)
//ANSI X9.62, Elliptic Curve
//Digital Signature Algorithm
//(ECDSA) (PDF 2.0)
//No No
//a Despite the appearance of sha1 in the name of this SubFilter value, supported encodings shall not be limited
//to the SHA-1 algorithm. The PKCS #1 object contains an identifier that indicates which algorithm shall be used.
//b Other digest algorithms may be used to digest the signed-data field; however, SHA-1 shall be used to digest
//the data that is being signed.
//c The values adbe.x509.rsa_sha1 and adbe.pkcs7.sha1 have been deprecated with PDF 2.0.
//d SHA1 has been deprecated with PDF 2.0.
//12.8.3.2 PKCS #1 signatures
//The PKCS #1 standard supports several public-key cryptographic algorithms and digest methods,
//including RSA encryption, DSA signatures, and SHA-1 and MD5 digests. For signing PDF files using
//PKCS #1, the only value of SubFilter that should be used is adbe.x509.rsa_sha1, which uses the RSA
//encryption algorithm and SHA-1 digest method. The certificate chain of the signer shall be stored in the
//Cert entry. PKCS #1 signatures are deprecated with PDF 2.0.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.8.3.3 CMS (PKCS #7) signatures
//12.8.3.3.1 General
//When CMS signatures are used, the value of Contents shall be a DER-encoded CMS binary data object
//containing the signature.
//For byte range signatures, Contents shall be a hexadecimal string with "<" and ">" delimiters. It shall
//fit precisely in the space between the ranges specified by ByteRange. Since the length of CMS objects is
//not entirely predictable, the value of Contents shall be padded with zeros at the end of the string
//(before the ">" delimiter) before writing the CMS to the allocated space in the PDF file.
//The CMS object shall conform to Internet RFC 5652. Different SubFilter values may be used and shall
//be registered in accordance with Annex E, "Extending PDF". SubFilter shall take one of the following
//values:
//• adbe.pkcs7.detached: The original signed message digest over the document’s byte range shall be
//incorporated as the normal CMS SignedData field. No data shall be encapsulated in the CMS
//SignedData field.
//• adbe.pkcs7.sha1: The SHA-1 digest of the document’s byte range shall be encapsulated in the CMS
//SignedData field with ContentInfo of type Data. The digest of that SignedData shall be
//incorporated as the normal CMS digest. The value adbe.pkcs7.sha1 for the SubFilter key has been
//deprecated with PDF 2.0. To support backward compatibility, PDF readers should process this
//value for this key, but PDF writers shall not use this value.
//At minimum the CMS object shall include the signer’s X.509 signing certificate. This certificate shall be
//used to verify the signature value in Contents.
//If the signature handler has on-line access, it may place into the CMS object time stamping information
//and/or revocation information.
//NOTE Since PDF 2.0 supports two additional dictionaries, i.e. the DSS and the DTS dictionaries,
//revocation information can be better placed in a DSS dictionary while time-stamping information
//can also be placed in a DTS dictionary, in addition to being placed in the CMS object.
//In such a case, the CMS object should contain the following:
//• Timestamp information as an unsigned attribute (PDF 1.6): The timestamp token shall conform to
//Internet RFC 3161 as updated by Internet RFC 5816, and shall be computed and embedded into the
//CMS object as described in Appendix A of Internet RFC 3161 as updated by Internet RFC 5816. The
//specific treatment of this timestamp tokens and its processing is left to the particular signature
//handlers to define.
//• Revocation information as a signed attribute (PDF 1.6): This attribute may include all the
//revocation information that is necessary to carry out revocation checks for the signer's certificate
//and its issuer certificates. Since revocation information is a signed attribute, it shall be obtained
//before the computation of the digital signature. This means that the software used by the signer
//should be able to construct the certification path and the associated revocation information. If one
//of the elements cannot be obtained (e.g. no connection is possible), a signature with this attribute
//will not be possible.
//• The signature handler should capture the chain of certificates, including the signer certificate,
//along with the other certificates in the certificate chain, before signing. The signature handler
//should validate the certificate's chain before signing. However, if this is not possible, the DSS (see
//© ISO 2020 – All rights reserved 579
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.8.4.3, "Document Security Store (DSS)") may be used for adding the information as an
//incremental update. This differs from the treatment when using adbe.x509.rsa_sha1 when the
//certificates shall be placed in the Cert key of the signature dictionary as defined in "Table 260 —
//SubFilter value algorithm support"
//.
//• One or more Internet RFC 5755 attribute certificates associated with the signer certificate (PDF
//1.7). The specific treatment of attribute certificates and their processing is left to the particular
//signature handlers to define.
//The policy of how to establish trusted identity lists to validate embedded certificates is up to the
//validation signature handler.
//12.8.3.3.2 Revocation of CMS-based signatures
//For signatures with a SubFilter value other than ETSI.CAdES.detached, the following rules apply.
//The adbe Revocation Information attribute object identifier is specified as follows using ASN.1
//notation:
//adbe-revocationInfoArchival OBJECT IDENTIFIER::=
//{adbe(1.2.840.113583) acrobat(1) security(1) 8}
//The value of the revocation information attribute may include any of the following data types:
//• Certificate Revocation Lists (CRLs), described in Internet RFC 5280.
//NOTE CRLs can be large and therefore require more pre-allocated space in the value of the Contents
//key.
//• Online Certificate Status Protocol (OCSP) Responses, described in Internet RFC 6960. These are
//generally small and should be the data type included in the CMS object.
//• Custom revocation information: The format is not prescribed by this specification, other than that
//it be encoded as an OCTET STRING. The application should be able to determine the type of data
//contained within the OCTET STRING by looking at the associated OBJECT IDENTIFIER.
//The ASN.1 type of adbe's Revocation Information attribute value is RevocationInfoArchival defined as
//follows using ASN.1 notation:
//RevocationInfoArchival::= SEQUENCE {
//crl [0] EXPLICIT SEQUENCE of CRLs, OPTIONAL
//ocsp [1] EXPLICIT SEQUENCE of OCSPResponse, OPTIONAL
//otherRevInfo [2] EXPLICIT SEQUENCE of OtherRevInfo, OPTIONAL
//OtherRevInfo::= SEQUENCE {Type OBJECT IDENTIFIER
//Value OCTET STRING
//}
//}
//12.8.3.4 CAdES signatures as used in PDF
//12.8.3.4.1 General
//The Cryptographic Message Syntax (CMS)(see Internet RFC 5652) is used by CAdES signatures. The
//PDF signatures using the SubFilter value ETSI.CAdES.detached are referred to as PAdES signatures and
//they follow one of two CMS profiles created to be compatible with the corresponding CAdES profiles
//defined in ETSI EN 319 122. Combined with 12.8.4, "Long term validation of signatures" and 12.8.5,
//"Document timestamp (DTS) dictionary" as described in ETSI EN 319 142-1 (PAdES), compatibility
//with additional CAdES profiles can be achieved.
//580 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.8.3.4.2 Signature dictionary for PAdES signatures
//When the SubFilter value is ETSI.CAdES.detached, the value of Contents shall be a DER-encoded CMS
//SignedData binary data object containing the signature. The signature dictionary shall follow the
//specification given in 12.7.5.5, "Signature fields" with the following additional restrictions/constraints:
//• The ByteRange shall cover the entire PDF file, including the signature dictionary but excluding
//the Contents entry.
//• The signature dictionary shall not contain a Cert entry.
//• Either the time of signing may be indicated by the value of the M entry in the signature dictionary
//or the signing-time attribute may be used, but not both.
//12.8.3.4.3 Attributes for PAdES signatures
//The attributes in the SignedData object used as the value of the signature dictionary Contents key shall
//obey the following rules:
//a) content-type: shall be present and shall always have the value "id-data"
//.
//b) Signature timestamp: A timestamp from a trusted timestamp server should be present as a unsigned
//attribute. The timestamp should be applied on the digital signature immediately after the signature is
//created so the timestamp specifies a time as close as possible to the time at which the document was
//signed. The rules from clause 5.3 in ETSI EN 319 122-1 shall apply.
//c) content timestamp: may be present. If the content timestamp attribute is present, it shall be used in the
//same way as defined in clause 5.2.8 in ETSI EN 319 122-1.
//d) exactly one single SignerInfo attribute shall be present.
//e) message-digest: shall be present and shall be used as defined in CMS (Internet RFC 5652).
//f) signing-certificate or signing-certificate-v2: shall be used as a signed attribute as described in the ESS
//signing-certificate attribute or as described in the ESS signing-certificate-v2 attribute as defined in clause
//5.2.2 in ETSI EN 319 122-1. The details of the signing certificate attribute are defined in Internet RFC
//5035.
//g) signing-time: may be present. If present, it contains a UTC time. If the signing-time attribute is present,
//the time of signing shall not be indicated by the value of the M entry in the signature dictionary.
//h) signer-location, as defined in clause 5.2.5 in ETSI EN 319 122-1, may be present. In such a case, the
//Location entry in the signature dictionary shall not be present.
//i) these attributes shall not be used: counter-signature, content-reference, content-identifier, and content-
//hints.
//j) signer-attributes-v2: may be used and shall follow the definition given in clause 5.2.6.1 of ETSI EN 319
//122-1.
//k) Unsigned signature attributes not explicitly noted here may be ignored.
//12.8.3.4.4 Profiles of ETSI.CAdES.detached
//The signatures using the SubFilter value ETSI.CAdES.detached may follow one of two profiles denoted
//as PAdES-E-BES (Basic Electronic Signature) and PAdES-E-EPES (Explicit Policy Electronic Signature).
//These are defined to be compatible with the corresponding profiles defined in ETSI EN 319 122-2 (i.e.,
//CAdES-E-BES and CAdES-E-EPES, respectively). These two CMS profiles are also denoted as PAdES-E-
//BES (Basic Electronic Signature) and PAdES-E-PES (Explicit Policy Electronic Signature) in ETSI EN
//319 142-2. If discrepancies exist between this document and those of ETSI, this document shall prevail.
//© ISO 2020 – All rights reserved 581
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//The following attributes may be present within the CMS SignedData object depending on the profile
//employed:
//For both the PAdES-E-BES and the PAdES-E-PES profiles:
//• If a commitment-type-indication attribute is present, a Reason entry shall not be used
//• If a commitment-type-indication attribute is not present, a Reason entry may be used
//NOTE 2 The commitment-type-indication attribute contains an OID, whereas the entry Reason of the
//signature dictionary contains a text string which is language dependent.
//For the PAdES-E-EPES profile,
//• a signature-policy-identifier shall be present as a signed attribute. The rules from clause 5.2.9 in
//CAdES (ETSI EN 319 122-1) shall apply. The parameters of the signature policy shall take
//precedence over the seed values defined in 12.7.5.5, "Signature fields". Conforming signature
//handlers should enforce seed value constraints at signing time, if not overridden, and should
//enforce signature policies constraints at signing time when possible. During validation
//conforming signature handlers should not enforce seed values constraints, if present, but shall
//enforce signature policy constraints.
//NOTE 3 It is important not to confuse the EPES defined attribute parameters with the "seed values"
//defined in clause 12.7.5.5, "Signature fields". While both bear similarities, seed values are
//workflow constraints for a given document, whereas signature policies represent general
//endorsement rules agreed upon by the signer and the verifier.
//Further CAdES-T compatible capabilities may be provided after the time of the signature using one of
//the following methods:
//• with the addition, by the signer, of a timestamp attribute within its signature when sufficient
//space has been prepared for it (see ETSI EN 319 122).
//• with the addition, by the verifier, of a timestamp token that applies to the PDF document as a
//whole (see 12.8.5, "Document timestamp (DTS) dictionary").
//In both cases, this demonstrates that the signer’s signature was created before the UTC time contained
//in the timestamp token.
//All signed attributes shall be checked for proper values by signature validation software.
//12.8.3.4.5 Requirements for validation of PAdES signatures
//For all profiles of PAdES signatures covered in this document (i.e., those with a SubFilter value of
//ETSI.CAdES.detached), when the user opens a signed document or requests verification of these
//signatures present in the PDF, a PDF processor, as the verifier, shall perform the following steps to
//verify them:
//a) A signature handler shall compare the hash value of the signer's certificate, with the hash value
//given in the signing-certificate attribute or the signing-certificate-v2 attribute. If the hashes do not
//match, then the signature is considered invalid. The signature handler shall use the public key
//contained in the signer's certificate to verify that the document digest found in the signature is
//correctly signed. If this is not the case, then the signature is considered invalid.
//b) The signature handler shall validate the path of certificates used to verify the binding between the
//subject distinguished name and subject public key as specified in Internet RFC 5280 clause 6, using
//a set of validation parameters. The signature may be verified against a time other than the current
//582 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//time if all validation information (e.g. certificates and revocation information) is known to have
//existed at that time (e.g. using DSS (see 12.8.4.3, "Document Security Store (DSS)"); using
//document timestamps, (see 12.8.5, "Document timestamp (DTS) dictionary"); or a signature
//timestamp is present in the signature as an unsigned attribute (see 12.8.3.4.3,
//"Attributes for
//PAdES signatures")). Otherwise, the local current time converted into the UTC shall be used.
//NOTE The claimed signing time specified by the signature dictionary value with the key M is not a
//trusted indication of the signing time.
//c) When the signer's signature is verified against a time indicated in a timestamp token present in a
//Document timestamp dictionary, then the signature handler shall also validate the path of
//certificates used to verify the timestamp unit's certificate, as specified in Internet RFC 5280 clause
//6, using a set of validation parameters which may be different from the previous one.
//d) The revocation status of the certification path shall be checked as specified in 12.8.3.4.6, "Signature
//revocation checking model for PAdES signatures"
//.
//12.8.3.4.6 Signature revocation checking model for PAdES signatures
//A signature handler shall use either, or both, of the following methods to check the revocation status of
//every certificate belonging to a certification path:
//• Certificate Revocation Lists (CRLs) obtained from Certification Authorities (CAs) or CRL Issuers
//that are identified using a set of validation parameters. Using a CRL, the certificate in question
//shall be checked against a list of revoked certificates.
//NOTE 1 In addition to the certificate issue date and the issuing entities, the CRL specifies revoked
//certificates and can also specify the reasons for revocation. Each CRL also contains a date at the
//latest for the next release.
//• Online Certificate Status Protocol (OCSP) responses for obtaining the revocation status of a given
//certificate from trusted network servers that are identified using a set of validation parameters.
//For the verification of a signer's signature at a time located before the expiry of the signer's certificate,
//two cases need to be considered:
//1. the current UTC time, or
//2. a UTC time in the past, when a timestamp token is present as an unsigned attribute of this
//signature or of the signature which covers this signature or of the document timestamp which
//covers this signature.
//NOTE 2 For a verification of a signer's signature after the expiry of the signer's certificate, see 12.8.4,
//"Long term validation of signatures"
//.
//12.8.3.4.7 Revocation checking PAdES signatures at the current time
//When the signer's signature is verified at the current UTC time, such verification shall be done before
//the expiry of the signer's certificate. The revocation of each certificate from the certification path of the
//signer's certificate shall be checked.
//When CRLs are being used, a CRL is appropriate only if the current UTC time is included within the
//time period delimited by the thisUpdate and the nextUpdate fields of the CRL being used.
//When OCSP responses are being used, an OCSP response is appropriate only if it has been captured
//before the expiry of the signer's certificate.
//© ISO 2020 – All rights reserved 583
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//NOTE Such checking is adequate for a data origin authentication service but not for a non-repudiation
//service, since after a successful validation done at one time, another validation done at a later
//time will provide a validation failure if one of the certificates from the certification path happens
//to be subsequently revoked.
//12.8.3.4.8 Revocation checking PAdES signatures at a time in the past
//When a timestamp token is already present in the CAdES signature as a signature timestamp attribute
//(it is an unsigned attribute), the signer's signature shall be verified at the UTC time in the past
//indicated in that token. The revocation status of each certificate from the certification path of the
//signer's certificate shall be checked at that UTC time, as well as the revocation status of each certificate
//from the certification path of the timestamping unit's certificate.
//NOTE When there is no valid timestamp token present in the CAdES signature, revocation checking at
//a time in the past is addressed in 12.8.5, "Document timestamp (DTS) dictionary"
//.
//When CRLs are being used, a CRL is appropriate only if the two following conditions apply:
//• the CRL has been captured before the expiry of the signer's certificate, and
//• the time indicated in the nextUpdate field from the CRL is located after the UTC time in the past.
//When OCSP responses are being used, an OCSP response is appropriate only if the two following
//conditions apply:
//• the OCSP response has been captured before the expiry of the signer's certificate, and
//• the time indicated in the producedAt field from the OCSP response is located after the UTC time in
//the past.
//The following explanations only apply when the certificate of the timestamping unit that has produced
//the timestamp token has not yet expired at the time of the verification. The scenario when it has
//expired is addressed in 12.8.5.3, "Subsequent document timestamp dictionaries"
//.
//The reason for the revocation of a timestamping certificate and of every CA certificate belonging to the
//certification path shall be indicated either in the CRLs or in the OCSP responses that are being used.
//The revocation status of each certificate of the certification path of the timestamping unit's certificate
//shall be checked at the current UTC time (i.e. not at a time in the past):
//• If no certificate has been revoked, then the UTC time included in the timestamp token can be
//considered as reliable.
//• If a certificate has been revoked for a reason which is either "keyCompromise" or
//"cACompromise" or if the revocation reason is missing, then the UTC time included in the
//timestamp token cannot be considered as reliable and the time indicated in the timestamp token
//cannot be used. The benefits of the timestamp token are then lost and revocation checking should
//thus be done at the current time (see 12.8.3.4.6,
//"Signature revocation checking model for PAdES
//signatures").
//• If a certificate has been revoked for any other reason than "keyCompromise" or "cACompromise"
//,
//then the UTC time included in the timestamp token can be considered as reliable (and is thus
//usable) only if the time of the revocation of that timestamping unit's certificate occurred after the
//UTC time included in the timestamp token. Otherwise, revocation checking should be done at the
//current time (see 12.8.3.4.6,
//"Signature revocation checking model for PAdES signatures").
//584 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.8.4 Long term validation of signatures
//12.8.4.1 General
//Long term validation (LTV) of signatures is achieved by using two types of dictionaries:
//• document security store (DSS) dictionaries, and
//• document timestamp dictionaries (DTS) (see 12.8.5, "Document timestamp (DTS) dictionary").
//12.8.4.2 Introduction to the document security store (DSS)
//A PDF signature may not be successfully verified unless its collateral validation components are
//preserved, e.g., certificates, CRLs, timestamp tokens, revocation lists, and OCSP responses. To facilitate
//long term signature validation, PDF supports the ability to collect validation information to verify a
//signature at a later time if it has been verified once as being valid. Some of this information, i.e.
//certificates, CRLs and OCSP responses, when not already present in the signature, shall be stored in a
//document security store (DSS), see 12.8.4.3, "Document Security Store (DSS)"
//. This will provide the
//information needed to verify a signature as this was done when that signature was first verified.
//Without an authoritative timestamp token, a signature handler is not able to verify a signature at a date
//in the past to get the same validation result.
//To allow this verification, one of the following is required:
//• a signature timestamp attribute (which contains a timestamp token), or
//• a timestamp token that applies to the PDF document as a whole (see 12.8.5, "Document
//timestamp (DTS) dictionary").
//When that timestamp token is already present in the CAdES signature (see 12.8.3.4.7, "Revocation
//checking PAdES signatures at the current time") and if that timestamp token is valid, then the UTC time
//included in that timestamp token shall be used as the time reference to check the revocation status of
//the signer's certificate and of all the intermediate CA certificates, up to a trusted root. Afterwards, the
//DSS dictionary shall be used to collect the certificates, CRLs and OCSP responses that are relevant to
//validate that signature.
//When there is no valid timestamp token present in the CAdES signature, or when such a timestamp
//token is present but is considered as invalid, the DSS dictionary shall be used to collect the certificates,
//CRLs and OCSP responses that are relevant to validate that signature and afterwards a timestamp
//token that applies to the PDF document as a whole shall be used and placed in a Document timestamp
//dictionary (DTS) as noted in 12.8.5, "Document timestamp (DTS) dictionary").
//A timestamp token is itself signed. The case where the certificate of the timestamping unit which has
//issued that timestamp token has expired is addressed in 12.8.5.3, "Subsequent document timestamp
//dictionaries"
//.
//A timestamp token is itself signed, and so it is possible for the timestamp token's own validation data
//also to be preserved. As with signatures from the signer(s) of the document, a DSS dictionary may also
//include signature validation data relating to the timestamp token contained in a signature-timestamp
//attribute or to document timestamps, see 12.8.5, "Document timestamp (DTS) dictionary").
//The DSS supports the ability to add this critical information after the signed document has been
//created and before this information is no longer available. At the time of signing, all of the collateral
//© ISO 2020 – All rights reserved 585
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//586 © ISO 2020 – All rights reserved
//validation components may not be available for various reasons including the inability to connect to
//remote servers that provide them (e.g. the user is offline) or the inability of the signer to bear the
//financial or time costs associated with obtaining these components. Also, in many workflows it is the
//recipient of a signed PDF document who is interested in a long term validation of the signatures and
//not the signer of the document.
//The relevant validation data for each signature may be identified from the security store using a VRI
//dictionary (see 12.8.4.4, "Validation-related information (VRI)") for optimisation or to remove
//ambiguity of the validation data used to validate a specific signature.
//NOTE A benefit of using a DSS dictionary is that those components which are common to several
//signatures (e.g. certificates and revocation lists) can be stored in this dictionary once and
//referenced where ever they are needed. This can greatly reduce the size of a PDF document that
//contains several signatures.
//12.8.4.3 Document Security Store (DSS)
//The document security store (DSS), when present, shall be a dictionary that shall be the value of a DSS
//key in the document catalog dictionary (see 7.7.2, "Document catalog dictionary"). This dictionary may
//contain:
//• an array of all certificates used for the signatures, including timestamp signatures, that occur in
//the document. It shall also hold all the auxiliary certificates required to validate the certificates
//participating in certificate chain validations.
//• an array of all Certificate Revocation Lists (CRL) (see Internet RFC 5280) used for some of the
//signatures, and
//• an array of all Certificate Status Protocol (OCSP) responses (see Internet RFC 6960) used for some
//of the signatures.
//• a VRI key whose value shall be a dictionary containing one VRI dictionary (validation-related
//information) for each signature represented in CMS format.
//Any VRI dictionaries, if present, shall be located in document incremental update sections. If the
//signature dictionary to which a VRI dictionary applies is itself in an incremental update section, the
//DSS/VRI update shall be done later than the signature update. The inclusion of VRI dictionary entries
//is optional. All validation material referenced in VRI entries is included in DSS entries too.
//“Table 261 — Entries in the document security store (DSS) dictionary” shows the entries in the DSS
//dictionary.
//Table 261 — Entries in the document security store (DSS) dictionary
//Key Type Value
//Type name (Optional) If present, shall be DSS for a document security store
//dictionary.
//VRI dictionary (Optional) This dictionary contains Signature VRI dictionaries (see
//12.8.4.4, "Validation-related information (VRI)"). The key of each entry in
//this dictionary is the base-16-encoded (uppercase) SHA-1 digest of the
//signature to which it appliesa and the value is the Signature VRI dictionary
//which contains the validation-related information for that signature.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 587
//Key Type Value
//Certs array (Optional) An array of indirect reference to streams, each containing one
//DER-encoded X.509 certificate (see Internet RFC 5280). This array
//contains certificates that may be used in the validation of any signatures
//in the document.
//OCSPs array (Optional) An array of indirect references to streams, each containing a
//DER-encoded Online Certificate Status Protocol (OCSP) response (see
//Internet RFC 6960). This array contains OCSPs that may be used in the
//validation of the signatures in the document.
//CRLs array (Optional) An array of indirect references to streams, each containing a
//DER-encoded Certificate Revocation List (CRL) (see Internet RFC 5280).
//This array contains CRLs that may be used in the validation of the
//signatures in the document.
//a For a document signature or document timestamp signatures, the bytes that are hashed are those
//of the complete hexadecimal string, including zero padding, in the Contents entry of the associated
//signature dictionary, containing the signature's DER-encoded binary data object (e.g. CMS or CAdES
//objects).
//For the signatures of CRLs and OCSP responses, the bytes that are hashed are the respective signature
//object represented as a BER-encoded OCTET STRING encoded with primitive encoding.
//12.8.4.4 Validation-related information (VRI)
//A signature VRI dictionary shall contain validation-related information (VRI) for one signature in the
//document that a given signature handler or PDF processor has used to successfully validate the given
//signature. A signature VRI dictionary shall reference:
//• a selection of certificates (Cert) from the certificates list (Certs) in the DSS dictionary applicable to
//this signature;
//• a selection of CRLs from the CRL list in the DSS dictionary applicable to this signature, if any;
//• a selection of OCSP responses from the OCSP response list in the DSS dictionary applicable to
//this signature.
//If any of the Cert, CRL or OCSP arrays is empty that entry in the dictionary shall be omitted.
//A VRI dictionary may also contain the time at which the data placed in the VRI dictionary was created
//or/and a timestamp token which contains the UTC time at which the VRI dictionary was created.
//A signature VRI dictionary shall not be used to record the information used in an unsuccessful
//validation attempt. “Table 262 — Entries in the signature validation-related information (VRI)
//dictionary” shows the entries in the VRI dictionary.
//Table 262 — Entries in the signature validation-related information (VRI) dictionary
//Key Type Value
//Type name (Optional) If present, shall be VRI for a validation-related information
//dictionary.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//588 © ISO 2020 – All rights reserved
//Key Type Value
//Cert array (Optional) An array of (indirect references to) streams, each containing one
//DER-encoded X.509 certificate (see Internet RFC 5280). This array contains
//certificates that were used in the validation of this signature.
//CRL array (Required, if a CRL is present) An array of indirect references to streams that are
//all CRLs used to determine the validity of the certificates in the chains related to
//this signature. Each stream shall reference a CRL that is an entry in the CRLs
//array in the DSS dictionary.
//OCSP array (Required, if an OCSP is present) An array of indirect references to streams that
//are all OCSPs used to determine the validity of the certificates in the chains
//related to this signature. Each stream shall reference an OCSP that is an entry in
//the OCSPs array in the DSS dictionary.
//TU date (Optional) The date/time at which this signature VRI dictionary was created. TU
//shall be a date string as defined in 7.9.4, "Dates"
//.
//TS stream (Optional) A stream containing the DER-encoded timestamp (see Internet RFC
//3161 as updated by Internet RFC 5816) that contains the date/time at which this
//signature VRI dictionary was created.
//NOTE 1 The date/time contained in the timestamp token can be used for audit
//purposes.
//NOTE 2 The hash value to be contained in the timestamp token is left undefined. For
//PKCS #7 signatures the datum that is hashed and included in the
//messageImprint field of the DER encoded timestamp stored in the TS entry
//(see Internet RFC 3161 as updated by Internet RFC 5816) is the
//encryptedDigest field in the signature's PKC S#7 object (as defined in Internet
//RFC 2315).
//EXAMPLE 1 DSS dictionary (and associated objects)
//100 0 obj
//<<
///Type /Catalog
///DSS 101 0 R
//… other stuff here …
//>>
//endobj
//101 0 obj
//<<
///VRI 102 0 R
///OCSPs [103 0 R]
///CRLs [104 0 R]
///Certs [105 0 R 106 0 R]
//>>
//endobj
//102 0 obj
//<<
///4B783B9A6D0D69E4E881BFDF080835E896735416 <</OCSP [103 0 R] /CRL [104 0 R]>>
//>>
//endobj
//103 0 obj
//<<
///Length … %whatever the length of the stream is
//>>
//stream
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//… OCSP data goes here …
//endstream
//104 0 obj
//<<
//>>
//stream
//… %CRL data goes here …
//endstream
///Length … %whatever the length of the stream is
//105 0 obj
//<<
//>>
//stream
//… Certificate data goes here …
//endstream
//106 0 obj
//<<
//>>
//stream
//… Certificate data goes here …
//endstream
//EXAMPLE 2 DSS sample with Two Signatures
///Length … %whatever the length of the stream is
///Length … %whatever the length of the stream is
//101 0 obj
//<<
///VRI 102 0 R
///OCSPs [103 0 R 107 0 R]
///CRLs [104 0 R]
///Certs [105 0 R 106 0 R]
//>>
//endobj
//102 0 obj
//<<
///4B783B9A6D0D69E4E881BFDF080835E896735416 <</OCSP [103 0 R] /CRL [104 0 R]>>
///123456789ABCDEF987654321FEDCBA1234567890 <</OCSP [107 0 R]>>
//>>
//107 0 obj
//<<
//>>
//stream
//… OCSP data goes here …
//endstream
//12.8.4.5 Usage of the DSS VRI
///Length … %whatever the length of the stream is
//The validation data contained in the DSS dictionary and those embedded in the signature itself may be
//used by another party later relying on the signature. The applicability of the validation data in the
//signature VRI dictionary is subject to external conditions such as a set of validation parameters. In the
//presence of DSS in a PDF document the preferred order of the search for validation data should be as
//follows:
//© ISO 2020 – All rights reserved 589
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//a) Validation data referenced in the VRI dictionary
//b) Validation data in DSS
//c) Validation data embedded in the signature.
//12.8.5 Document timestamp (DTS) dictionary
//12.8.5.1 General
//A document timestamp dictionary establishes the exact contents of the complete PDF file at the time
//indicated in the timestamp token.
//12.8.5.2 Initial document timestamp dictionary
//The timestamp token shall be an Internet RFC 3161 TimeStampToken, as updated by Internet RFC 5816,
//obtained from a trusted timestamp authority. A Document Timestamp dictionary is a standard
//signature dictionary as described in "Table 255 — Entries in a signature dictionary"
//.
//The ByteRange key shall cover the entire PDF file, including the signature dictionary but excluding the
//Contents value. The hash value computed over that byte range shall be sent to a timestamping
//authority and the TimeStampToken which is received shall be placed in the Contents key.
//The existence of one or more document timestamps shall be determined by examining signature fields
//(see 12.7.5.5, "Signature fields"). A document level timestamp is treated as a digital signature in most
//respects. It normally would not have any visual appearance within the document content.
//NOTE When a document level timestamp is validated, using the same procedures as for other
//signatures using its own set of validation parameters, one can determine that the contents of the
//document have not been changed since a given past date.
//12.8.5.3 Subsequent document timestamp dictionaries
//A timestamp token present either in a signature timestamp attribute or in a document timestamp
//dictionary may expire due to the expiry of its certificate or the cryptographic strength of some of their
//algorithms may not be resistant any longer to some new cryptographic attack.
//It is thus necessary to apply a new timestamp token before the expiry of the certificate and/or before a
//cryptographic attack may succeed but it is also necessary to be able to demonstrate that the certificates
//related to the certification path of the timestamp authority certificate were not revoked for a reason
//which is either "keyCompromise" or "cACompromise" at the time when the new timestamp token has
//been applied to the document.
//The certificates, CRLs or OCSP responses used to demonstrate that the certificates related to the
//certification path of the previous timestamp token was not revoked for a reason which is either
//"keyCompromise" or "cACompromise" just before the time the new timestamp token has been
//requested shall be included into the DSS dictionary.
//Then the new timestamp token shall be placed into a new document timestamp dictionary which will
//protect the whole structure.
//590 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//The process may be repeated several times as long as there is a need to reverify the signatures
//included in the document. “Figure 86 — Illustration of a PDF document with repeated LTV” illustrates
//a PDF document with repeated LTV.
//Figure 86 — Illustration of a PDF document with repeated LTV
//When evaluating the DocMDP restrictions (see 12.8.2.2, "DocMDP") the presence of a document
//timestamp and/or DSS information shall be ignored.
//EXAMPLE Document timestamp
//1 0 obj
//<<
///Type /Catalog /Pages 2 0 R
///AcroForm 5 0 R
//>>
//endobj
//2 0 obj
//<<
///Kids [3 0 R]
///Count 1
///Type /Pages
//>>
//endobj
//3 0 obj
//<<
///Type /Page
///Parent 2 0 R
//© ISO 2020 – All rights reserved 591
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
///MediaBox [0 0 612 792]
///Annots 4 0 R
//… other keys go here …
//>>
//endobj
//4 0 obj
//<<
///Type /Annot /Subtype /Widget
///Rect [0 0 0 0]
///F 4 /P 3 0 R
///FT /Sig /T (Sig)
///V 6 0 R
//>>
//endobj
//5 0 obj
//<<
///Fields [4 0 R]
///SigFlags 3
//>>
//endobj
//6 0 obj
//<<
///Type /DocTimeStamp
///Filter /Adobe.PPKLite
///SubFilter /ETSI.RFC3161
///Contents <00000> %values go here inside of <>
///ByteRange [0 0 0 0] %values go here inside of []
//>>
//endobj
//12.8.6 Permissions
//The Perms entry in the document catalog dictionary (see "Table 29 — Entries in the catalog
//dictionary") shall specify a permissions dictionary (PDF 1.5). Each entry in this dictionary (see "Table
//263 — Entries in a permissions dictionary" for the currently defined entries) shall specify the name of
//a permission handler that controls access permissions for the document. These permissions are similar
//to those defined by security handlers (see "Table 22 — Standard security handler user access
//permissions") but do not require that the document be encrypted. For a permission to be actually
//granted for a document, it shall be allowed by each permission handler that is present in the
//permissions dictionary as well as by the security handler.
//NOTE An example of a permission is the ability to fill in a form field.
//592 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 263 — Entries in a permissions dictionary
//Key Type Value
//DocMDP dictionary (Optional) An indirect reference to a signature dictionary (see "Table
//255 — Entries in a signature dictionary"). This dictionary shall contain a
//Reference entry that shall be a signature reference dictionary (see
//"Table 255 — Entries in a signature dictionary") that has a DocMDP
//transform method (see 12.8.2.2, "DocMDP") and corresponding
//transform parameters.
//If this entry is present, PDF processors shall enforce the permissions
//specified by the P entry in the DocMDP transform parameters
//dictionary and shall also validate the corresponding signature based on
//whether any of these permissions have been violated.
//UR3 dictionary (Optional; deprecated in PDF 2.0) A signature dictionary that may be
//used to specify and validate additional capabilities (usage rights)
//granted for this document; that is, the enabling of features of a PDF
//processor that are not available by default.
//The signature dictionary shall contain a Reference entry that shall be a
//signature reference dictionary that has a UR transform method (see
//12.8.2.3, "UR"). The transform parameter dictionary for this method
//indicates which additional permissions shall be granted for the
//document. If the signature is valid and recognized by the PDF processor,
//then the PDF processor shall allow the specified permissions for the
//document, in addition to the default permissions.
//NOTE For example, a PDF processor may not permit saving documents by
//default. The signature can be used to validate that the additional
//permissions placed within the PDF document have been granted by
//the authority or agent that did the signing.
//12.8.7 Legal content attestations
//The PDF language provides a number of capabilities that can make the rendered appearance of a PDF
//document vary. These capabilities could potentially be used to construct a document that misleads the
//recipient of a document, intentionally or unintentionally. These situations are relevant when
//considering the legal implications of a signed PDF document.
//PDF provides a mechanism by which a document recipient can determine whether the document can
//be trusted. The primary method is to accept only documents that contain certification signatures (one
//that has a DocMDP signature that defines what shall be permitted to change in a document; see
//12.8.2.2, "DocMDP").
//When creating certification signatures, PDF writers should also create a legal attestation dictionary,
//whose entries are shown in "Table 264 — Entries in a legal attestation dictionary". This dictionary
//shall be the value of the Legal entry in the document catalog dictionary (see "Table 29 — Entries in the
//catalog dictionary"). Its entries shall specify all content that may result in unexpected rendering of the
//document contents. The author may provide further clarification of such content by means of the
//Attestation entry. Reviewers should establish for themselves that they trust the author and contents
//of the document. In the case of a legal challenge to the document, any questionable content can be
//reviewed in the context of the information in this dictionary.
//© ISO 2020 – All rights reserved 593
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//594 © ISO 2020 – All rights reserved
//Table 264 — Entries in a legal attestation dictionary
//Key Type Value
//JavaScriptActions integer (Optional) The number of ECMAScript actions found in the document
//(see 12.6.4.17, "ECMAScript actions").
//LaunchActions integer (Optional) The number of launch actions found in the document (see
//12.6.4.6, "Launch actions").
//URIActions integer (Optional) The number of URI actions found in the document (see
//12.6.4.8, "URI actions").
//MovieActions integer (Optional; deprecated in PDF 2.0) The number of movie actions found
//in the document (see 12.6.4.10, "Movie actions").
//SoundActions integer (Optional; deprecated in PDF 2.0) The number of sound actions found
//in the document (see 12.6.4.9, "Sound actions").
//HideAnnotationActions integer (Optional) The number of hide actions found in the document (see
//12.6.4.11, "Hide actions").
//GoToRemoteActions integer (Optional) The number of remote go-to actions found in the document
//(see 12.6.4.3, "Remote Go-To actions").
//AlternateImages integer (Optional) The number of alternate images found in the document (see
//8.9.5.4, "Alternate images")
//ExternalStreams integer (Optional) The number of external streams found in the document.
//TrueTypeFonts integer (Optional) The number of TrueType fonts found in the document (see
//9.6.3, "TrueType fonts").
//ExternalRefXobjects integer (Optional) The number of reference XObjects found in the document
//(see 8.10.4, "Reference XObjects").
//ExternalOPIdicts integer (Optional; deprecated in PDF 2.0) The number of OPI dictionaries
//found in the document (see 14.11.7, "Open prepress interface (OPI)").
//NonEmbeddedFonts integer (Optional) The number of non-embedded fonts found in the document
//(see 9.9, "Embedded font programs")
//DevDepGS_OP integer (Optional) The number of references to the graphics state parameter
//OP found in the document (see "Table 57 — Entries in a graphics state
//parameter dictionary").
//DevDepGS_HT integer (Optional) The number of references to the graphics state parameter
//HT found in the document (see "Table 57 — Entries in a graphics state
//parameter dictionary").
//DevDepGS_TR integer (Optional) The number of references to the graphics state parameter
//TR found in the document (see "Table 57 — Entries in a graphics state
//parameter dictionary").
//DevDepGS_UCR integer (Optional) The number of references to the graphics state parameter
//UCR found in the document (see "Table 57 — Entries in a graphics
//state parameter dictionary").
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 595
//Key Type Value
//DevDepGS_BG integer (Optional) The number of references to the graphics state parameter
//BG found in the document (see "Table 57 — Entries in a graphics state
//parameter dictionary").
//DevDepGS_FL integer (Optional) The number of references to the graphics state parameter
//FL found in the document (see "Table 57 — Entries in a graphics state
//parameter dictionary").
//Annotations integer (Optional) The number of annotations found in the document (see
//12.5, "Annotations").
//OptionalContent boolean (Optional) true if optional content is found in the document (see 8.11,
//"Optional content").
//Attestation text
//string
//(Optional) An attestation, created by the author of the document,
//explaining the presence of any of the other entries in this dictionary or
//the presence of any other content affecting the legal integrity of the
//document.
