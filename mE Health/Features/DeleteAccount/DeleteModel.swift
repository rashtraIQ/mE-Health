//
//  DeleteModel.swift
//  mE Health
//
//  Created by Rashida on 30/07/25.
//

struct deleteReasonResponse : Codable {
    let mE_text_res : String?
    let status : Int?
    let data : [deleteReasonData]?

    enum CodingKeys: String, CodingKey {

        case mE_text_res = "mE_text_res"
        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mE_text_res = try values.decodeIfPresent(String.self, forKey: .mE_text_res)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent([deleteReasonData].self, forKey: .data)
    }

}

struct deleteReasonData : Codable {
    let id : Int?
    let name : String?
    let source : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case source = "source"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        source = try values.decodeIfPresent(String.self, forKey: .source)
    }

}
