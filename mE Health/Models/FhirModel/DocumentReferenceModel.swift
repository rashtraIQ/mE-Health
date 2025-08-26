//
//  DocumentReferenceModel.swift
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

struct DocumentReferenceModel : Codable , Equatable{
    let resourceType : String?
    let type : String?
    let total : Int?
    let link : [CommonLinkModel]?
    let entry : [DocEntry]?

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
        entry = try values.decodeIfPresent([DocEntry].self, forKey: .entry)
    }

}

struct DocEntry : Codable, Equatable {
    let fullUrl : String?
    let resource : DocResource?

    enum CodingKeys: String, CodingKey {

        case fullUrl = "fullUrl"
        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullUrl = try values.decodeIfPresent(String.self, forKey: .fullUrl)
        resource = try values.decodeIfPresent(DocResource.self, forKey: .resource)
    }

}

struct DocResource : Codable, Equatable {
    let resourceType : String?
    let id : String?
    let identifier : [Identifier]?
    let status : String?
    let type : CodingTextCommonModel?
    let category : [DocCategory]?
    let subject : ConditionSubject?
    let date : String?
    let content : [Content]?

    enum CodingKeys: String, CodingKey {

        case resourceType = "resourceType"
        case id = "id"
        case identifier = "identifier"
        case status = "status"
        case type = "type"
        case category = "category"
        case subject = "subject"
        case date = "date"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        identifier = try values.decodeIfPresent([Identifier].self, forKey: .identifier)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        type = try values.decodeIfPresent(CodingTextCommonModel.self, forKey: .type)
        category = try values.decodeIfPresent([DocCategory].self, forKey: .category)
        subject = try values.decodeIfPresent(ConditionSubject.self, forKey: .subject)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        content = try values.decodeIfPresent([Content].self, forKey: .content)
    }

}

struct Content : Codable,Equatable {
    let attachment : Attachment?
    let format : Format?

    enum CodingKeys: String, CodingKey {

        case attachment = "attachment"
        case format = "format"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attachment = try values.decodeIfPresent(Attachment.self, forKey: .attachment)
        format = try values.decodeIfPresent(Format.self, forKey: .format)
    }

}

struct Attachment : Codable,Equatable {
    let contentType : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case contentType = "contentType"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contentType = try values.decodeIfPresent(String.self, forKey: .contentType)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

struct Format : Codable,Equatable{
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

struct DocCategory : Codable , Equatable{
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
