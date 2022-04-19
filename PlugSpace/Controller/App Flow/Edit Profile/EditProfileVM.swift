//
//  EditProfileVM.swift
//  PlugSpace
//
//  Created by MAC on 26/11/21.
//

import Foundation
import UIKit
import FirebaseMessaging
import DKImagePickerController

class EditProfileVM:BaseVM {
    
    //MARK:- DropDown Array
    
    let genderArr  = ["Biologically Female","Biologically Male","Trans Male","Trans Female","Other"]
    let educationStatusArr  = ["High School","Bachelor","Vocational School","PHD","Some College","Advanced Degree","Associate Degree ","BMA","Other"]
    let Children  = ["0","1","2","3","4","5"]
    let marryingOtherRace = ["Yes","No"]
    let RelationshipStatus = ["Definitely Single","Separated","Divorced","Windowed"]
    let ethinicityArr = ["India","Hispanic / Latin","Pacific Islander","Black","Asian","Middle Eastern","Native American","Caucasian","Other"]
    let DressSize = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26"]
    let manyTimesEngaged = ["0","1","2","3","4","5"]
    let tattooArr = ["0","1","2","3","4","5"]
    let niceMeetArr = ["Woman","Man","All"]
    let title = ["Capture photo","Phone Library"]
    let HeightArray = ["3'0","3'1","3'2","3'3","3'4","3'5","3'6","3'7","3'8","3'9","3'10","3'11","4'0","4'1","4'2","4'3","4'4","4'5","4'6","4'7","4'8","4'9","4'10","4'11","5'0","5'1","5'2","5'3","5'4","5'5","5'6","5'7","5'8","5'9","5'10","5'11","6'0","6'1","6'2","6'3","6'4","6'5","6'6","6'7","6'8","6'9","6'10","6'11","7'0","7'1","7'2","7'3","7'4","7'5","7'6","7'7","7'8"]
    let considerMyselfType = ["Feminine", "Beta", "Professional", "Gamma", "Sigma", "Regular Guy", "Delta", "Alpha", "Standard Guy", "Celebrity", "Middle Class", "Other"]
    var WeightArray = [String]()
    let imagePickerController = DKImagePickerController()
    let weightValue = 400
    
    //MARK:- Properties
    
    var profileTotalImageArr = [Int]()
    let imagePicker = UIImagePickerController()
    var index = 0
    var date : UIDatePicker = UIDatePicker()
    
    var name = ""
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
    var timesOfEngaged = ""
    var yourBodyTatto = ""
    var ageRangeMarriage = ""
    var mySelfMen = ""
    var niceMeet = ""
    var deviceType = "ios"
    var deviceToken = ""
    var profile = [Data]()
    var jobTitle = ""
    var aboutYou = ""
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    var removeMediaId = ""
    var type = ""
    var feedImage = Data()
    var rank = ""
    var rankNameArr = [RankModel]()


    //MARK:- Method
    
