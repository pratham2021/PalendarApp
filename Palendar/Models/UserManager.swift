//
//  UserManager.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import Foundation

class UserManager {
    
    static func saveUser(firstName:String, lastName:String) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "userSavedOnDevice")
        defaults.set(firstName, forKey: "firstName")
        defaults.set(lastName, forKey: "lastName")
    }
    
    static func getUser(_ key: String) -> Any? {
        let defaults = UserDefaults.standard
        let value = defaults.value(forKey: key)
        return value
    }
    
    static func saveUserId(userId:String) {
        let defaults = UserDefaults.standard
        defaults.set(userId, forKey: "userId")
    }
    
    static func saveDeviceToken(token:String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "deviceToken")
    }
    
//    static func saveEmail(email:String) {
//        let defaults = UserDefaults.standard
//        defaults.set(email, forKey: "email")
//    }
//    
    static func saveImageURL(imageURL:String) {
        let defaults = UserDefaults.standard
        defaults.set(imageURL, forKey: "imageURL")
    }
    
}
