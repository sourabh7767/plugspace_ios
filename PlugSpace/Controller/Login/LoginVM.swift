//
//  LoginVM.swift
//  PlugSpace
//
//  Created by MAC on 13/12/21.
//

import Foundation

class LoginVM: BaseVM {
    
    //MARK:- Properties
    
    static let shared = LoginVM()
    var ccode = ""
    var phone = ""
    var isApple = ""
    var isInsta = ""
    var appleId = ""
    var instaId = ""
    
    //MARK:-Method
    
    func validation() -> Bool {
        
        if phone.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.phone
        } else if ccode.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.ccode
        }
        else {
            return true
        }
        return false
    }
    
    //MARK:- Not Use
    
//    func login(completion : @escaping (_ isSuccess: Bool) -> Void) {
//        
//        let parameterRequest = ParameterRequest()
//        
//        parameterRequest.addParameter(key: ParameterRequest.phone, value: phone)
//        parameterRequest.addParameter(key: ParameterRequest.ccode, value: ccode)
//        
//        apiClient.login(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
//            guard err == nil else {
//                self.errorMessage = err!
//                completion(false)
//                return
//            }
//            
//            if respCode == ResponseStatus.success {
//                if let respDict = resp as? [String:Any] {
//                    
//                    let userData = respDict["data"] as? [String:Any] ?? [String:Any]()
//                    AppPrefsManager.shared.setUserData(obj: userData)
//                    self.data = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
//                    AppPrefsManager.shared.setIsUserSignUp(isUserLogin: false)
//                    AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
//                    AppPrefsManager.shared.saveAuthToken(Token: self.data.token)
//                }
//                self.errorMessage = respMsg!
//                completion(true)
//            }else {
//                self.errorMessage = respMsg!
//                completion(false)
//            }           
//        }
//    }
    
    func isRegister(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.isApple, value: isApple)
        parameterRequest.addParameter(key: ParameterRequest.appleId, value: appleId)
        parameterRequest.addParameter(key: ParameterRequest.isInsta, value: isInsta)
        parameterRequest.addParameter(key: ParameterRequest.instaId, value: instaId)
        
        apiClient.isRegister(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    AppPrefsManager.shared.setUserData(obj: respDict["data"] as? [String:Any] ?? [String:Any]())
                    let data  = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
                    
                    AppPrefsManager.shared.setIsUserSignUp(isUserLogin: false)
                    AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                    AppPrefsManager.shared.saveAuthToken(Token: data.token)
                    
                }
                self.errorMessage = respMsg!
                completion(true)
            }
            else {
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
