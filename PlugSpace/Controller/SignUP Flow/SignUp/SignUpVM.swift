//
//  SignUpVM.swift
//  PlugSpace
//
//  Created by MAC on 14/12/21.
//

import Foundation
import FirebaseMessaging
import CountryPickerView

protocol SignUpVMDelegate: NSObject {
    func instaLoginProcessCompleted(isSuccess: Bool)
    func instaSignupProcessCompleted(isSuccess: Bool)
}

class SignUPVM: BaseVM {
    
    //MARK:- Properties
    
     static let shared = SignUPVM()
     var otp = [OtpModel]()
     var delegate: SignUpVMDelegate?
    
     var name = ""
     var ccode = ""
     var phone = ""
     var isVerified = ""
     var gender = ""
     var location = ""
     var womanRank = ""
     var isGeoLocation = ""
     var height = ""
     var weight = ""
     var educationStatus = ""
     var dob = ""
     var children = ""
     var wantChildrens = ""
     var marringRace = ""
     var relationshipStatus = ""
     var ethinicity = ""
     var companyName = ""
     var makeOver = ""
     var dressSize = ""
     var signiatBills = ""
     var timesOfEngaged = ""
     var yourBodyTatto = ""
     var ageRangeMarriage = ""
     var mySelfMen = ""
     var rankUser = ""
     var niceMeet = ""
     var deviceType = "ios"
     var deviceToken = ""
     var profile = [Data]()
     var otpcode = ""
     var jobTitle = ""
     var aboutYou = ""
     var isApple = ""
     var isInsta = ""
     var appleId = ""
     var instaId = ""
    
    //MARK:-Method
    
    func callValidationMethod(Vc:UIViewController)  {
        
        guard SignUPVM.shared.validation() else {
            Vc.errorAlert(message: SignUPVM.shared.errorMessage)
            return
        }
    }
    
