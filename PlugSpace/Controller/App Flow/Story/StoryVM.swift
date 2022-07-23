//
//  StoryVM.swift
//  PlugSpace
//
//  Created by MAC on 17/01/22.
//

import Foundation
import FirebaseMessaging

class StoryVM: BaseVM {
    
    //MARK:- Properties
    
    // let yourStoryArr = ["Story_1", "Story_2", "Story_3"]
    // let storyArr = ["Story_4", "Story_5", "Story_6"]
    
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    var userStoryData = [StoryModel]()
    var storyViewDetails = [StoryViewModel]()
    var isLastStory: Bool = false
    var isFirstStory: Bool = false
    var storySegmentBar: SegmentedProgressBar!
    var userStoryDetails = [StoryDetailsModel]()
    var indexUser :IndexPath!
    
    var friendId = ""
    var userComment = ""
    var viewUserID = ""
    var message = ""
    var type = ""
    var extraId = ""
    
    var storyId = ""
    var storyMediaId = ""
    var deviceType = ""
    var deviceToken = ""
    
    //MARK:- Method
    
    func validation() -> Bool {
        
        if userComment.isEmptyOrWhiteSpace {
            
            errorMessage = StringConstant.comment
            
        }else {
            return true
        }
        return false
    }
    
    func storyComment(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.friendId, value: friendId)
        parameterRequest.addParameter(key: ParameterRequest.comment, value: userComment)
        
        apiClient.storyComment(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
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
    
    func getStoryDetails(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.viewUserId, value: viewUserID)
        
        apiClient.getStoryDetails(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.userStoryData = StoryModel.getUserStoryDetails(data: respDict["data"] as? [Any] ?? [Any]())
                    //self.userStoryData.append(contentsOf: StoryModel.getUserStoryDetails(data: respDict["data"] as? [Any] ?? [Any]()))
                }
                
                self.errorMessage = respMsg!
                completion(true)
            } else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    func getMyViewStory(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        
        apiClient.getMyViewStory(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.storyViewDetails = StoryViewModel.getStoryViewDetails(data: respDict["data"] as? [Any] ?? [Any]())
                }
                self.errorMessage = respMsg!
                completion(true)
            } else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    func getStoryViewUserDetails(indexpath:IndexPath) -> StoryViewModel {
        return storyViewDetails[indexpath.row]
    }
    
    func deleteStory(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        if let token = Messaging.messaging().fcmToken {
            
            let parameterRequest = ParameterRequest()
            
            parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
            parameterRequest.addParameter(key: ParameterRequest.storyId, value: storyId)
            parameterRequest.addParameter(key: ParameterRequest.storyMediaId, value: storyMediaId)
            parameterRequest.addParameter(key: ParameterRequest.deviceType, value: "ios")
            parameterRequest.addParameter(key: ParameterRequest.deviceToken, value: token)
            
            apiClient.deleteStory(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
                guard err == nil else {
                    self.errorMessage = err!
                    completion(false)
                    return
                }
                
                if respCode == ResponseStatus.success {
                    
                    self.errorMessage = respMsg!
                    completion(true)
                } else {
                    
                    self.errorMessage = respMsg!
                    completion(false)
                }
            }
        }
    }
    
    func reportValidation() -> Bool {
        if message.isEmptyOrWhiteSpace {
            
            errorMessage = StringConstant.reportReason
            
        }else {
            return true
        }
        return false
    }
    
    func reportStory(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.friendId, value: friendId)
        parameterRequest.addParameter(key: ParameterRequest.extraId, value: extraId)
        parameterRequest.addParameter(key: ParameterRequest.message, value: message)
        parameterRequest.addParameter(key: ParameterRequest.type, value: type)
        
        apiClient.report(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                
                self.errorMessage = respMsg!
                completion(true)
            } else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
