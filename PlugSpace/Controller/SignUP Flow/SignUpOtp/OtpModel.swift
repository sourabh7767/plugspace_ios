//
//  OtpModel.swift
//  PlugSpace
//
//  Created by MAC on 14/12/21.
//

import Foundation

class OtpModel {
    
    var otpcode : String?
    var ResponseCode :String?
    var ResponseMsg : String?
    var Result : String?
    var ServerTime : String?
    
    init(dict:[String:Any]) {
        
        otpcode  = dict["otpcode"] as? String ?? ""
        ResponseCode  = dict["ResponseCode"] as? String ?? ""
        ResponseMsg  = dict["ResponseMsg"] as? String ?? ""
        Result  = dict["Result"] as? String ?? ""
        ServerTime  = dict["ServerTime"] as? String ?? ""
    }
    
    class func getotp(dict:[String:Any]) -> [OtpModel]{
        
        var temp = [OtpModel]()
        temp.append(OtpModel(dict: dict))
        return temp
    }
    
}
