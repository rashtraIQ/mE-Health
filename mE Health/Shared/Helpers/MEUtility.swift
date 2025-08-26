//
//  MEUtility.swift
//  mE Health
//
//  Created by Ishant Tiwari on 02/07/25.
//

import Foundation

class MEUtility: NSObject {
    static let ME_TOKEN = "token"
    static let ME_USERID = "user_id"
    static let ME_PATIENTID = "patientId"
    static let ME_PRACTITIONERD = "practitionerId"
    static let NA_Value = ""
    

    
    static  func setME_PRACTITIONERD(value inputValue: String) {
        MEUtility.storeStringValueToDefaults(value: inputValue, forKey: ME_PRACTITIONERD)
       }
       
       // returns brand   MiddiUserNameKeyString
       static  func getME_PRACTITIONERD() -> String? {
           let outputValue =  MEUtility.loadStringValueFromDefaults(forKey: ME_PRACTITIONERD)
           if(outputValue != nil ) {
               
               return outputValue!
               
           }
           return MEUtility.NA_Value
       }
    
    static  func setME_PATIENTID(value inputValue: String) {
        MEUtility.storeStringValueToDefaults(value: inputValue, forKey: ME_PATIENTID)
       }
       
       // returns brand   MiddiUserNameKeyString
       static  func getME_PATIENTID() -> String {
           let outputValue =  MEUtility.loadStringValueFromDefaults(forKey: ME_PATIENTID)
           if(outputValue != nil || outputValue != "") {
               return outputValue ?? ""
           }
           return MEUtility.NA_Value
       }
    
    static  func setME_TOKEN(value inputValue: String) {
        MEUtility.storeStringValueToDefaults(value: inputValue, forKey: ME_TOKEN)
       }
       
       // returns brand   MiddiUserNameKeyString
       static  func getME_TOKEN() -> String? {
           let outputValue =  MEUtility.loadStringValueFromDefaults(forKey: ME_TOKEN)
           print(outputValue)
           if(outputValue != nil ) {
               
               return outputValue!
               
           }
           return MEUtility.NA_Value
       }
    
   
    
    static  func setME_USERID(value inputValue: String) {
        MEUtility.storeStringValueToDefaults(value: inputValue, forKey: ME_USERID)
       }
       
       // returns brand   MiddiUserNameKeyString
       static  func getME_USERID() -> String {
           let outputValue =  MEUtility.loadStringValueFromDefaults(forKey: ME_USERID)
           if(outputValue != nil ) {
               
               return outputValue!
               
           }
           return MEUtility.NA_Value
       }
    
    static  func storeStringValueToDefaults(value inputValue: String ,forKey key: String) {
        UserDefaults.standard.set(inputValue, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    static  func loadStringValueFromDefaults(forKey key: String) -> String? {
        if let outputValue = UserDefaults.standard.object(forKey: key) {
            return outputValue as? String
        }
        return ""
    }
    
}