    func validation() -> Bool {
        
        if phone.isEmptyOrWhiteSpace && isApple == "0" {
            self.errorMessage = StringConstant.phone
        } else if ccode.isEmptyOrWhiteSpace && isApple == "0" {
            self.errorMessage = StringConstant.ccode
        } else if gender.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.gender
        } else if name.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.name
        } else if rankUser.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.rankUser
        } else if profile.count == 0 {
            self.errorMessage = StringConstant.photoValidation
        } else if height.isEmptyOrWhiteSpace{
            self.errorMessage = StringConstant.height
        } else if weight.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.weight
        } else if educationStatus.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.educationStatus
        } else if dob.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.dobValidation
        } else if children.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.children
        } else if wantChildrens.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.wantChildrens
        } else if marringRace.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.marringRace
        } else if relationshipStatus.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.relationshipStatus
        }else if ethinicity.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.ethinicity
        }else if jobTitle.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.jobTitle
        }else if dressSize.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.dressSize
        }else if timesOfEngaged.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.timesOfEngaged
        }else if yourBodyTatto.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.yourBodyTatto
        }else if ageRangeMarriage.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.ageRangeMarriage
        }else if mySelfMen.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.mySelfMen
        }else if aboutYou.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.aboutYou
        }else if niceMeet.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.niceMeet
        }
        else {
            return true
        }
        
        return false
        
    }
    
    func SignUp(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        if let token = Messaging.messaging().fcmToken {
            
            let parameterRequest = ParameterRequest()
            
            parameterRequest.addParameter(key: ParameterRequest.deviceToken, value: token as AnyObject)
            parameterRequest.addParameter(key: ParameterRequest.deviceType, value: deviceType)
            parameterRequest.addParameter(key: ParameterRequest.isApple, value: SignUPVM.shared.isApple)
            parameterRequest.addParameter(key: ParameterRequest.appleId, value: SignUPVM.shared.appleId)
            parameterRequest.addParameter(key: ParameterRequest.isInsta, value: SignUPVM.shared.isInsta)
            parameterRequest.addParameter(key: ParameterRequest.instaId, value: SignUPVM.shared.instaId)
            parameterRequest.addParameter(key: ParameterRequest.phone, value: SignUPVM.shared.phone)
            parameterRequest.addParameter(key: ParameterRequest.ccode, value: SignUPVM.shared.ccode)
            parameterRequest.addParameter(key: ParameterRequest.isGeoLocation, value: SignUPVM.shared.isGeoLocation)
            parameterRequest.addParameter(key: ParameterRequest.gender, value: SignUPVM.shared.gender)
            parameterRequest.addParameter(key: ParameterRequest.location, value: SignUPVM.shared.location)
            parameterRequest.addParameter(key: ParameterRequest.name, value: SignUPVM.shared.name)
            parameterRequest.addParameter(key: ParameterRequest.Multiprofile, value: SignUPVM.shared.profile)
            parameterRequest.addParameter(key: ParameterRequest.height, value: SignUPVM.shared.height)
            parameterRequest.addParameter(key: ParameterRequest.weight, value: SignUPVM.shared.weight)
            parameterRequest.addParameter(key: ParameterRequest.educationStatus, value: SignUPVM.shared.educationStatus)
            parameterRequest.addParameter(key: ParameterRequest.dob, value: SignUPVM.shared.dob)
            parameterRequest.addParameter(key: ParameterRequest.children, value: SignUPVM.shared.children)
            parameterRequest.addParameter(key: ParameterRequest.wantChildrens, value: SignUPVM.shared.wantChildrens)
            parameterRequest.addParameter(key: ParameterRequest.rank, value: SignUPVM.shared.rankUser)
//            parameterRequest.addParameter(key: ParameterRequest.marringRace, value: SignUPVM.shared.marringRace)
//            parameterRequest.addParameter(key: ParameterRequest.relationshipStatus, value: SignUPVM.shared.relationshipStatus)
//            parameterRequest.addParameter(key: ParameterRequest.ethinicity, value: SignUPVM.shared.ethinicity)
//            parameterRequest.addParameter(key: ParameterRequest.companyName, value: SignUPVM.shared.companyName)
//            parameterRequest.addParameter(key: ParameterRequest.jobTitle, value: SignUPVM.shared.jobTitle)
//            parameterRequest.addParameter(key: ParameterRequest.makeOver, value: SignUPVM.shared.makeOver)
//            parameterRequest.addParameter(key: ParameterRequest.dressSize, value: SignUPVM.shared.dressSize)
//            parameterRequest.addParameter(key: ParameterRequest.signiatBills, value: SignUPVM.shared.signiatBills)
//            parameterRequest.addParameter(key: ParameterRequest.timesOfEngaged, value: SignUPVM.shared.timesOfEngaged)
//            parameterRequest.addParameter(key: ParameterRequest.yourBodyTatto, value: SignUPVM.shared.yourBodyTatto)
//            parameterRequest.addParameter(key: ParameterRequest.ageRangeMarriage, value: SignUPVM.shared.ageRangeMarriage)
//            parameterRequest.addParameter(key: ParameterRequest.mySelfMen, value: SignUPVM.shared.mySelfMen)
//            parameterRequest.addParameter(key: ParameterRequest.aboutYou, value: SignUPVM.shared.aboutYou)
//            parameterRequest.addParameter(key: ParameterRequest.niceMeet, value: SignUPVM.shared.niceMeet)
            
            var files : [[Data]] = [[]]
            var fileNames : [[String]] = [[]]
            var fileKeys : [String] = [""]
            
            for (index,_) in SignUPVM.shared.profile.enumerated() {
                files.append([SignUPVM.shared.profile[index]])
                fileNames.append(["image.jpg"])
                fileKeys.append(ParameterRequest.Multiprofile)
            }
            
            apiClient.SignUp(parameters: parameterRequest.parameters, files: files, fileNames: fileNames, fileKeys: fileKeys) { [self] (resp, respMsg, respCode, err) in
                guard err == nil else {
                    self.errorMessage = err!
                    completion(false)
                    return
                }
                
                if respCode ==  ResponseStatus.success {
                    self.errorMessage = respMsg!
                    if let respDict = resp as? [String:Any] {
                        let UserData = SignUpModel(dict: respDict["data"] as? [String:Any] ?? [String:Any]())
                        AppPrefsManager.shared.setUserData(obj: respDict["data"] as? [String:Any] ?? [String:Any]())
                        
                        AppPrefsManager.shared.setIsUserSignUp(isUserLogin: true)
                        AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)                        
                        AppPrefsManager.shared.saveAuthToken(Token: UserData.token)
                    }
                    
                    completion(true)
                } else {
                 
                    self.errorMessage = respMsg!
                    completion(false)
                }
            }
        }
    }
    

}
