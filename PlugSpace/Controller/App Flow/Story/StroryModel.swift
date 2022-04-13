//
//  StoryModel.swift
//  PlugSpace
//
//  Created by MAC on 17/01/22.
//

import Foundation

class StoryModel {
    
     var storyId = ""
     var userId = ""
     var count : Int
     var storyMediaDetail = [StoryDetails]()
                    
    init(dict:[String:Any]) {
        storyId = dict["story_id"] as? String ?? ""
        count = dict["count"] as? Int ?? 0
        userId = dict["user_id"] as? String ?? ""
        storyMediaDetail = StoryDetails.getStoryDetails(data: dict["story_media_detail"] as? [Any] ?? [Any]())
    }
    
    class func getUserStoryDetails(data:[Any]) -> [StoryModel] {
        var temp = [StoryModel]()
        
        for details in data {
            temp.append(StoryModel(dict: details as? [String : Any] ?? [String:Any]()))
        }
        return temp
    }
}

class StoryDetails {
    
    var storyMediaId =  ""
    var storyId =  ""
    var media =  ""
    var mediaType =  ""
    var dateTime =  ""
    
    init(dict:[String:Any]) {
        storyMediaId = dict["story_media_id"] as? String ?? ""
        storyId = dict["story_id"] as? String ?? ""
        media = dict["media"] as? String ?? ""
        mediaType = dict["media_type"] as? String ?? ""
        dateTime = dict["date_time"] as? String ?? ""
    }
    
    class func getStoryDetails(data:[Any]) -> [StoryDetails] {
        var temp = [StoryDetails]()
        
        for details in data {
            temp.append(StoryDetails(dict: details as? [String : Any] ?? [String:Any]()))
        }
        return temp
    }
}

class StoryViewModel {
    
     var viewStoryId = ""
     var userId = ""
     var viewUserId = ""
     var dateTime = ""
     var name = ""
     var jobTitle = ""
     var age = ""
     var profile = ""
    
    init(data:[String:Any]) {
        
        viewStoryId = data["view_story_id"] as? String ?? ""
        userId = data["user_id"] as? String ?? ""
        viewUserId = data["view_user_id"] as? String ?? ""
        dateTime = data["date_time"] as? String ?? ""
        name = data["name"] as? String ?? ""
        jobTitle = data["job_title"] as? String ?? ""
        age = data["age"] as? String ?? ""
        profile = data["profile"] as? String ?? ""
    }
    
    class func getStoryViewDetails(data:[Any]) -> [StoryViewModel] {
        
        var temp = [StoryViewModel]()
        
        for dict in data {
            temp.append(StoryViewModel(data: dict as? [String : Any] ?? [String:Any]()))
        }
        return temp
    }
}
