//
//  IndicatorManager.swift
//  Receipt Manager
//
//  Created by MAC on 08/04/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

class IndicatorManager: NSObject {
    
    private static var loadingCount = 0
    private static var isLoaderShow = true
    private static let refreshControl = UIActivityIndicatorView()
    
    class func setUpUI() {
        refreshControl.color = AppColor.Orange
        refreshControl.transform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        refreshControl.center = ((appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.view.center)!
        refreshControl.startAnimating()
        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.view.addSubview(refreshControl)
    }
    
    class func showLoader() {
        guard isLoaderShow else {
            return
        }
    
        if loadingCount == 0 {
            // Show loader
            DispatchQueue.main.async {

                //MARK:- Not Show Loader As per client said
                
//                setUpUI()

                //MARK:- Not Use
//                SVProgressHUD.setDefaultMaskType(.clear)
//                SVProgressHUD.show(withStatus: "Loading...")
//                SVProgressHUD.show()
            }
        }
        loadingCount += 1
    }
    
    class func hideLoader() {
        guard isLoaderShow else {
            return
        }
        
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            // Hide loader
            DispatchQueue.main.async {
                
                //MARK:- Not Use
//                refreshControl.stopAnimating()
//                SVProgressHUD.dismiss()
            }
        }
    }
}
