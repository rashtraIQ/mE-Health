//
//  PatientProfileModel.swift
//  mE Health
//
//  Created by Rashida on 19/06/25.
//

import Foundation
struct PatientProfilResponse : Codable , Equatable{
    let data : ProfileData?
    let message : String?
    let status : Int?
    let total_address : Int?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case message = "message"
        case status = "status"
        case total_address = "total_address"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ProfileData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        total_address = try values.decodeIfPresent(Int.self, forKey: .total_address)
    }

}

struct ProfileData : Codable, Equatable {
    let email : String?
    let first_name : String?
    let last_name : String?
    let user : Int?
    let id : Int?
    let countryCode : String?
    let phoneNumber : String?
    let address : String?
    let longitude : Double?
    let latitude : Double?
    let city : String?
    let state : String?
    let country : String?
    let gender : String?
    let isMarried : Bool?
    let zipCode : String?
    let touchId : String?
    let faceId : String?
    let ssn : String?
    let numberOfFamilyMembers : String?
    let facebookProfileURL : String?
    let linkedInProfileURL : String?
    let walletAddress : String?
    let instagram : String?
    let google : String?
    let twitter : String?
    let dateOfBirth : String?
    let user_profile_extn : [UserProfileExtn]?
    let industries : [String]?
    let company_name : String?
    let is_diro_verified : Int?
    let is_diro_address_verified : Int?
    let is_diro_organization_verified : Int?
    let is_diro_identity_verified : Int?
    let is_diro_bank_verified : Int?
    let children_count : Int?
    let copyright_id : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case first_name = "first_name"
        case last_name = "last_name"
        case user = "user"
        case id = "id"
        case countryCode = "countryCode"
        case phoneNumber = "phoneNumber"
        case address = "address"
        case longitude = "longitude"
        case latitude = "latitude"
        case city = "city"
        case state = "state"
        case country = "country"
        case gender = "gender"
        case isMarried = "isMarried"
        case zipCode = "zipCode"
        case touchId = "touchId"
        case faceId = "faceId"
        case ssn = "ssn"
        case numberOfFamilyMembers = "numberOfFamilyMembers"
        case facebookProfileURL = "facebookProfileURL"
        case linkedInProfileURL = "linkedInProfileURL"
        case walletAddress = "walletAddress"
        case instagram = "instagram"
        case google = "google"
        case twitter = "twitter"
        case dateOfBirth = "dateOfBirth"
        case user_profile_extn = "user_profile_extn"
        case industries = "industries"
        case company_name = "company_name"
        case is_diro_verified = "is_diro_verified"
        case is_diro_address_verified = "is_diro_address_verified"
        case is_diro_organization_verified = "is_diro_organization_verified"
        case is_diro_identity_verified = "is_diro_identity_verified"
        case is_diro_bank_verified = "is_diro_bank_verified"
        case children_count = "children_count"
        case copyright_id = "copyright_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        user = try values.decodeIfPresent(Int.self, forKey: .user)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        isMarried = try values.decodeIfPresent(Bool.self, forKey: .isMarried)
        zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
        touchId = try values.decodeIfPresent(String.self, forKey: .touchId)
        faceId = try values.decodeIfPresent(String.self, forKey: .faceId)
        ssn = try values.decodeIfPresent(String.self, forKey: .ssn)
        numberOfFamilyMembers = try values.decodeIfPresent(String.self, forKey: .numberOfFamilyMembers)
        facebookProfileURL = try values.decodeIfPresent(String.self, forKey: .facebookProfileURL)
        linkedInProfileURL = try values.decodeIfPresent(String.self, forKey: .linkedInProfileURL)
        walletAddress = try values.decodeIfPresent(String.self, forKey: .walletAddress)
        instagram = try values.decodeIfPresent(String.self, forKey: .instagram)
        google = try values.decodeIfPresent(String.self, forKey: .google)
        twitter = try values.decodeIfPresent(String.self, forKey: .twitter)
        dateOfBirth = try values.decodeIfPresent(String.self, forKey: .dateOfBirth)
        user_profile_extn = try values.decodeIfPresent([UserProfileExtn].self, forKey: .user_profile_extn)
        industries = try values.decodeIfPresent([String].self, forKey: .industries)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
        is_diro_verified = try values.decodeIfPresent(Int.self, forKey: .is_diro_verified)
        is_diro_address_verified = try values.decodeIfPresent(Int.self, forKey: .is_diro_address_verified)
        is_diro_organization_verified = try values.decodeIfPresent(Int.self, forKey: .is_diro_organization_verified)
        is_diro_identity_verified = try values.decodeIfPresent(Int.self, forKey: .is_diro_identity_verified)
        is_diro_bank_verified = try values.decodeIfPresent(Int.self, forKey: .is_diro_bank_verified)
        children_count = try values.decodeIfPresent(Int.self, forKey: .children_count)
        copyright_id = try values.decodeIfPresent(String.self, forKey: .copyright_id)
    }

}

struct UserProfileExtn : Codable, Equatable {
    let user_profile_extn_id : Int?
    let value_type : String?
    let value : String?
    let label : String?
    let from_date : String?
    let to_date : String?
    let record_date : String?
    let user_id : Int?

    enum CodingKeys: String, CodingKey {

        case user_profile_extn_id = "user_profile_extn_id"
        case value_type = "value_type"
        case value = "value"
        case label = "label"
        case from_date = "from_date"
        case to_date = "to_date"
        case record_date = "record_date"
        case user_id = "user_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_profile_extn_id = try values.decodeIfPresent(Int.self, forKey: .user_profile_extn_id)
        value_type = try values.decodeIfPresent(String.self, forKey: .value_type)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        from_date = try values.decodeIfPresent(String.self, forKey: .from_date)
        to_date = try values.decodeIfPresent(String.self, forKey: .to_date)
        record_date = try values.decodeIfPresent(String.self, forKey: .record_date)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
    }

}
