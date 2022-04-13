//
//  SignUPData.swift
//  PlugSpace
//
//  Created by MAC on 14/12/21.
//

import Foundation

class SignUpModel {
    
        var userId = ""
        var name = ""
        var ccode = ""
        var phone = ""
        var isVerified = ""
        var gender = ""
        var womanVank = ""
        var profile = ""
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
        var timesofEngaged = ""
        var yourBodyTatto = ""
        var ageRangeMarriage = ""
        var mySelfMan = ""
        var aboutYou = ""
        var menRank = ""
        var niceMeet = ""
        var token = ""
        var mediaDetail = [MediaDetails]()
        var location = ""
        var age = ""
        var isLike = ""
    
    init(dict:[String:Any]) {
        
         userId = dict["user_id"] as? String ?? ""
         name = dict["name"] as? String ?? ""
         ccode = dict["ccode"] as? String ?? ""
         phone = dict["phone"] as? String ?? ""
         isVerified = dict["is_verified"] as? String ?? ""
         gender = dict["gender"] as? String ?? ""
         womanVank = dict["woman_rank"] as? String ?? ""
         profile = dict["profile"] as? String ?? ""
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
         timesofEngaged = dict["times_of_engaged"] as? String ?? ""
         yourBodyTatto = dict["your_body_tatto"] as? String ?? ""
         ageRangeMarriage = dict["age_range_marriage"] as? String ?? ""
         mySelfMan = dict["my_self_men"] as? String ?? ""
         aboutYou = dict["about_you"] as? String ?? ""
         menRank = dict["rank"] as? String ?? ""
         niceMeet = dict["nice_meet"] as? String ?? ""
         token = dict["token"] as? String ?? ""
         location = dict["location"] as? String ?? ""
         age = dict["age"] as? String ?? ""
         isLike = dict["is_like"] as? String ?? ""
         mediaDetail = MediaDetails.getMediaDetails(data: dict["media_detail"] as? [Any] ?? [Any]())
    }
    class func getUserDetails(data: [String: Any]) -> [SignUpModel] {
        var temp = [SignUpModel]()
            temp.append(SignUpModel(dict: data))
        return temp
    }
}

class MediaDetails {
    
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
    
    class func getMediaDetails(data: [Any]) -> [MediaDetails] {
        var temp = [MediaDetails]()
        for dict in data {
            temp.append(MediaDetails(dict: dict as! [String : Any]))
        }
        return temp
    }
}
