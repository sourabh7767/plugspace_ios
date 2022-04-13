//
//  OtpVM.swift
//  PlugSpace
//
//  Created by MAC on 14/12/21.

import Foundation
import FirebaseMessaging

class OtpVM: BaseVM {
    
    //MARK:- Properties
    var otp = [OtpModel]()
    var data: SignUpModel!
    
    var phone = ""
    var ccode = ""
    var otpCode = ""
    var isSignup = ""
    var isLogin = ""
    var deviceType = "ios"

    //MARK:-Method
    
    func validation() -> Bool {
        
        if phone.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.phone
        } else if ccode.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.ccode
        }else if otpCode.isEmptyOrWhiteSpace || otpCode.count != 4 {
            self.errorMessage = StringConstant.otpCode
        }
        else {
            return true
        }
        
        return false
        
    }
    
    func verifyOTP(completion : @escaping (_ isSuccess: Bool) -> Void)  {
        if let token = Messaging.messaging().fcmToken {
            let parameterRequest = ParameterRequest()
            
            parameterRequest.addParameter(key: ParameterRequest.deviceToken, value: token as AnyObject)
            parameterRequest.addParameter(key: ParameterRequest.deviceType, value: deviceType)
            parameterRequest.addParameter(key: ParameterRequest.phone, value: phone)
            parameterRequest.addParameter(key: ParameterRequest.ccode, value: ccode)
            parameterRequest.addParameter(key: ParameterRequest.otpCode, value: otpCode)
            
            apiClient.verifyOTP(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
               
                guard err == nil else {
                    self.errorMessage = err!
                    completion(false)
                    return
                }
                
                if respCode == ResponseStatus.success {
                    
                    if let respDict = resp as? [String:Any] {
                        
                        AppPrefsManager.shared.setUserData(obj: respDict["data"] as? [String:Any] ?? [String:Any]())
                        
                        self.isLogin = respDict["is_login"] as? String ?? ""
                        
                        self.data = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
                        AppPrefsManager.shared.saveAuthToken(Token: self.data.token)
                    }
                    
                    self.errorMessage = respMsg!
                    completion(true)
                    
                } else {
                    
                    self.errorMessage = respMsg!
                    completion(false)
                }
            }
        }
       
    }
    
    func validationOtpNumber() -> Bool {
        
        if phone.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.phone
        } else if ccode.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.ccode
        } else if !phone.isValidPhoneNumber() {
            self.errorMessage = StringConstant.validPhone
        }
        else {
            return true
        }
        
        return false
        
    }
    
    func sendOtp(completion : @escaping (_ isSuccess: Bool) -> Void)  {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.phone, value: phone)
        parameterRequest.addParameter(key: ParameterRequest.ccode, value: ccode)
        parameterRequest.addParameter(key: ParameterRequest.isSignup, value: isSignup)
        
        apiClient.sendOTP(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
           
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                
                self.otp = OtpModel.getotp(dict: resp as! [String : Any])
                self.errorMessage = respMsg!
                completion(true)
                
            } else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
//    
//    func senOtpToFirebase(completion : @escaping (_ isSuccess: Bool) -> Void) {
//
//        PhoneAuthProvider.provider()
//          .verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
//              if let error = error {
//                self.showMessagePrompt(error.localizedDescription)
//                return
//              }
//              // Sign in using the verificationID and the code sent to the user
//              // ...
//          }
//    }
}
