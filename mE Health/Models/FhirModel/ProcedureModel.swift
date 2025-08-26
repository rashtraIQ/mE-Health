//
//  ProcedureModel.swift
import Foundation
struct ProcedureModel : Codable, Equatable {
    let resourceType : String?
    let type : String?
    let total : Int?
    let entry : [ProcedureEntry]?

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
        entry = try values.decodeIfPresent([ProcedureEntry].self, forKey: .entry)
    }

}

struct ProcedureEntry : Codable , Equatable{
    let fullUrl : String?
    let resource : ProcedureResource?

    enum CodingKeys: String, CodingKey {

        case fullUrl = "fullUrl"
        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullUrl = try values.decodeIfPresent(String.self, forKey: .fullUrl)
        resource = try values.decodeIfPresent(ProcedureResource.self, forKey: .resource)
    }

}

struct ProcedureResource : Codable , Equatable{
    let resourceType : String?
    let id : String?
    let status : String?
    let category : ProcedureCategory?
    let code : Code?
    let subject : Subject?
    let performedDateTime : String?

    enum CodingKeys: String, CodingKey {

        case resourceType = "resourceType"
        case id = "id"
        case status = "status"
        case category = "category"
        case code = "code"
        case subject = "subject"
        case performedDateTime = "performedDateTime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        category = try values.decodeIfPresent(ProcedureCategory.self, forKey: .category)
        code = try values.decodeIfPresent(Code.self, forKey: .code)
        subject = try values.decodeIfPresent(Subject.self, forKey: .subject)
        performedDateTime = try values.decodeIfPresent(String.self, forKey: .performedDateTime)
    }

}

struct Subject : Codable , Equatable{
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

struct ProcedureCategory : Codable, Equatable {
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
