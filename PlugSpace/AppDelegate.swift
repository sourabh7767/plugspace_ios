//
//  AppDelegate.swift
//  PlugSpace
//
//  Created by MAC on 13/11/21.
//
//com.barine.plugspace
import UIKit
import IQKeyboardManagerSwift
import FirebaseMessaging
import Firebase
import SVProgressHUD
import WebKit
import DropDown
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var matchAndChatPopUP = UIView.getView(viewT: MatchAndChatView.self)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        registerForFirebaseNotification(application: application)
        
        setupApplicationUIAppearance()
        AppPrefsManager.shared.isUserLogin() ?  goToSplashVc() : goToWelcomeVc()
        
//   printFontFamilyNames()
        return true
    }
    
    // MARK: - Methods
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func clearCache() {
           HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
           WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
               records.forEach { record in
                   WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
               }
           }
       }
    
    func printFontFamilyNames() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitApp"), object: nil)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitApp"), object: nil)
    }
    
    private func setupApplicationUIAppearance() {
        DropDown.appearance().setupCornerRadius(10)
        DropDown.appearance().textFont = UIFont(name: AppFont.reguler, size: setCustomFont(16))!
        DropDown.appearance().textColor = AppColor.FontBlack
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarTintColor = AppColor.Orange
        SVProgressHUD.setFont(UIFont(name: AppFont.reguler, size: setCustomFont(16))!)
        UITextView.appearance().tintColor = AppColor.Orange
        UITextField.appearance().tintColor = AppColor.Orange
    }
    
    func goToLoginVc() {
        let homeVc = UIStoryboard.instantiateVC(LoginVC.self, .Main)
        let homeNav = UINavigationController(rootViewController: homeVc)
        homeNav.isNavigationBarHidden = true
        _ = window!.setRootVC(homeNav)
    }
    
    func goToWelcomeVc() {
        let homeVc = UIStoryboard.instantiateVC(WelcomeVC.self, .Main)
        let homeNav = UINavigationController(rootViewController: homeVc)
        homeNav.isNavigationBarHidden = true
        _ = window!.setRootVC(homeNav)
    }
    
    func goToSplashVc() {
        let homeVc = UIStoryboard.instantiateVC(SplashVC.self, .Main)
        let homeNav = UINavigationController(rootViewController: homeVc)
        homeNav.isNavigationBarHidden = true
        _ = window!.setRootVC(homeNav)
    }
    
    func goToHomeVc() {
        let homeVc = UIStoryboard.instantiateVC(TabBarVC.self, .Home)
        let homeNav = UINavigationController(rootViewController: homeVc)
        homeNav.isNavigationBarHidden = true
        _ = window!.setRootVC(homeNav)
    }
    
    func goToSignUPSplashVc() {
        let homeVc = UIStoryboard.instantiateVC(SplashScreen2VC.self, .Home)
        let homeNav = UINavigationController(rootViewController: homeVc)
        homeNav.isNavigationBarHidden = true
        
        _ = window!.setRootVC(homeNav)
    }
    
    func logoutFromApplication() {
        let homeVc = UIStoryboard.instantiateVC(LoginVC.self, .Main)
        let homeNav = UINavigationController(rootViewController: homeVc)
        homeNav.isNavigationBarHidden = true
        _ = window!.setRootVC(homeNav)
          AppPrefsManager.shared.setIsUserLogin(isUserLogin: false)
         AppPrefsManager.shared.removeUserData()
         AppPrefsManager.shared.removeAuthToken()
    }
    
    func registerForFirebaseNotification(application: UIApplication) {

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })

        application.registerForRemoteNotifications()
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate {
    
    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print(fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let data = notification.request.content.userInfo

        let isMatch = data[AnyHashable("is_match")] as? String ?? ""
        let title = data[AnyHashable("title")] as? String ?? ""
        
        isMatch == "1" ? openMatchPopUP(title: title) : nil
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        completionHandler()
    }
    
    func openMatchPopUP(title:String) {
        matchAndChatPopUP = UIView.getView(viewT: MatchAndChatView.self)
        matchAndChatPopUP.setData(title: title)
        openXIB(XIB: matchAndChatPopUP)
    }
    
    
}
