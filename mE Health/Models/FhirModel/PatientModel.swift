//
//  PatientModel.swift
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
//# ============================================================================= on 23/05/25.
//


struct PatientModel : Codable, Equatable {
    let id : String?
    let identifier : [Identifier]?
    let name : [Name]?
    let telecom : [Telecom]?
    let gender : String?
    let birthDate : String?
    let address : [Address]?
    let maritalStatus : MaritalStatus?
    let communication : [Communication]?
    let careProvider : [CareProvider]?
    let generalPractitioner : [GeneralPractitioner]?
    let managingOrganization : ManagingOrganization?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case identifier = "identifier"
        case name = "name"
        case telecom = "telecom"
        case gender = "gender"
        case birthDate = "birthDate"
        case address = "address"
        case maritalStatus = "maritalStatus"
        case communication = "communication"
        case careProvider = "careProvider"
        case generalPractitioner = "generalPractitioner"
        case managingOrganization = "managingOrganization"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        identifier = try values.decodeIfPresent([Identifier].self, forKey: .identifier)
        name = try values.decodeIfPresent([Name].self, forKey: .name)
        telecom = try values.decodeIfPresent([Telecom].self, forKey: .telecom)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        birthDate = try values.decodeIfPresent(String.self, forKey: .birthDate)
        address = try values.decodeIfPresent([Address].self, forKey: .address)
        maritalStatus = try values.decodeIfPresent(MaritalStatus.self, forKey: .maritalStatus)
        communication = try values.decodeIfPresent([Communication].self, forKey: .communication)
        careProvider = try values.decodeIfPresent([CareProvider].self, forKey: .careProvider)
        generalPractitioner = try values.decodeIfPresent([GeneralPractitioner].self, forKey: .generalPractitioner)
        managingOrganization = try values.decodeIfPresent(ManagingOrganization.self, forKey: .managingOrganization)

    }

}

struct Name : Codable, Equatable {
    let use : String?
    let text : String?
    let family : String?

    enum CodingKeys: String, CodingKey {

        case use = "use"
        case text = "text"
        case family = "family"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        use = try values.decodeIfPresent(String.self, forKey: .use)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        family = try values.decodeIfPresent(String.self, forKey: .family)
    }

}


struct GeneralPractitioner : Codable,Equatable {
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

struct ManagingOrganization : Codable, Equatable {
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


struct Practitioner: Codable,Equatable {
    let resourceType : String?
    let id : String?
    let identifier : [Identifier]?
    let active : Bool?
    let name : [Name]?
    let gender : String?
    
    enum CodingKeys: String, CodingKey {
        
        case resourceType = "resourceType"
        case id = "id"
        case identifier = "identifier"
        case active = "active"
        case name = "name"
        case gender = "gender"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        identifier = try values.decodeIfPresent([Identifier].self, forKey: .identifier)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        name = try values.decodeIfPresent([Name].self, forKey: .name)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
    }
}


struct PractitionerRole: Codable, Equatable  {
    let resourceType : String?
    let type : String?
    let total : Int?
    let entry : [Entry]?

    enum CodingKeys: String, CodingKey {

        case resourceType = "resourceType"
        case type = "type"
        case total = "total"
        case entry = "entry"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        entry = try values.decodeIfPresent([Entry].self, forKey: .entry)
    }

}

struct Telecom : Codable, Equatable {
    let system : String?
    let value : String?
    let use : String?

    enum CodingKeys: String, CodingKey {

        case system = "system"
        case value = "value"
        case use = "use"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        system = try values.decodeIfPresent(String.self, forKey: .system)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        use = try values.decodeIfPresent(String.self, forKey: .use)
    }

}
struct Address : Codable,Equatable {
    let use : String?
    let line : [String]?
    let city : String?
    let state : String?
    let postalCode : String?
    let country : String?

    enum CodingKeys: String, CodingKey {

        case use = "use"
        case line = "line"
        case city = "city"
        case state = "state"
        case postalCode = "postalCode"
        case country = "country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        use = try values.decodeIfPresent(String.self, forKey: .use)
        line = try values.decodeIfPresent([String].self, forKey: .line)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }

}

struct CareProvider : Codable,Equatable {
    let display : String?
    let reference : String?

    enum CodingKeys: String, CodingKey {

        case display = "display"
        case reference = "reference"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        display = try values.decodeIfPresent(String.self, forKey: .display)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
    }

}

struct Extension : Codable,Equatable {
    let url : String?
    let valueCodeableConcept : ValueCodeableConcept?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case valueCodeableConcept = "valueCodeableConcept"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        valueCodeableConcept = try values.decodeIfPresent(ValueCodeableConcept.self, forKey: .valueCodeableConcept)
    }

}

struct MaritalStatus : Codable,Equatable {
    let text : String?

    enum CodingKeys: String, CodingKey {

        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}

struct ValueCodeableConcept : Codable,Equatable {
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


struct Communication : Codable, Equatable {
    let language : LanguageModel?
    let preferred : Bool?

    enum CodingKeys: String, CodingKey {

        case language = "language"
        case preferred = "preferred"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        language = try values.decodeIfPresent(LanguageModel.self, forKey: .language)
        preferred = try values.decodeIfPresent(Bool.self, forKey: .preferred)
    }

}

struct LanguageModel : Codable,Equatable {
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
