//
//  API Client.swift
//  TopSecurityGuard
//
//  Created by iMac on 24/06/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation


class APIClient {
    
    //MARK:- Properties
    
    static let shared = APIClient()
    
    // MARK: - Login Flow
    
    //MARK:- Not Use
//    func login(parameter: [String:Any] ,completion: @escaping APICallback)  {
//        return APIManager.postRequest(url: APIS.LogInFlow.login, parameters: parameter, completion: completion)
//    }
    
    func isRegister(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.LogInFlow.isRegister, parameters: parameter, completion: completion)
    }
    
    func SignUp(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.LogInFlow.SignUP, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys,isShowHud: false, completion: completion)
    }
    
    func sendOTP(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.LogInFlow.sendOTP, parameters: parameter, completion: completion)
    }
    
    func verifyOTP(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.LogInFlow.verifyOTP, parameters: parameter, completion: completion)
    }
    
    func getRankPerson(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.LogInFlow.getRankPerson, parameters: parameter,isShowHud: false, completion: completion)
    }
    
    func ageCalculator(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.LogInFlow.ageCalculator, parameters: parameter, completion: completion)
    }
    
    func logOut(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.LogInFlow.logOut, parameters: parameter, completion: completion)
    }

    // MARK: - App Flow

    func profileLikeDislike(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.AppFlow.profileLikeDislike, parameters: parameter,isShowHud: true, completion: completion)
    }
    
    func getHomeDetails(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.AppFlow.getHomeDetails, parameters: parameter, completion: completion)
    }
    
    func createStory(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.createStory, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
    }
    
    func getNotificationList(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.AppFlow.getNotificationList, parameters: parameter, completion: completion)
    }
    
    func getChatList(parameter: [String:Any] ,completion: @escaping APICallback)  {
        return APIManager.postRequest(url: APIS.AppFlow.getChatList, parameters: parameter, completion: completion)
    }
    
    func createViewStory(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.createViewStory, parameters: parameter, completion: completion)
    }
    
    func updateProfile(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.updateProfile, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
    }
    
    func updateData(parameters: [String: Any], completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.updateProfile, parameters: parameters, completion: completion)
    }
    
    func contactUs(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.contactUs, parameters: parameter, completion: completion)
    }
    
    func createFeed(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.createFeed, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
    }
    
    // MARK: - My Score
    
    func isPrivateScore(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.isPrivateScore, parameters: parameter, completion: completion)
    }
    
    func getMyScore(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.getMyScore, parameters: parameter, completion: completion)
    }
    
    func getFriendsScore(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.getFriendsScore, parameters: parameter, completion: completion)
    }
    
    func previewUpdatePro(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.previewUpdatePro, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
    }
    
    //MARK:- Story
    
    func storyComment(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.storyComment, parameters: parameter,isShowHud: false, completion: completion)
    }
    
    func getStoryDetails(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.getStoryDetails, parameters: parameter, completion: completion)
    }
    
    func getMyViewStory(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.getMyViewStory,parameters: parameter, isShowHud: false, completion: completion)
    }
    
    func deleteStory(parameter: [String:Any] , completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.deleteStory, parameters: parameter, completion: completion)
    }
    
    func report(parameter: [String:Any] , completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.profileReportByUser, parameters: parameter, completion: completion)
    }
    //MARK:- Save Profile
    func SaveProfile(parameter: [String:Any] , completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.saveProfile, parameters: parameter, completion: completion)
    }
    
    //MARK:- Save Profile
    func blockProfile(parameter: [String:Any] , completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.blockUser, parameters: parameter, completion: completion)
    }
    
    
    func GetSavedOtherProfile(parameter: [String:Any] , completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.getSavedProfile, parameters: parameter, completion: completion)
    }
    
    
    //MARK:- Music
    func getMusicList(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.getMusicList,parameters: parameter, completion: completion)
    }
    
    func musicLikeDislike(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.musicLikeDislike,parameters: parameter, completion: completion)
    }
    
    func getFavoriteMusic(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.getFavoriteMusic,parameters: parameter, completion: completion)
    }
    
    //MARK:- Push Noti
    
    func sendNotification(parameter: [String:Any] ,completion: @escaping APICallback) {
        return APIManager.postRequest(url: APIS.AppFlow.sendNotification,parameters: parameter, completion: completion)
    }
    
    func getDefaultMessages(completion: @escaping APICallback) {
        return APIManager.getRequest(url: "https://www.plugspace.io/api/getMessages", completion: completion)
    }
    
//    func checkMail(parameter: [String:Any] ,completion: @escaping APICallback)  {
//        return APIManager.postRequest(url: APIS.Common.CHECKEMAIL, parameters: parameter, completion: completion)
//    }

//    func SignUp(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.SIGNUP, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
//    }

//    func UpdateSelfiePhoto(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.UPDATESELFIEPHOTO, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
//    }

//    func login(parameter: [String:Any] ,completion: @escaping APICallback)  {
//        return APIManager.postRequest(url: APIS.Common.LOGIN, parameters: parameter, completion: completion)
//    }

//    func ForgotPassword(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.FORGOTPASSWORD, parameters: parameters, completion: completion)
//    }
    
//    func resendConfirm(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.RESENDCONFIRM, parameters: parameters, completion: completion)
//    }

//    func updateEmail(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.UPDATEEMAIL, parameters: parameters, completion: completion)
//    }

//    func updateMobileNo(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.UPDATEMOBILE, parameters: parameters, completion: completion)
//    }
//
//    func changePassword(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.CHANGEPAASWORD, parameters: parameters, completion: completion)
//    }

//    func addUpdateAddress(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.ADDUPDATEADDRESS, parameters: parameters, completion: completion)
//    }

//    func logOut(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.LOGOUT, parameters: parameters, completion: completion)
//    }
//
//    func contactUs(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.CONTACTUS, parameters: parameters, completion: completion)
//    }

//    func deactiveAccount(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.DEACTIVATEACCOUNT, parameters: parameters, completion: completion)
//    }

//    func deleteAccount(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Common.DELETEACCOUNT, parameters: parameters, completion: completion)
//    }
//
//    // MARK: - Partner
//    func getPartnersList(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Partners.GETPARTNERLIST, parameters: parameters, completion: completion)
//    }
//
//    func updatePermission(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Partners.UPDATEPERMISSION, parameters: parameters,isShowHud: false, completion: completion)
//    }
//
//    func updatePermissionDocWise(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Partners.UPDATEPERMISSIONDOCWISE, parameters: parameters,isShowHud: true, completion: completion)
//    }
//
//    func getPermissionHistoryLog(parameters: [String: Any],isShowHud: Bool, completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Partners.GETPERMISSIONHISTORYLOG, parameters: parameters,isShowHud: isShowHud, completion: completion)
//    }
//
//    func removePermission(parameters: [String: Any], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Partners.REMOVEPERMISSION, parameters: parameters, completion: completion)
//    }
//
//    // MARK: - Document
//    func addupdateDocument(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Document.ADDUPDATEDOCUMENT, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
//    }
//
//    func addDrivingLicenseImage(parameters: [String: Any] ,files: [[Data]] ,fileNames: [[String]],fileKeys : [String], completion: @escaping APICallback) {
//        return APIManager.postRequest(url: APIS.Document.ADDDRIVINGIMAGE, parameters: parameters, files: files, fileNames: fileNames, fileKeys: fileKeys, completion: completion)
//    }
    
}
