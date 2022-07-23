//
//  SavedProfileVM.swift
//  PlugSpace
//
//  Created by Kaushal on 25/06/22.
//

import Foundation
class SavedProfileVM: BaseVM {
    var superVc: ChatSegmentVC!
    var SavedUserArr = [SavedProfileModel]()
    var SavedUserSearchArr = [SavedProfileModel]()
    
    
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    func getSavedProfile(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        
        apiClient.GetSavedOtherProfile(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if let respDict = resp as? [String:Any]//respCode == ResponseStatus.success
            {
               
                 self.SavedUserArr = SavedProfileModel.getSavedProfileData(data: respDict["message"] as? [Any] ?? [Any]())
                 self.errorMessage = respMsg!
                completion(true)
            } else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
    
    
    
    
    
}
