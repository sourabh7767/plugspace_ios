//
//  TabbarVM.swift
//  PlugSpace
//
//  Created by MAC on 26/11/21.
//

import Foundation
import UIKit
import DKImagePickerController

class TabBarVM : BaseVM {
    
    //MARK:- Properties
    
    var selectedArr = ["ic_home_tab","ic_Score","ic_Chat","ic_Profile"]
    var normalArr = ["ic_Home_deseleted","ic_Score_deseleted","ic_Chat_Deseleted","ic_Profile_Deseleted"]
    let title = ["Capture photo","Phone Library","Capture Video","Video Phone Library"]
    
    var selectedVC : UIViewController? = nil
    var vcIds : [UIViewController.Type] = [HomeVC.self,MyScoreVC.self,ChatSegmentVC.self,EditProfileVC.self]
    var selectedIndex: Int = 0
    var imagePicker = UIImagePickerController()
    let imagePickerController = DKImagePickerController()
    var assets: [DKAsset]?
}
