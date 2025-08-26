//
//  StateModel.swift
//  mE Health
//


struct StateModel : Codable , Equatable{
    let message : String?
    let success : Bool?
    let data : StateData?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(StateData.self, forKey: .data)
    }

}

struct StateData : Codable , Equatable {
    let total_practices : Int?
    let by_country : [ByCountry]?
    let top_states : [TopStates]?
    let top_ehr_vendors : [TopEhrVendors]?

    enum CodingKeys: String, CodingKey {

        case total_practices = "total_practices"
        case by_country = "by_country"
        case top_states = "top_states"
        case top_ehr_vendors = "top_ehr_vendors"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_practices = try values.decodeIfPresent(Int.self, forKey: .total_practices)
        by_country = try values.decodeIfPresent([ByCountry].self, forKey: .by_country)
        top_states = try values.decodeIfPresent([TopStates].self, forKey: .top_states)
        top_ehr_vendors = try values.decodeIfPresent([TopEhrVendors].self, forKey: .top_ehr_vendors)
    }

}

struct ByCountry : Codable ,Equatable{
    let country : String?
    let count : Int?
    let logo : String?

    enum CodingKeys: String, CodingKey {
        case country = "country"
        case count = "count"
        case logo = "logo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
    }

}

struct TopEhrVendors : Codable,Equatable {
    let ehr_vendor : String?
    let count : Int?
    let logo : String?

    enum CodingKeys: String, CodingKey {

        case ehr_vendor = "ehr_vendor"
        case count = "count"
        case logo = "logo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ehr_vendor = try values.decodeIfPresent(String.self, forKey: .ehr_vendor)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
    }

}

struct TopStates : Codable , Equatable{
    let state : String?
    let count : Int?
    let logo : String?

    enum CodingKeys: String, CodingKey {

        case state = "state"
        case count = "count"
        case logo = "logo"
    }
    
    init(state: String?, count: Int?, logo: String?) {
        self.state = state
        self.count = count
        self.logo = logo
    }



    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
    }

}
