//
//  ChatSegmentVM.swift
//  PlugSpace
//
//  Created by MAC on 11/02/22.
//

import Foundation

class ChatSegmentVM: BaseVM {
    
    //MARK:- Properties
  
    var viewProfileArr = [viewProfileModel]()
    var likeArr = [likeDetailsModel]()
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    //MARK:- Method

    func getChatList(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
      
        apiClient.getChatList(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.viewProfileArr = viewProfileModel.getViewProfileData(data: respDict["view_profile"] as? [Any] ?? [Any]())
                    self.likeArr = likeDetailsModel.getChatData(data: respDict["like_details"] as? [Any] ?? [Any]())
                }
                self.errorMessage = respMsg!
                completion(true)
            }else {
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
