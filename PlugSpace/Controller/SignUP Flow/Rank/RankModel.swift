//
//  RankModel.swift
//  PlugSpace
//
//  Created by MAC on 14/12/21.
//

import Foundation

class RankModel {
    
    var data =  [String]()
   
    init(dict:[String:Any]) {
        
        data  = RankNameModel.getArray(data: dict["data"] as? [Any] ?? [Any]())
    }
    
    class func getRankName(dict:[String:Any]) -> [RankModel]{
        
        var temp = [RankModel]()
        temp.append(RankModel(dict: dict))
        return temp
    }
}

class RankNameModel {
  
        class func getArray(data: [Any]) -> [String] {
            var temp = [String]()
            for dict in data {
                temp.append(dict as? String ?? "")
            }
            return temp
        }
}
