//
//  LoginResponse.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 9/06/25.
//

import Foundation
struct LoginResponse : Codable,Equatable {
    let message : String?
    let status : Bool?
    let data : UserData?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        data = try values.decodeIfPresent(UserData.self, forKey: .data)
    }

}

struct UserData : Codable , Equatable{
    let user_id : Int?
    let email : String?
    let user_type : String?
    let phone : String?
    let countryCode : String?
    let token : String?
    let auth_token : String?
    let first_name : String?
    let last_name : String?
    let walletAddress : String?
    let provider_id : String?
    let isPhoneVerified : Bool?
    let isEmailVerified : Bool?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case email = "email"
        case user_type = "user_type"
        case phone = "phone"
        case countryCode = "countryCode"
        case token = "token"
        case auth_token = "auth_token"
        case first_name = "first_name"
        case last_name = "last_name"
        case walletAddress = "walletAddress"
        case provider_id = "provider_id"
        case isPhoneVerified = "isPhoneVerified"
        case isEmailVerified = "isEmailVerified"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        auth_token = try values.decodeIfPresent(String.self, forKey: .auth_token)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        walletAddress = try values.decodeIfPresent(String.self, forKey: .walletAddress)
        provider_id = try values.decodeIfPresent(String.self, forKey: .provider_id)
        isPhoneVerified = try values.decodeIfPresent(Bool.self, forKey: .isPhoneVerified)
        isEmailVerified = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
    }

}
