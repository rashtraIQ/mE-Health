//
//  AppoitmentModel.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 13/06/25.
//

struct AppoitmentModel : Codable , Equatable{
    let entry : [AppoitmentEntry]?

    enum CodingKeys: String, CodingKey {
        case entry = "entry"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        entry = try values.decodeIfPresent([AppoitmentEntry].self, forKey: .entry)
    }

    
}

struct AppoitmentEntry : Codable , Equatable {
    let resource : AppoitmentResource?

    enum CodingKeys: String, CodingKey {
        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resource = try values.decodeIfPresent(AppoitmentResource.self, forKey: .resource)
    }

}

struct AppoitmentResource : Codable,Equatable {
    let resourceType : String?
    let id : String?
    let identifier : [Identifier]?
    let status : String?
    let serviceCategory : [ServiceCategory]?
    let serviceType : [ServiceType]?
    let appointmentType : AppointmentType?
    let start : String?
    let end : String?
    let minutesDuration : Int?
    let created : String?
    let patientInstruction : String?
    let participant : [Participant]?

    enum CodingKeys: String, CodingKey {

        case resourceType = "resourceType"
        case id = "id"
        case identifier = "identifier"
        case status = "status"
        case serviceCategory = "serviceCategory"
        case serviceType = "serviceType"
        case appointmentType = "appointmentType"
        case start = "start"
        case end = "end"
        case minutesDuration = "minutesDuration"
        case created = "created"
        case patientInstruction = "patientInstruction"
        case participant = "participant"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        identifier = try values.decodeIfPresent([Identifier].self, forKey: .identifier)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        serviceCategory = try values.decodeIfPresent([ServiceCategory].self, forKey: .serviceCategory)
        serviceType = try values.decodeIfPresent([ServiceType].self, forKey: .serviceType)
        appointmentType = try values.decodeIfPresent(AppointmentType.self, forKey: .appointmentType)
        start = try values.decodeIfPresent(String.self, forKey: .start)
        end = try values.decodeIfPresent(String.self, forKey: .end)
        minutesDuration = try values.decodeIfPresent(Int.self, forKey: .minutesDuration)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        patientInstruction = try values.decodeIfPresent(String.self, forKey: .patientInstruction)
        participant = try values.decodeIfPresent([Participant].self, forKey: .participant)
    }

}

struct AppointmentType : Codable , Equatable{
    let coding : [Coding]?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
    }

}

struct ServiceCategory : Codable, Equatable {
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

struct ServiceType : Codable, Equatable {
    let coding : [Coding]?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
    }

}

struct Participant : Codable , Equatable{
    let actor : Actor?
    let required : String?
    let status : String?
    let period : Period?

    enum CodingKeys: String, CodingKey {

        case actor = "actor"
        case required = "required"
        case status = "status"
        case period = "period"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actor = try values.decodeIfPresent(Actor.self, forKey: .actor)
        required = try values.decodeIfPresent(String.self, forKey: .required)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        period = try values.decodeIfPresent(Period.self, forKey: .period)
    }

}

struct Actor : Codable , Equatable{
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

struct Period : Codable,Equatable {
    let start : String?
    let end : String?

    enum CodingKeys: String, CodingKey {

        case start = "start"
        case end = "end"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(String.self, forKey: .start)
        end = try values.decodeIfPresent(String.self, forKey: .end)
    }

}
