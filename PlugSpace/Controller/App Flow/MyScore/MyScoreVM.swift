//
//  MyScoreVM.swift
//  PlugSpace
//
//  Created by MAC on 29/12/21.
//

import Foundation

class MyScoreVM: BaseVM {
    
    //MARK:- Properties
    
    var isPrivate = ""
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as! [String : Any])
    var userScoreData :MyScoreModel!
    
    //MARK:- Method
    
    func validation() -> Bool {
        errorMessage =  isPrivate.isEmptyOrWhiteSpace ? StringConstant.isPrivate  : ""
        return isPrivate.isEmptyOrWhiteSpace ? false : true
    }
    
    func isPrivateScore(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        parameterRequest.addParameter(key: ParameterRequest.isPrivate, value: isPrivate)
        
        apiClient.isPrivateScore(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
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
    
    func getMyScore(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: userId.userId)
        
        apiClient.getMyScore(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
            
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                if let respDict = resp as? [String:Any] {
                    self.userScoreData = MyScoreModel.init(dict: respDict["data"] as? [String : Any] ?? [String:Any]())
                    completion(true)
                }
                self.errorMessage = respMsg!
                
            }else {
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
