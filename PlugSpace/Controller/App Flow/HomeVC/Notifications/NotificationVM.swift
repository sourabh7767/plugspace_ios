//
//  NotificationVM.swift
//  PlugSpace
//
//  Created by MAC on 19/01/22.
//

import Foundation
import UIKit

class NotificationVM: BaseVM {
    
    //MARK:- Properties
    var date : UIDatePicker = UIDatePicker()
    let imgArr = ["img_nt_1", "img_nt_2", "img_nt_3", "img_nt_4", "img_nt_5", "img_nt_6"]
    let timeArr = ["5h ago", "6h ago", "7h ago", "7h ago", "8h ago", "8h ago"]
    var notificationData = [NotificationDetailsModel]()
    var notification = [NotificationDetailsModel]()
    var checkDf = DateFormatter()
    var dateFormatter = DateFormatter()
}
