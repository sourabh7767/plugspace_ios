//
//  PreiviewVM.swift
//  PlugSpace
//
//  Created by MAC on 29/11/21.
//

import Foundation
import FirebaseMessaging
import DKImagePickerController

class PreviewVM: BaseVM {
    
    //MARK:- Properties
    
//    var basicInfoArr = ["5ft 9 inch", "145 lbs", "2", "Definitely Single","Asian", "1,20", "2", "2", "2"]
    //    let postArr = ["User_3_Post1", "User_3_Post2", "User_3_Post3"]
    //    let postTitleArr = ["Like if...", "When no one's watching I...", "I'm known for..."]
    //    let postCaptiontArr = ["You are hot and bitter like coffee.", "Practice raising one eyebrow in mirror!", "Losing my phone, keys and my heart"]
    
    var postArr = [Int]()
    var action = ""
    let iconImgArr = ["ic_height_user",
                     "ic_weight_user",
                     "ic_children",
                     "ic_relationship_status",
                     "ic_ethinicity",
                     "ic_make_over",
                     "ic_dress_size",
                     "ic_engaged",
                     "ic_tattoo"]
    
    var userDataPreView : SignUpModel!
    var indexPath:IndexPath!
    var basicInfoArr = [String]()
    var removeMediaId = ""
    var MediaId = ""
    var type = ""
    var feedImage : Data?
    var profileImg : Data?
    var feedId = ""
    var userId = ""
    var isEdit = Bool()
    let imagePickerController = DKImagePickerController()
    let CurrentUserId = SignUpModel.init(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    //MARK:- Method
    
    func previewUpdatePro(completion : @escaping (_ isSuccess: Bool) -> Void) {
            
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value:  userId != "" ? userId : CurrentUserId.userId)
        parameterRequest.addParameter(key: ParameterRequest.removeMediaId, value: removeMediaId)
        parameterRequest.addParameter(key: ParameterRequest.type, value: type)
        parameterRequest.addParameter(key: ParameterRequest.feedId, value: feedId)
       
        
            var files : [[Data]] = [[]]
            var fileNames : [[String]] = [[]]
            var fileKeys : [String] = [""]
        if type == "profile" && isEdit == true
        {
            if let imgdata = profileImg
            {
            files.append([imgdata])
            fileNames.append(["image.jpg"])
            parameterRequest.addParameter(key: ParameterRequest.profileImage, value: profileImg)
            parameterRequest.addParameter(key: ParameterRequest.MediaId, value: MediaId)
            fileKeys.append(ParameterRequest.profileImage)
            }
        }
        else if type == "feed" && isEdit == true{
            if let imgdata = feedImage
            {
                files.append([imgdata])
                fileNames.append(["image.jpg"])
                fileKeys.append(ParameterRequest.feedImage)
            }
               parameterRequest.addParameter(key: ParameterRequest.feedImage, value: feedImage)
              
        }
     
            apiClient.previewUpdatePro(parameters: parameterRequest.parameters, files: files, fileNames: fileNames, fileKeys: fileKeys) { [self] (resp, respMsg, respCode, err) in
                guard err == nil else {
                    self.errorMessage = err!
                    completion(false)
                    return
                }
                
                if respCode ==  ResponseStatus.success {
                    
                    self.errorMessage = respMsg!
                    if let respDict = resp as? [String:Any] {
                        
//                  self.UserData = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
//                  AppPrefsManager.shared.saveAuthToken(Token: userDataPreView.token)
                    AppPrefsManager.shared.setUserData(obj: respDict["data"] as? [String:Any] ?? [String:Any]())
                    userDataPreView = SignUpModel(dict: respDict["data"] as? [String : Any] ?? [String:Any]())

                    }
                    completion(true)
                } else {
                    self.errorMessage = respMsg!
                    completion(false)
                }
        }
    }
    
    
  
    func getMediaDetails(indexpath:IndexPath) -> MediaDetails {
        return userDataPreView.mediaDetail[indexpath.row]
    }
    
}

