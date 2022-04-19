//
//  MatchAndChatModel.swift
//  PlugSpace
//
//  Created by MAC on 19/01/22.
//

import Foundation

class ChatListModel {
    
    //MARK:- Properties
    
        var device_token = ""
        var device_type = ""
        var message = ""
        var name = ""
        var profile = ""
        var read_count = ""
        var time : Int64
        var user_id = ""
        
        init?(dict: [String:Any]) {
            self.device_token = dict["device_token"] as? String ?? ""
            self.device_type = dict["device_type"] as? String ?? ""
            self.message = dict["message"] as? String ?? ""
            self.name = dict["name"] as? String ?? ""
            self.profile = dict["profile"] as? String ?? "0"
            self.read_count = dict["read_count"] as? String ?? ""
            self.time = dict["time"] as? Int64 ?? 0
            self.user_id = dict["user_id"] as? String ?? ""
        }
}

class viewProfileModel {
    
    var viewId = ""
    var userId = ""
    var viewUserId = ""
    var viewType = ""
    var dateTime = ""
    var name = ""
    var jobTitle = ""
    var age = ""
    var profile = ""
    
    init(dict:[String:Any]) {
        
        viewId = dict["view_id"] as? String ?? ""
        userId = dict["user_id"] as? String ?? ""
        viewUserId = dict["view_user_id"] as? String ?? ""
        viewType = dict["view_type"] as? String ?? ""
        dateTime = dict["date_time"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        jobTitle = dict["job_title"] as? String ?? ""
        age = dict["age"] as? String ?? ""
        profile = dict["profile"] as? String ?? ""
    }
    
    class func getViewProfileData(data:[Any]) -> [viewProfileModel] {
        
        var temp = [viewProfileModel]()
        for dict in data {
            temp.append(viewProfileModel(dict: dict as? [String:Any] ?? [String:Any]()))
        }
        return temp
    }
}

class likeDetailsModel {
    
    var likeId = ""
    var userId = ""
    var likeUserId = ""
    var likeType = ""
    var dateTime = ""
    var name = ""
    var jobTitle = ""
    var age = ""
    var profile = ""
    var comment = ""
    
    init(dict:[String:Any]) {
        comment = dict["comment"] as? String ?? ""
        likeId = dict["like_id"] as? String ?? ""
        userId = dict["user_id"] as? String ?? ""
        likeUserId = dict["like_user_id"] as? String ?? ""
        likeType = dict["like_type"] as? String ?? ""
        dateTime = dict["date_time"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        jobTitle = dict["job_title"] as? String ?? ""
        age = dict["age"] as? String ?? ""
        profile = dict["profile"] as? String ?? ""
    }
    
   class func getChatData(data:[Any]) -> [likeDetailsModel] {
        
        var temp = [likeDetailsModel]()
        for dict in data {
            temp.append(likeDetailsModel(dict: dict as? [String:Any] ?? [String:Any]()))
        }
        return temp
    }
}
