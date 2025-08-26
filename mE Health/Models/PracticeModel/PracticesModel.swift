//
//  PracticesModel.swift
//  mE Health
//

struct PracticesModel : Codable , Equatable {
    let message : String?
    let success : Bool?
    let data : [PracticesModelData]?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent([PracticesModelData].self, forKey: .data)
    }

}

struct PracticesModelData : Codable , Equatable{
    let id : Int?
    let practice_name : String?
    let region : String?
    let city : String?
    let state : String?
    let country : String?
    let ehr_vendor : String?
    let website : String?
    let logo_url : String?
    let connection_url : String?
    let full_location : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case practice_name = "practice_name"
        case region = "region"
        case city = "city"
        case state = "state"
        case country = "country"
        case ehr_vendor = "ehr_vendor"
        case website = "website"
        case logo_url = "logo_url"
        case connection_url = "connection_url"
        case full_location = "full_location"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        practice_name = try values.decodeIfPresent(String.self, forKey: .practice_name)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        ehr_vendor = try values.decodeIfPresent(String.self, forKey: .ehr_vendor)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        logo_url = try values.decodeIfPresent(String.self, forKey: .logo_url)
        connection_url = try values.decodeIfPresent(String.self, forKey: .connection_url)
        full_location = try values.decodeIfPresent(String.self, forKey: .full_location)
    }

}
