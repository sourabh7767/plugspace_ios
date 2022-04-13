//
//  ContactUsVM.swift
//  PlugSpace
//
//  Created by MAC on 07/01/22.
//

import Foundation

class ContactUsVM: BaseVM {
    
    //MARK:- Properties
    
    var email = ""
    var name = ""
    var subject = ""
    var message = ""
    
    
    //MARK:- Method
    
    func validation() -> Bool {
        
        if email.isEmptyOrWhiteSpace {
            errorMessage = StringConstant.email
        }else if name.isEmptyOrWhiteSpace {
            errorMessage = StringConstant.name
        }else if subject.isEmptyOrWhiteSpace {
            errorMessage = StringConstant.subject
        }else if message.isEmptyOrWhiteSpace {
            errorMessage = StringConstant.message
        }else {
            return true
        }
        return false
    }
    
    
    func contactUs(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.email, value: email)
        parameterRequest.addParameter(key: ParameterRequest.name, value: name)
        parameterRequest.addParameter(key: ParameterRequest.subject, value: subject)
        parameterRequest.addParameter(key: ParameterRequest.message, value: message)
        
        apiClient.contactUs(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
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
    
}
