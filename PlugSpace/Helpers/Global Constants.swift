//
//  Global Constants.swift
//  Black Box
//
//  Created by MAC on 17/03/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

// Home business

let googleMapKey = ""

// MARK: -

var isDevelopmentMode = false
var isPurchaseMode = false

let appdelegate = UIApplication.shared.delegate as! AppDelegate

let firebaseServerKey = "AAAArDxg7Us:APA91bEFmeeluGnV9GceOaTFJvOMUoiGEtlIUILLnc7FMeqYttobpRc6N375mvDbO83E2zuHkyAY3CrIGC1d3LlHL0GPFJx1S41i-4Zoh0O0pTg8rbnaKcfwUB00MAcgGOJEBDzlDqvA"

//MARK:- Instagram Login

var INSTA_APP_ID = "344083504028250"
var INSTA_REDIRECT_URL = "https://www.digigreets.com/Login/instaLogin"
var INSTA_APP_CLIENT_SECRET = "e88eaaa0d0774e134f6ed5549d79a6ad"

//static let INSTA_APP_ID = "344083504028250" //"577558343378042" //"344083504028250"
//  static let INSTA_APP_CLIENT_SECRET = "e88eaaa0d0774e134f6ed5549d79a6ad" //"6378b8528210513721e303bb75184827" //"e88eaaa0d0774e134f6ed5549d79a6ad"
//  static let INSTA_REDIRECT_URL = "https://www.digigreets.com/Login/instaLogin"
// MARK: -
let AppName = "Plugspace"
var keyToken = "2b223e5cee713615ha54ac203b24e9a123703011VT"

var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    return false
}


// MARK: -
enum Storyboard : String {
    case Main = "Main"
    case Home = "Home"
}

// MARK: -
struct AppFont {

    static let reguler      = "TimesNewRomanPSMT"
    static let bold         = "TimesNewRomanPS-BoldMT"
    static let boldItalic   = "TimesNewRomanPS-BoldItalicMT"
}

// MARK: -
struct AppColor {
    static let FontBlack    = UIColor(named: "Font_Black")!
    static let FontPink     = UIColor(named: "Font_Pink")!
    static let Orange       = UIColor(named: "Orange")!
    static let Green        = UIColor(named: "Green")!
    static let gray         = UIColor(named: "Gray")!
    static let yellow       = UIColor(named: "Gray")!
    static let black        = UIColor(named: "Black")!
    static let darkGray     = UIColor(named: "Dark_Gray")!
}

// MARK: -
struct ResponseStatus {
    static let fail = 0
    static let success = 1
    static let NotConfirmAccount = 2
    static let tokenExpire = 9
}
