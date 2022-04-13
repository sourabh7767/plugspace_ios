//
//  RealittyVM.swift
//  PlugSpace
//
//  Created by MAC on 08/01/22.
//

import Foundation

class PlugspaceScoreVM: BaseVM {
    
    //MARK:- Properties
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as! [String : Any])
    var scoreData : PlugspaceModel!
    var friendUserId = ""
    
    //MARK:- Method
    
    func getFriendsScore(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.friendUserId, value: friendUserId)
        
        apiClient.getFriendsScore(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.scoreData = PlugspaceModel.init(dict: respDict["data"] as? [String:Any] ?? [String:Any]())
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
