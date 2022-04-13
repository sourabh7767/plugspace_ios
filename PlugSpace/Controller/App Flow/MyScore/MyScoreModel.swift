//
//  MyScoreModel.swift
//  PlugSpace
//
//  Created by MAC on 07/01/22.
//

import Foundation

class MyScoreModel {
    
    var rank = ""
    var isPrivate = ""
    var plugSpaceRank = ""
    var characteristics = [MyCharacteristicsModel]()

    init(dict:[String: Any]) {
        
      rank = dict["rank"] as? String ?? ""
      isPrivate = dict["is_private"] as? String ?? ""
      plugSpaceRank = dict["plugspace_rank"] as? String ?? ""
      characteristics = MyCharacteristicsModel.getFrendsScore(data: dict["characteristics"] as? [Any] ?? [Any]())
    }
    
    class func getScore(data:[String:Any]) -> [MyScoreModel] {
        
        var temp = [MyScoreModel]()
            temp.append(MyScoreModel(dict: data))

        return temp
    }
}

class MyCharacteristicsModel {
    
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
    
    class func getFrendsScore(data:[Any]) -> [MyCharacteristicsModel] {
        
        var temp = [MyCharacteristicsModel]()
        for dict in data {
            temp.append(MyCharacteristicsModel(dict: dict as! [String : Any]))
        }
        return temp
    }
}
