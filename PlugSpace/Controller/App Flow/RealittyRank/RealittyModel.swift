//
//  RealityModel.swift
//  PlugSpace
//
//  Created by MAC on 08/01/22.
//

import Foundation

class PlugspaceModel: BaseVM {
    
    var rank = ""
    var isPrivate = ""
    var plugspaceRank = ""
    var characteristics = [characteristicsModel]()
    
    init(dict:[String:Any]) {
        
        rank = dict["rank"] as? String ?? ""
        isPrivate = dict["is_private"] as? String ?? ""
        plugspaceRank = dict["plugspace_rank"] as? String ?? ""
        characteristics = characteristicsModel.getFrendsScore(data: dict["characteristics"] as? [Any] ?? [Any]())
    }
    
    class func getFrendsScore(data:[String:Any]) -> [PlugspaceModel] {
        
        var temp = [PlugspaceModel]()
        temp.append(PlugspaceModel(dict: data))
        return temp
    }
}

class characteristicsModel {
    
        var id = ""
        var rank = ""
        var name = ""
        var text = ""
    
    init(dict:[String:Any]) {
        
        id = dict["id"] as? String ?? ""
        rank = dict["rank"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        text = dict["text"] as? String ?? ""
    }
    
    class func getFrendsScore(data:[Any]) -> [characteristicsModel] {
        
        var temp = [characteristicsModel]()
        for dict in data {
            temp.append(characteristicsModel(dict: dict as! [String : Any]))
        }
        return temp
    }
}
