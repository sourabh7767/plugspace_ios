//
//  API.swift
//  TopSecurityGuard
//
//  Created by iMac on 24/06/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation

struct APIS {

 // old URL//  private static var BASE_URL              =  "https://appkiduniya.in/Plugspace/api/"
// New URL//  private static var BASE_URL               =  "https://www.plugspace.io/api/"
    
    private static var BASE_URL                   =  "https://www.plugspace.io/api/"
    
    struct LogInFlow {
        
        static let SignUP                         =  BASE_URL + "signUp"
        static let sendOTP                        =  BASE_URL + "sendOTP"
        static let verifyOTP                      =  BASE_URL + "verifyOTP"
        static let getRankPerson                  =  BASE_URL + "getRankPerson"
        //MARK:- Not Use //        static let login                          =  BASE_URL + "login"
        static let logOut                         =  BASE_URL + "logOut"
        static let getUserProfile                 =  BASE_URL + "getUserProfile"
        static let profileLikeDislike             =  BASE_URL + "profileLikeDislike"
        static let getHomeDetails                 =  BASE_URL + "getHomeDetails"
        static let createStory                    =  BASE_URL + "createStory"
        static let getNotificationList            =  BASE_URL + "getNotificationList"
        static let getChatList                    =  BASE_URL + "getChatList"
        static let createViewStory                =  BASE_URL + "createViewStory"
        static let ageCalculator                  =  BASE_URL + "ageCalculator"
        static let isRegister                     =  BASE_URL + "isRegister"
        
    }
    
    struct AppFlow {
        
        static let getUserProfile                 =  BASE_URL + "getUserProfile"
        static let profileLikeDislike             =  BASE_URL + "profileLikeDislike"
        static let getHomeDetails                 =  BASE_URL + "getHomeDetails"
        static let createStory                    =  BASE_URL + "createStory"
        static let getNotificationList            =  BASE_URL + "getNotificationList"
        static let getChatList                    =  BASE_URL + "getChatList"
        static let createViewStory                =  BASE_URL + "createViewStory"
        static let contactUs                      =  BASE_URL + "contactUs"
        static let updateProfile                  =  BASE_URL + "updateProfile"
        static let previewUpdatePro               =  BASE_URL + "previewUpdatePro"
        static let createFeed                     =  BASE_URL + "createFeed"
        
        //MARK:- MyScore
        
        static let isPrivateScore                 =  BASE_URL + "isPrivateScore"
        static let getMyScore                     =  BASE_URL + "getMyScore"
        static let getFriendsScore                =  BASE_URL + "getFriendsScore"
        
        //MARK:- Story
        
        static let getStoryDetails                =  BASE_URL + "getStoryDetails"
        static let getMyViewStory                 =  BASE_URL + "getMyViewStory"
        static let deleteStory                    =  BASE_URL + "deleteStory"
        static let profileReportByUser            =  BASE_URL + "profileReportByUser"
        
        //MARK:- Comment Api
        
        static let storyComment                   =  BASE_URL + "storyComment"
        
        
        //MARK:- Music Api
        
        static let getMusicList                   =  BASE_URL + "getMusicList"
        static let musicLikeDislike               =  BASE_URL + "musicLikeDislike"
        static let getFavoriteMusic               =  BASE_URL + "getFavoriteMusic"
        
        static let sendNotification               =  BASE_URL + "testPush"
        
        //MARK:-
    }
}
