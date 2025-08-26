//
//  MedicationModel.swift
//  mE Health
//
//  # =============================================================================
//# mEinstein - CONFIDENTIAL
//#
//# Copyright ©️ 2025 mEinstein Inc. All Rights Reserved.
//#
//# NOTICE: All information contained herein is and remains the property of
//# mEinstein Inc. The intellectual and technical concepts contained herein are
//# proprietary to mEinstein Inc. and may be covered by U.S. and foreign patents,
//# patents in process, and are protected by trade secret or copyright law.
//#
//# Dissemination of this information, or reproduction of this material,
//# is strictly forbidden unless prior written permission is obtained from
//# mEinstein Inc.
//#
//# Author(s): Ishant 
//# ============================================================================= on 22/05/25.
//

import Foundation
struct MedicationModel : Codable , Equatable{
    let resourceType : String?
    let type : String?
    let total : Int?
    let link : [CommonLinkModel]?
    let entry : [Entry]?

    enum CodingKeys: String, CodingKey {

        case resourceType = "resourceType"
        case type = "type"
        case total = "total"
        case link = "link"
        case entry = "entry"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        link = try values.decodeIfPresent([CommonLinkModel].self, forKey: .link)
        entry = try values.decodeIfPresent([Entry].self, forKey: .entry)
    }

}


struct Entry : Codable , Equatable{
    let fullUrl : String?
    let resource : MedicalResource?

    enum CodingKeys: String, CodingKey {

        case fullUrl = "fullUrl"
        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullUrl = try values.decodeIfPresent(String.self, forKey: .fullUrl)
        resource = try values.decodeIfPresent(MedicalResource.self, forKey: .resource)
    }

}

struct MedicalResource : Codable , Equatable {
    let resourceType : String?
    let Id : String?
    let active : Bool?
    let practitioner : Practitioner?
    let identifier : [Identifier]?
    let status : String?
    let intent : String?
    let category : [CodingTextCommonModel]?
    let medicationReference : MedicationReference?
    let subject : MedicationReference?
    let encounter : Encounter?
    let authoredOn : String?
    let requester : Requester?
    let recorder : Recorder?
    let courseOfTherapyType : CourseOfTherapyType?
    let dosageInstruction : [DosageInstruction]?
    let dispenseRequest : DispenseRequest?

    enum CodingKeys: String, CodingKey {
        case resourceType = "resourceType"
        case Id = "id"
        case active = "active"
        case practitioner = "practitioner"
        case identifier = "identifier"
        case status = "status"
        case intent = "intent"
        case category = "category"
        case medicationReference = "medicationReference"
        case subject = "subject"
        case encounter = "encounter"
        case authoredOn = "authoredOn"
        case requester = "requester"
        case recorder = "recorder"
        case courseOfTherapyType = "courseOfTherapyType"
        case dosageInstruction = "dosageInstruction"
        case dispenseRequest = "dispenseRequest"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        Id = try values.decodeIfPresent(String.self, forKey: .Id)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        practitioner = try values.decodeIfPresent(Practitioner.self, forKey: .practitioner)
        identifier = try values.decodeIfPresent([Identifier].self, forKey: .identifier)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        intent = try values.decodeIfPresent(String.self, forKey: .intent)
        category = try values.decodeIfPresent([CodingTextCommonModel].self, forKey: .category)
        medicationReference = try values.decodeIfPresent(MedicationReference.self, forKey: .medicationReference)
        subject = try values.decodeIfPresent(MedicationReference.self, forKey: .subject)
        encounter = try values.decodeIfPresent(Encounter.self, forKey: .encounter)
        authoredOn = try values.decodeIfPresent(String.self, forKey: .authoredOn)
        requester = try values.decodeIfPresent(Requester.self, forKey: .requester)
        recorder = try values.decodeIfPresent(Recorder.self, forKey: .recorder)
        courseOfTherapyType = try values.decodeIfPresent(CourseOfTherapyType.self, forKey: .courseOfTherapyType)
        dosageInstruction = try values.decodeIfPresent([DosageInstruction].self, forKey: .dosageInstruction)
        dispenseRequest = try values.decodeIfPresent(DispenseRequest.self, forKey: .dispenseRequest)

    }

}

struct CommonLinkModel : Codable, Equatable {
    let relation : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case relation = "relation"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        relation = try values.decodeIfPresent(String.self, forKey: .relation)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}


struct MedicationReference : Codable , Equatable{
    let reference : String?
    let display : String?

    enum CodingKeys: String, CodingKey {

        case reference = "reference"
        case display = "display"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }

}

struct Encounter : Codable , Equatable{
    let reference : String?
    let identifier : Identifier?
    let display : String?

    enum CodingKeys: String, CodingKey {

        case reference = "reference"
        case identifier = "identifier"
        case display = "display"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        identifier = try values.decodeIfPresent(Identifier.self, forKey: .identifier)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }

}

struct Identifier : Codable, Equatable {
    let use : String?
    let system : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case use = "use"
        case system = "system"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        use = try values.decodeIfPresent(String.self, forKey: .use)
        system = try values.decodeIfPresent(String.self, forKey: .system)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}


struct Requester : Codable , Equatable{
    let reference : String?
    let type : String?
    let display : String?