    func validation() -> Bool {
        
         if gender.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.gender
        } else if name.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.name
        } else if profile.count == 0 {
            self.errorMessage = StringConstant.photoValidation
        } else if height.isEmptyOrWhiteSpace{
            self.errorMessage = StringConstant.height
        } else if weight.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.weight
        } else if educationStatus.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.educationStatus
        } else if dob.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.dob
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
        } else {
            return true
        }
        
        return false
        
    }
    
    func updateProfile(completion : @escaping (_ isSuccess: Bool) -> Void) {
            
        if let token = Messaging.messaging().fcmToken {
            
            let parameterRequest = ParameterRequest()
            
            parameterRequest.addParameter(key: ParameterRequest.deviceToken, value: token as AnyObject)
            parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
            parameterRequest.addParameter(key: ParameterRequest.deviceType, value: deviceType)
            parameterRequest.addParameter(key: ParameterRequest.phone, value: userId.phone)
            parameterRequest.addParameter(key: ParameterRequest.ccode, value: userId.ccode)
            parameterRequest.addParameter(key: ParameterRequest.isGeoLocation, value: isGeoLocation)
            parameterRequest.addParameter(key: ParameterRequest.gender, value: gender)
            parameterRequest.addParameter(key: ParameterRequest.location, value: location)
            parameterRequest.addParameter(key: ParameterRequest.name, value: name)
            parameterRequest.addParameter(key: ParameterRequest.rank, value: userId.menRank)
            parameterRequest.addParameter(key: ParameterRequest.Multiprofile, value: profile)
            parameterRequest.addParameter(key: ParameterRequest.height, value: height)
            parameterRequest.addParameter(key: ParameterRequest.weight, value: weight)
            parameterRequest.addParameter(key: ParameterRequest.educationStatus, value: educationStatus)
            parameterRequest.addParameter(key: ParameterRequest.dob, value: dob)
            parameterRequest.addParameter(key: ParameterRequest.children, value: children)
            parameterRequest.addParameter(key: ParameterRequest.wantChildrens, value: wantChildrens)
            parameterRequest.addParameter(key: ParameterRequest.marringRace, value: marringRace)
            parameterRequest.addParameter(key: ParameterRequest.relationshipStatus, value: relationshipStatus)
            parameterRequest.addParameter(key: ParameterRequest.ethinicity, value: ethinicity)
            parameterRequest.addParameter(key: ParameterRequest.companyName, value: companyName)
            parameterRequest.addParameter(key: ParameterRequest.jobTitle, value: jobTitle)
            parameterRequest.addParameter(key: ParameterRequest.makeOver, value: makeOver)
            parameterRequest.addParameter(key: ParameterRequest.dressSize, value: dressSize)
            parameterRequest.addParameter(key: ParameterRequest.signiatBills, value: userId.signiatBills)
            parameterRequest.addParameter(key: ParameterRequest.timesOfEngaged, value: timesOfEngaged)
            parameterRequest.addParameter(key: ParameterRequest.yourBodyTatto, value: yourBodyTatto)
            parameterRequest.addParameter(key: ParameterRequest.ageRangeMarriage, value: ageRangeMarriage)
            parameterRequest.addParameter(key: ParameterRequest.mySelfMen, value: mySelfMen)
            parameterRequest.addParameter(key: ParameterRequest.aboutYou, value: aboutYou)
            parameterRequest.addParameter(key: ParameterRequest.niceMeet, value: niceMeet)
            parameterRequest.addParameter(key: ParameterRequest.rank, value: rank)
            
            var files : [[Data]] = [[]]
            var fileNames : [[String]] = [[]]
            var fileKeys : [String] = [""]
            
            if profile.count != 0 {
                for (index,_) in profile.enumerated() {
                    files.append([profile[index]])
                    fileNames.append(["image.jpg"])
                    fileKeys.append(ParameterRequest.Multiprofile)
                }
                
                apiClient.updateProfile(parameters: parameterRequest.parameters, files: files, fileNames: fileNames, fileKeys: fileKeys) { [self] (resp, respMsg, respCode, err) in
                    guard err == nil else {
                        self.errorMessage = err!
                        completion(false)
                        return
                    }
                    
                    if respCode ==  ResponseStatus.success {
                        
                        if let respDict = resp as? [String:Any] {
                           let UserData = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
                           
                            AppPrefsManager.shared.setUserData(obj: respDict["data"] as? [String:Any] ?? [String:Any]())
                            AppPrefsManager.shared.saveAuthToken(Token: UserData.token)
                        }
                        self.errorMessage = respMsg!
                        completion(true)
                    } else {
                        self.errorMessage = respMsg!
                        completion(false)
                    }
                }
                
            } else {
                apiClient.updateData(parameters: parameterRequest.parameters) { [self] (resp, respMsg, respCode, err) in
                    guard err == nil else {
                        self.errorMessage = err!
                        completion(false)
                        return
                    }
                    
                    if respCode ==  ResponseStatus.success {
                        
                        if let respDict = resp as? [String:Any] {
                           let UserData = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
                            AppPrefsManager.shared.setUserData(obj: respDict["data"] as? [String:Any] ?? [String:Any]())
                            
                            AppPrefsManager.shared.saveAuthToken(Token: UserData.token)
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
    }
    
    func previewDelete(completion : @escaping (_ isSuccess: Bool) -> Void) {
            
        let parameterRequest = ParameterRequest()
            
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.removeMediaId, value: removeMediaId)
        parameterRequest.addParameter(key: ParameterRequest.type, value: type)
        
            var files : [[Data]] = [[]]
            var fileNames : [[String]] = [[]]
            var fileKeys : [String] = [""]
            
                files.append([feedImage])
                fileNames.append(["image.jpg"])
                fileKeys.append(ParameterRequest.feedImage)
            
            apiClient.previewUpdatePro(parameters: parameterRequest.parameters, files: files, fileNames: fileNames, fileKeys: fileKeys) { [self] (resp, respMsg, respCode, err) in
                guard err == nil else {
                    self.errorMessage = err!
                    completion(false)
                    return
                }
                
                if respCode ==  ResponseStatus.success {
                    self.errorMessage = respMsg!
                    if let respDict = resp as? [String:Any] {
                        
                        let UserData = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
                        AppPrefsManager.shared.setUserData(obj: respDict["data"] as? [String:Any] ?? [String:Any]())
                        
                        AppPrefsManager.shared.saveAuthToken(Token: UserData.token)
                    }
                    completion(true)
                } else {
                 
                    self.errorMessage = respMsg!
                    completion(false)
                }
        }
    }
    
    func getManRankPerson(completion : @escaping (_ isSuccess: Bool) -> Void)   {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.rank, value: rank)
        parameterRequest.addParameter(key: ParameterRequest.gender, value: gender)
        
        apiClient.getRankPerson(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
           
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                
                self.rankNameArr = RankModel.getRankName(dict: resp as! [String : Any])
                self.errorMessage = respMsg!
                completion(true)
                
            } else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
