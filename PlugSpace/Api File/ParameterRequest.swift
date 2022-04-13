//
//  ApiParameter.swift
//
//
//  Created by MAC on 28/03/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

class ParameterRequest {
    init() {}
    
    var parameters = [String: Any]()

    // Common
    
    static let userId = "user_id"
    
    //Signup
    
    static let isSignup = "is_signup"
    static let name = "name"
    static let ccode = "ccode"
    static let phone = "phone"
    static let isVerified = "is_verified"
    static let gender = "gender"
    static let womanRank = "woman_rank"
    static let isGeoLocation = "is_geo_location"
    static let height = "height"
    static let weight = "weight"
    static let educationStatus = "education_status"
    static let dob = "dob"
    static let children = "children"
    static let wantChildrens = "want_childrens"
    static let marringRace = "marring_race"
    static let relationshipStatus = "relationship_status"
    static let ethinicity = "ethinicity"
    static let companyName = "company_name"
    static let makeOver = "make_over"
    static let dressSize = "dress_size"
    static let signiatBills = "signiat_bills"
    static let timesOfEngaged = "times_of_engaged"
    static let yourBodyTatto = "your_body_tatto"
    static let ageRangeMarriage = "age_range_marriage"
    static let mySelfMen = "my_self_men"
    static let niceMeet = "nice_meet"
    static let deviceType = "device_type"
    static let deviceToken = "device_token"
    static let profile = "profile"
    static let jobTitle = "job_title"
    static let aboutYou = "about_you"
    static let isApple = "is_apple"
    static let appleId = "apple_id"
    static let isInsta = "is_insta"
    static let instaId = "insta_id"
    static let location = "location"
    static let Multiprofile = "profile[]"
    
    //verifyOTP
   
    static let otpCode = "otpcode"
  
    //Rank
    
    static let rank = "rank"
    
    //profile LikeDislike
  
    static let likeUserId = "like_user_id"
    static let likeType = "like_type"
    
    //Media
    
    static let media = "media"
    static let Multimedia = "media[]"
    
    //MARK:- ViewStory
    static let viewUserId = "view_user_id"
    
    //MARK:- Private Score
    static let isPrivate = "is_private"
    
    //MARK:- ContactUs
    
    static let email = "email"
    static let subject = "subject"
    static let message = "message"
    
    //MARK:- Update Profile
    
    static let removeMediaId = "remove_media_id"
    static let type = "type"
    static let feedId = "feed_id"
    static let Updateprfile = "prfile"
    
    //MARK:- friendScore
    static let friendUserId = "friend_user_id"
    static let friendId = "friend_id"
    
    //MARK:- CreateFeed
    static let description = "description"
    static let feedImage = "feed_image"
        
    //MARK:- Comment
    
    static let comment = "comment"
    
    //MARK:- Search user
    static let searchText = "search_text"
    
    //MARK:- Story

    static let musicId = "music_id"
    static let musicType = "music_type"
    
    static let storyId = "story_id"
    static let storyMediaId = "story_media_id"
    
    //MARK:- Report

    static let extraId = "extra_id"
    
    //PushNoti
    static let kToken = "Token"

    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
    
}
