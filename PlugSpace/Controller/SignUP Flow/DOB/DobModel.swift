//
//  DobModel.swift
//  PlugSpace
//
//  Created by MAC on 28/12/21.
//

import Foundation

class DobModel {

    var data = ""
    var ResponseCode = ""
    var ResponseMsg = ""
    var Result = ""
    var ServerTime = ""
    
    init(dict:[String:Any]) {
        
        data =  dict["data"] as? String ?? ""
        ResponseCode =  dict["ResponseCode"] as? String ?? ""
        ResponseMsg =  dict["ResponseMsg"] as? String ?? ""
        Result =  dict["Result"] as? String ?? ""
        ServerTime =  dict["ServerTime"] as? String ?? ""
        
    }
    
    class func getDateDetails(data: [String: Any]) -> [DobModel] {
        var temp = [DobModel]()
            temp.append(DobModel(dict: data))
        return temp
    }
    
}
