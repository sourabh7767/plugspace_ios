//
//  RankVM.swift
//  PlugSpace
//
//  Created by MAC on 14/12/21.
//

import Foundation
import FirebaseMessaging

class RankVM: BaseVM {
    
    //MARK:- Properties
    
    var rank = ""
    var gender = ""
    var rankNameArr = [RankModel]()
    
    
    //MARK:-Method
    
    func validation() -> Bool {
        
        if rank.isEmptyOrWhiteSpace {
            self.errorMessage = StringConstant.rankUser
        }
        else {
            return true
        }
        return false
    }
    
    func getManRankPerson(completion : @escaping (_ isSuccess: Bool) -> Void)   {
        
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.rank, value: rank)
        parameterRequest.addParameter(key: ParameterRequest.gender, value: gender)
        
        apiClient.getRankPerson(parameter: parameterRequest.parameters) { (resp, respMsg, respCode, err) in
           
            guard err == nil else {
                self.errorMessage = err!
                completion(false)
                return
            }
            
            if respCode == ResponseStatus.success {
                
                self.rankNameArr = RankModel.getRankName(dict: resp as! [String : Any])
                self.errorMessage = respMsg!
                completion(true)
                
            } else {
                
                self.errorMessage = respMsg!
                completion(false)
            }
        }
    }
}
