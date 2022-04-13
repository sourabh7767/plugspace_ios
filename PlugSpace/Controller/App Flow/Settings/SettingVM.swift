//
//  SettingVM.swift
//  PlugSpace
//
//  Created by MAC on 14/12/21.
//

import Foundation

class SettingVM: BaseVM {
    
    //MARK:- Properties
    
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as! [String : Any])

    //MARK:-Method
    
    func logOut(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        
        apiClient.logOut(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success{
                self.errorMessage = respMsg!
                completion(true)
            }else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}

