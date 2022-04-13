//
//  DobVM.swift
//  PlugSpace
//
//  Created by MAC on 28/12/21.
//

import Foundation
import UIKit

class DobVM: BaseVM {
    
    //MARK:- Properties
    
    var date : UIDatePicker = UIDatePicker()
    var dob = ""
    var dateArr = [DobModel]()
   
    //MARK:- Method
   
    func validation() -> Bool {
        
        if dob.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.dob
        }
        else {
            return true
        }
        return false
    }
    
    func ageCalculator(completion : @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.dob, value: dob)
       
        
        apiClient.ageCalculator(parameter: parameterRequest.parameters) { [self] (resp, respMsg, respCode, err) in
            guard err == nil else {
            
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
               
                dateArr = DobModel.getDateDetails(data: resp as! [String : Any])
                self.errorMessage = respMsg!
                completion(true)
            }else {
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
