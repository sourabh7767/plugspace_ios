//
//  HomeVM.swift
//  PlugSpace
//
//  Created by MAC on 29/11/21.
//

import Foundation

class HomeVM:BaseVM {
    
    //MARK:- Properties
    
//    let nameArr = ["Your Story", "Tom", "Matheus", "Justin", "Kylie", "Lauren"]
    
//    let imgArr = ["img_nt_7", "img_nt_4", "img_nt_1", "img_nt_3", "img_nt_5", "img_nt_6",]
    //    let basicInfoArr = ["5ft 9 inch", "145 lbs", "2", "Definitely Single","Asian", "1,20", "2", "2", "2"]
    
    
//    let postArr = ["userPost1", "userPost2", "userPost3"]
//    let postTitleArr = ["Never have I ever...", "Hello, my love, you see?", "Hello you,"]
//    let postCaptionArr = ["Caught feelings for anyone on a dating app 🤝", "As soon as I wake up I think of you. Have a good day!", "I missed your arms last night, I can’t wait to be this afternoon."]
    
    let iconImgArr = ["ic_height_user",
                      "ic_weight_user",
                      "ic_children",
                      "ic_relationship_status",
                      "ic_ethinicity",
                      "ic_make_over",
                      "ic_dress_size",
                      "ic_engaged",
                      "ic_tattoo"]
    
    var userdata = [HomeModel]()
    var storyData = [StoryDetailsModel]()
    var notificationData = [NotificationDetailsModel]()
    
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    var basicInfoArr = [String]()
    var likeUserId = ""
    var likeType = ""
    var viewUserID = ""
    var removeMediaId = ""
    var type = ""
    var feedImage = ""
    var feedId = ""
    var searchText = ""
    
    //MARK:- Method
    
    func validation() -> Bool {
        
        if likeUserId.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.likeUserID
        } else if likeType.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.likeType
        }
        else {
            return true
        }
        return false
    }
    
    func profileLikeDislike(_ comment: String?, _ message: String?, completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.likeUserId, value: likeUserId)
        parameterRequest.addParameter(key: ParameterRequest.likeType, value: likeType)
        parameterRequest.addParameter(key: "comment", value: comment)
        parameterRequest.addParameter(key: "message", value: message)
        
        apiClient.profileLikeDislike(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                
                self.errorMessage = respMsg!
                completion(true)
            }else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    func getDefaultMessages(completion: @escaping (_ isSuccess: [String]) -> ()) {
        apiClient.getDefaultMessages { response, responsemessage, resCode, errorStr in
            guard errorStr == nil else {
                self.errorMessage = errorStr!
                completion([])
                return
            }
            if resCode == ResponseStatus.success {
                if let respDict = response as? [String:Any] {
                    let messages = respDict["message"] as? [[String: Any]] ?? []
                    let msgs = messages.map({$0["message"] as? String ?? ""}).filter({!$0.isEmpty})
                    completion(msgs)
                }
                
            }else {
                
                self.errorMessage = responsemessage ?? ""
                completion([])
            }
        }
    }
    
    func getHomeDetails(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
            parameterRequest.addParameter(key: ParameterRequest.searchText, value: searchText)
            parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        
        apiClient.getHomeDetails(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.userdata = HomeModel.getHomeDetails(data: respDict["data"] as? [Any] ?? [Any]())
                    self.storyData = StoryDetailsModel.getStoryDetails(data: respDict["storyDtl"] as? [Any] ?? [Any]())
                    self.notificationData = NotificationDetailsModel.getNotificationDetails(data: respDict["notificationDtl"] as? [Any] ?? [Any]())
                }
                self.errorMessage = respMsg!
                completion(true)
            }else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    func validationViewStory() -> Bool {
        
        if viewUserID.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.viewUserID
        }
        else {
            return true
        }
        return false
    }
    
    func createViewStory(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.viewUserId, value: viewUserID)
        
        apiClient.createViewStory(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                self.errorMessage = respMsg!
                completion(true)
            }else {
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    func getStoryDetails(IndexPath:IndexPath) -> StoryDetailsModel {
        return storyData[IndexPath.row]
    }
    
    func getNotificationDetails(IndexPath:IndexPath) -> NotificationDetailsModel {
        return notificationData[IndexPath.row]
    }
    
    func getMediaDetails(indexPath:IndexPath) -> UserMediaDetail {
        return userdata[0].mediaDetail[indexPath.row]
    }
    
    //  func previewUpdatePro(completion : @escaping (_ isSuccess: Bool) -> Void) {
    //
    //        let parameterRequest = ParameterRequest()
    //
    //        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
    //        parameterRequest.addParameter(key: ParameterRequest.removeMediaId, value: removeMediaId)
    //        parameterRequest.addParameter(key: ParameterRequest.type, value: type)
    //        parameterRequest.addParameter(key: ParameterRequest.feedImage, value: feedImage)
    //        parameterRequest.addParameter(key: ParameterRequest.feedId, value: feedId)
    //
    //        apiClient.previewUpdatePro(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
    //            guard err == nil else {
    //                self.errorMessage = err!
    //                completion(false)
    //                return
    //            }
    //
    //            if respCode == ResponseStatus.success {
    //
    //                self.errorMessage = respMsg!
    //                completion(true)
    //            } else {
    //
    //                self.errorMessage = respMsg!
    //                completion(false)
    //            }
    //        }
    //    }
}
