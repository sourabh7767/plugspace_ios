//
//  HomeModel.swift
//  PlugSpace
//
//  Created by MAC on 22/12/21.
//

import Foundation

class HomeModel {
    
    //MARK:- Properties
    
     var userId = ""
     var name = ""
     var ccode = ""
     var phone = ""
     var gender = ""
     var rank = ""
     var isGeoLocation = ""
     var isApple = ""
     var appleId = ""
     var isInsta = ""
     var instaId = ""
     var height = ""
     var weight = ""
     var educationStatus = ""
     var dob = ""
     var children = ""
     var wantChildrens = ""
     var marringRace = ""
     var relationshipStatus = ""
     var ethinicity = ""
     var companyName = ""
     var jobTitle = ""
     var makeOver = ""
     var dressSize = ""
     var signiatBills = ""
     var timesOfEngaged = ""
     var yourBodyTatto = ""
     var ageRangeMarriage = ""
     var mySelfMen = ""
     var aboutYou = ""
     var niceMeet = ""
     var mediaDetail = [UserMediaDetail]()
     var location = ""
     var age = ""
     var isLike = ""
    
    init(dict:[String:Any]) {
        
        userId = dict["user_id"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        ccode = dict["ccode"] as? String ?? ""
        phone = dict["phone"] as? String ?? ""
        gender = dict["gender"] as? String ?? ""
        rank = dict["rank"] as? String ?? ""
        isGeoLocation = dict["is_geo_location"] as? String ?? ""
        isApple = dict["is_apple"] as? String ?? ""
        appleId = dict["apple_id"] as? String ?? ""
        isInsta = dict["is_insta"] as? String ?? ""
        instaId = dict["insta_id"] as? String ?? ""
        height = dict["height"] as? String ?? ""
        weight = dict["weight"] as? String ?? ""
        educationStatus = dict["education_status"] as? String ?? ""
        dob = dict["dob"] as? String ?? ""
        children = dict["children"] as? String ?? ""
        wantChildrens = dict["want_childrens"] as? String ?? ""
        marringRace = dict["marring_race"] as? String ?? ""
        relationshipStatus = dict["relationship_status"] as? String ?? ""
        ethinicity = dict["ethinicity"] as? String ?? ""
        companyName = dict["company_name"] as? String ?? ""
        jobTitle = dict["job_title"] as? String ?? ""
        makeOver = dict["make_over"] as? String ?? ""
        dressSize = dict["dress_size"] as? String ?? ""
        signiatBills = dict["signiat_bills"] as? String ?? ""
        timesOfEngaged = dict["times_of_engaged"] as? String ?? ""
        yourBodyTatto = dict["your_body_tatto"] as? String ?? ""
        ageRangeMarriage = dict["age_range_marriage"] as? String ?? ""
        mySelfMen = dict["my_self_men"] as? String ?? ""
        aboutYou = dict["about_you"] as? String ?? ""
        niceMeet = dict["nice_meet"] as? String ?? ""
        mediaDetail = UserMediaDetail.getMediaDetails(data: dict["media_detail"] as? [Any] ?? [Any]())
        location = dict["location"] as? String ?? ""
        age = dict["age"] as? String ?? ""
        isLike = dict["is_like"] as? String ?? ""
    }
    
    class func getHomeDetails(data: [Any]) -> [HomeModel] {
        var temp = [HomeModel]()
        for data in data {
            temp.append(HomeModel(dict: data as! [String : Any]))
        }
        return temp
    }
}

class UserMediaDetail {
    
    var media_id = ""
    var user_id = ""
    var profile = ""
    var media_type = ""
    var type = ""
    var description = ""
    var feedId = ""
    var feedImage = ""
    
    init(dict:[String:Any]) {
        
        media_id = dict["media_id"] as? String ?? ""
        user_id = dict["user_id"] as? String ?? ""
        profile = dict["profile"] as? String ?? ""
        media_type = dict["media_type"] as? String ?? ""
        type = dict["type"] as? String ?? ""
        description = dict["description"] as? String ?? ""
        feedId = dict["feed_id"] as? String ?? ""
        feedImage = dict["feed_image"] as? String ?? ""
    }
    
    class func getMediaDetails(data: [Any]) -> [UserMediaDetail] {
        var temp = [UserMediaDetail]()
        for dict in data {
            temp.append(UserMediaDetail(dict: dict as! [String : Any]))
        }
        return temp
    }
}

class StoryDetailsModel {
    
     var storyId = ""
     var userId = ""
     var name = ""
     var profile = ""
     var isShowStory = ""
    
    init(dict:[String:Any]) {
        storyId = dict["story_id"] as? String ?? ""
        userId = dict["user_id"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        profile = dict["profile"] as? String ?? ""
        isShowStory = dict["is_show_story"] as? String ?? ""
    }
    
    class func getStoryDetails(data: [Any]) -> [StoryDetailsModel] {
        var temp = [StoryDetailsModel]()
        for data in data {
            temp.append(StoryDetailsModel(dict: data as! [String : Any]))
        }
        return temp
    }
}

class NotificationDetailsModel {

     var cellType = ""
     var notiId = ""
     var userId = ""
     var message = ""
     var dateTime = ""
     var name = ""
     var profile = ""
     var createdDate = ""
     var time : Int64
     var key: String
     var otherId = ""
    
    init(key: String,dict:[String:Any]) {
      
        self.key = key
        notiId = dict["noti_id"] as? String ?? ""
        userId = dict["user_id"] as? String ?? ""
        otherId = dict["other_id"] as? String ?? ""
        message = dict["message"] as? String ?? ""
        dateTime = dict["date_time"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        profile = dict["profile"] as? String ?? ""
        createdDate = dict["created_date"] as? String ?? ""
        cellType = dict["cellType"] as? String ?? ""
        time = dict["time"] as? Int64 ?? 0
    }
    
    class func getNotificationDetails(data: [Any]) -> [NotificationDetailsModel] {
        var temp = [NotificationDetailsModel]()
        for data in data {
           
            temp.append(NotificationDetailsModel(key: "", dict: data as? [String : Any] ?? [String:Any]()))
            
        }
        return temp
    }
}
