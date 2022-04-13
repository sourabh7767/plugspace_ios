//
//  NotificationModel.swift
//  PlugSpace
//
//  Created by MAC on 18/02/22.
//

import Foundation

class NotificationModel {
    
    var date = ""
    var name = ""
    var text = ""
    var type = ""
    var timestamp = ""
    var badge = ""
    var email = ""
    var sound = ""
    var title = ""
    var isMatch = ""
    var message = ""
    var isBackground = ""
    
    init(dict:[String:Any]) {
        date = dict["date"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        text = dict["text"] as? String ?? ""
        type = dict["type"] as? String ?? ""
        timestamp = dict["timestamp"] as? String ?? ""
        badge = dict["badge"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        sound = dict["sound"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        isMatch = dict["is_match"] as? String ?? ""
        message = dict["message"] as? String ?? ""
        isBackground = dict["is_background"] as? String ?? ""
    }
}
