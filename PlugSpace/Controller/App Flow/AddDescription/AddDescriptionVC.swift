//
//  AddDescriptionVC.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit

class AddDescriptionVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK:- Properties
    
    let viewModel = SelectedImageVM()
    var feedImage = Data()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
    }
    
    //MARK:- Method
    
    func setUpScreen() {
        
        setAfter { [self] in
            txtViewDescription.setCornerRadius(10)
            btnDone.setCornerRadius(10)
            let shadowPath2 = UIBezierPath(rect: CGRect(x: -2 ,
                                                        y: -6 + 4 ,
                                                        width: self.txtViewDescription.frame.size.width,
                                                        height: self.txtViewDescription.frame.size.height + 6))
            txtViewDescription.layer.shadowPath = shadowPath2.cgPath
            txtViewDescription.layer.masksToBounds = false
            txtViewDescription.layer.shadowRadius = 6
            txtViewDescription.layer.shadowOpacity = 0.2
            txtViewDescription.layer.shadowColor = AppColor.Orange.cgColor
            txtViewDescription.layer.shadowOffset = CGSize(width: 2 , height:2)
        }
    }
    
    func callApiCreateFeed() {
        
        viewModel.description = txtViewDescription.text
        viewModel.storyImage = feedImage
        
        viewModel.createFeed { (isSuccess) in
            
            if isSuccess {
                appdelegate.goToHomeVc()
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.first?.showToast(message: StringConstant.uploadImageFeed, y: self.view.center.y, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
            } else {
                self.alertWith(message: self.viewModel.errorMessage)
            }
        }
    }
    
    //MARK:- Action
    
    @IBAction func clickOnBtnDone(_ sender: Any) {
        self.view.endEditing(true)
        callApiCreateFeed()
    }
    
    @IBAction func clickOnBtnBack(_ sender: Any) {
        self.view.endEditing(true)
        backVC()
    }
}