    enum CodingKeys: String, CodingKey {

        case reference = "reference"
        case type = "type"
        case display = "display"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }

}

struct Recorder : Codable,Equatable {
    let reference : String?
    let type : String?
    let display : String?

    enum CodingKeys: String, CodingKey {

        case reference = "reference"
        case type = "type"
        case display = "display"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }

}

struct CourseOfTherapyType : Codable , Equatable{
    let coding : [Coding]?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}

struct Coding : Codable, Equatable {
    let system : String?
    let code : String?
    let display : String?

    enum CodingKeys: String, CodingKey {

        case system = "system"
        case code = "code"
        case display = "display"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        system = try values.decodeIfPresent(String.self, forKey: .system)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }

}

struct DosageInstruction : Codable , Equatable{
    let text : String?
    let patientInstruction : String?
    let timing : Timing?
    let asNeededBoolean : Bool?
    let route : CodingTextCommonModel?
    let method : CodingTextCommonModel?
    let doseAndRate : [DoseAndRate]?

    enum CodingKeys: String, CodingKey {

        case text = "text"
        case patientInstruction = "patientInstruction"
        case timing = "timing"
        case asNeededBoolean = "asNeededBoolean"
        case route = "route"
        case method = "method"
        case doseAndRate = "doseAndRate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        patientInstruction = try values.decodeIfPresent(String.self, forKey: .patientInstruction)
        timing = try values.decodeIfPresent(Timing.self, forKey: .timing)
        asNeededBoolean = try values.decodeIfPresent(Bool.self, forKey: .asNeededBoolean)
        route = try values.decodeIfPresent(CodingTextCommonModel.self, forKey: .route)
        method = try values.decodeIfPresent(CodingTextCommonModel.self, forKey: .method)
        doseAndRate = try values.decodeIfPresent([DoseAndRate].self, forKey: .doseAndRate)
    }

}

struct DoseAndRate : Codable, Equatable {
    let type : CodingTextCommonModel?
    let doseQuantity : DoseQuantity?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case doseQuantity = "doseQuantity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(CodingTextCommonModel.self, forKey: .type)
        doseQuantity = try values.decodeIfPresent(DoseQuantity.self, forKey: .doseQuantity)
    }

}

struct Timing : Codable ,Equatable {
    let Repeat : RepeatModel?
    let code : Code?

    enum CodingKeys: String, CodingKey {

        case Repeat = "repeat"
        case code = "code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Repeat = try values.decodeIfPresent(RepeatModel.self, forKey: .Repeat)
        code = try values.decodeIfPresent(Code.self, forKey: .code)
    }

}

struct CodingTextCommonModel : Codable,Equatable {
    let coding : [Coding]?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}



struct Code : Codable, Equatable {
    let text : String?

    enum CodingKeys: String, CodingKey {

        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}

struct RepeatModel : Codable,Equatable {
    let boundsPeriod : BoundsPeriod?
    let count : Int?
    let timeOfDay : [String]?

    enum CodingKeys: String, CodingKey {

        case boundsPeriod = "boundsPeriod"
        case count = "count"
        case timeOfDay = "timeOfDay"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        boundsPeriod = try values.decodeIfPresent(BoundsPeriod.self, forKey: .boundsPeriod)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        timeOfDay = try values.decodeIfPresent([String].self, forKey: .timeOfDay)
    }

}

struct BoundsPeriod : Codable,Equatable {
    let start : String?

    enum CodingKeys: String, CodingKey {

        case start = "start"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(String.self, forKey: .start)
    }

}

struct DoseQuantity : Codable, Equatable {
    let value : Int?
    let unit : String?
    let system : String?
    let code : String?

    enum CodingKeys: String, CodingKey {

        case value = "value"
        case unit = "unit"
        case system = "system"
        case code = "code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        unit = try values.decodeIfPresent(String.self, forKey: .unit)
        system = try values.decodeIfPresent(String.self, forKey: .system)
        code = try values.decodeIfPresent(String.self, forKey: .code)
    }

}

struct DispenseRequest : Codable,Equatable {
    let validityPeriod : ValidityPeriod?
    let numberOfRepeatsAllowed : Int?
    let quantity : Quantity?

    enum CodingKeys: String, CodingKey {
        case validityPeriod = "validityPeriod"
        case numberOfRepeatsAllowed = "numberOfRepeatsAllowed"
        case quantity = "quantity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        validityPeriod = try values.decodeIfPresent(ValidityPeriod.self, forKey: .validityPeriod)
        numberOfRepeatsAllowed = try values.decodeIfPresent(Int.self, forKey: .numberOfRepeatsAllowed)
        quantity = try values.decodeIfPresent(Quantity.self, forKey: .quantity)
    }

}

struct ValidityPeriod : Codable,Equatable {
    let start : String?

    enum CodingKeys: String, CodingKey {

        case start = "start"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(String.self, forKey: .start)
    }

}

struct Quantity : Codable, Equatable {
    let value : Int?
    let unit : String?

    enum CodingKeys: String, CodingKey {

        case value = "value"
        case unit = "unit"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        unit = try values.decodeIfPresent(String.self, forKey: .unit)
    }

}
