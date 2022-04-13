//  AppPrefsManager.swift
//
//
//  Created by MAC on 28/03/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

class SecureData : NSObject, NSSecureCoding {
    
    func encode(with coder: NSCoder) {
        print(coder)
    }
    
    required init?(coder: NSCoder) {
        print(coder)
    }
    
   static var supportsSecureCoding: Bool {
        return true
    }
}

class AppPrefsManager  {
    
    static let shared = AppPrefsManager()
    
    private let GET_AUTH_TOKEN          = "GET_AUTH_TOKEN"
    private let USER_DATA               = "USER_DATA"
    private let IS_USER_LOGIN           = "IS_USER_LOGIN"
    private let IS_USER_SIGNUP          = "IS_USER_SIGNUP"
    private let LATITUDE                = "latitude"
    private let LONGITUDE               = "longitude"
    private let ISSHOWVIDEO             = "ISSHOWVIDEO"
    private let ISLOCATIONVIEW          = "ISLOCATIONVIEW"
    
    init() {}
    
    private func setDataToPreference(data: AnyObject, forKey key: String) {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(archivedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func getDataFromPreference(key: String) -> AnyObject? {
        let archivedData = UserDefaults.standard.object(forKey: key)
        
        if archivedData != nil {
            return NSKeyedUnarchiver.unarchiveObject(with: archivedData! as! Data) as AnyObject?
        }
        return nil
    }
    
    // MARK: - Set & Get Data
    private func setData<T: Codable>(data: T, forKey key: String) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(jsonData, forKey: key)
            UserDefaults.standard.synchronize()
        } catch let error {
            print(error)
        }
    }
    
    private func getData<T: Codable>(objectType: T.Type, forKey key: String) -> T? {
        guard let result = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(objectType, from: result)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func removeDataFromPreference(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExistInPreference(key: String) -> Bool {
        if UserDefaults.standard.object(forKey: key) == nil {
            return false
        }
        return true
    }
    
    // MARK: - Device token
    func saveAuthToken(Token: String) {
        setDataToPreference(data: Token as AnyObject, forKey: GET_AUTH_TOKEN)
    }
    
    func getAuthToken() -> String {
        return getDataFromPreference(key: GET_AUTH_TOKEN) as? String ?? ""
    }
    
    func removeAuthToken() {
        removeDataFromPreference(key: GET_AUTH_TOKEN)
    }
    
    // MARK: - User Login
    func setIsUserLogin(isUserLogin: Bool) {
        setDataToPreference(data: isUserLogin as AnyObject, forKey: IS_USER_LOGIN)
    }
    
    func isUserLogin() -> Bool {
      let isUserLogin = getDataFromPreference(key: IS_USER_LOGIN)
        return isUserLogin == nil ? false: (isUserLogin as! Bool)
    }
  
    //MARK:- WelCome Video Show
    
    func setIsVideoShow(isShowVideo: Bool) {
        setDataToPreference(data: isShowVideo as AnyObject, forKey: ISSHOWVIDEO)
    }
    
    func isShowVideo() -> Bool {
      let isShowVideo = getDataFromPreference(key: ISSHOWVIDEO)
        return isShowVideo == nil ? false: (isShowVideo as! Bool)
    }
    
    
   // MARK: - User signup
    
    func setIsUserSignUp(isUserLogin: Bool) {
        setDataToPreference(data: isUserLogin as AnyObject, forKey: IS_USER_SIGNUP)
    }
    
    func isUserSignUp() -> Bool {
        let isUserLogin = getDataFromPreference(key: IS_USER_SIGNUP)
        return isUserLogin == nil ? false: (isUserLogin as! Bool)
        
    }
    
    // MARK: - LOCATION
     
     func LocationPopUp(isUserLogin: Bool) {
         setDataToPreference(data: isUserLogin as AnyObject, forKey: ISLOCATIONVIEW)
     }
     
     func getLocationPopUp() -> Bool {
         let isUserLogin = getDataFromPreference(key: ISLOCATIONVIEW)
         return isUserLogin == nil ? false: (isUserLogin as! Bool)
         
     }
    
    // MARK: -  User Data
    
    func setUserData(obj: [String: Any]) {
        setDataToPreference(data: obj as AnyObject, forKey: USER_DATA)
    }
    
    func getUserData() -> AnyObject {
        return getDataFromPreference(key: USER_DATA) as AnyObject
    }

    func removeUserData() {
        removeDataFromPreference(key: USER_DATA)
    }
    
    //MARK:- Location
    
    func saveLatitude(Latitude: Double) {
        setDataToPreference(data: Latitude as AnyObject, forKey: LATITUDE)
    }
    
    func savelongitude(longitude: Double) {
        setDataToPreference(data: longitude as AnyObject, forKey: LONGITUDE)
    }
    
    func getLatitude() -> Double {
        return getDataFromPreference(key: LATITUDE) as? Double ?? 0.0
    }
    
    func getlongitude() -> Double {
        return getDataFromPreference(key: LONGITUDE) as? Double ?? 0.0
    }
    
    func removeLocation() {
        removeDataFromPreference(key: LATITUDE)
        removeDataFromPreference(key: LATITUDE)
    }
}
