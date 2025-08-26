//
//  ConditionModel.swift
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

struct ConditionModel : Codable , Equatable{
    let resourceType : String?
    let type : String?
    let total : Int?
    let link : [CommonLinkModel]?
    let entry : [ConditionEntry]?

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
        entry = try values.decodeIfPresent([ConditionEntry].self, forKey: .entry)
    }

}

struct ConditionEntry : Codable ,Equatable {
    let fullUrl : String?
    let resource : CommonResource?

    enum CodingKeys: String, CodingKey {

        case fullUrl = "fullUrl"
        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullUrl = try values.decodeIfPresent(String.self, forKey: .fullUrl)
        resource = try values.decodeIfPresent(CommonResource.self, forKey: .resource)
    }

}

struct CommonResource : Codable ,Equatable{
    let resourceType : String?
    let id : String?
    let clinicalStatus : ClinicalStatus?
    let verificationStatus : VerificationStatus?
    let category : [ConditionCategory]?
    let code : ConditionCode?
    let subject : ConditionSubject?
    let onsetDateTime : String?
    let recordedDate : String?
    let patient : PatientModel?
    let type : String?
    let criticality : String?


    enum CodingKeys: String, CodingKey {

        case resourceType = "resourceType"
        case id = "id"
        case clinicalStatus = "clinicalStatus"
        case verificationStatus = "verificationStatus"
        case category = "category"
        case code = "code"
        case subject = "subject"
        case onsetDateTime = "onsetDateTime"
        case recordedDate = "recordedDate"
        case type = "type"
        case criticality = "criticality"
        case patient = "patient"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        clinicalStatus = try values.decodeIfPresent(ClinicalStatus.self, forKey: .clinicalStatus)
        verificationStatus = try values.decodeIfPresent(VerificationStatus.self, forKey: .verificationStatus)
        category = try values.decodeIfPresent([ConditionCategory].self, forKey: .category)
        code = try values.decodeIfPresent(ConditionCode.self, forKey: .code)
        subject = try values.decodeIfPresent(ConditionSubject.self, forKey: .subject)
        onsetDateTime = try values.decodeIfPresent(String.self, forKey: .onsetDateTime)
        recordedDate = try values.decodeIfPresent(String.self, forKey: .recordedDate)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        criticality = try values.decodeIfPresent(String.self, forKey: .criticality)
        patient = try values.decodeIfPresent(PatientModel.self, forKey: .patient)

    }

}

struct ClinicalStatus : Codable,Equatable {
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

struct VerificationStatus : Codable,Equatable {
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

struct ConditionCategory : Codable,Equatable {
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

struct ConditionSubject : Codable,Equatable {
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

struct ConditionCode : Codable , Equatable{
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
