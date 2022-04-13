//
//  ContactUsVC.swift
//  PlugSpace
//
//  Created by MAC on 16/11/21.
//

import UIKit

class ContactUsVC: BaseVC {
    
    //MARK:- Outlet

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK:- Properties
    
    var viewModel = ContactUsVM()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
    }
    
    //MARK:- Method
    
    func setUpScreen() {
        
        setAfter { [self] in
            btnSubmit.setCornerRadius(10)
            
            [txtName, txtEmail, txtSubject].setBlankView(20, .Left)
            [txtName, txtEmail, txtSubject].setBlankView(20, .Right)
            txtViewMessage.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
            txtName.setCornerRadius(10)
            txtName.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
            
            txtEmail.setCornerRadius(10)
            txtEmail.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
           
            txtSubject.setCornerRadius(10)
            txtSubject.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
            
            txtViewMessage.setCornerRadius(10)
            let shadowPath2 = UIBezierPath(rect: CGRect(x: -20 ,
                                                           y: -6 + 4 ,
                                                           width: self.txtViewMessage.frame.size.width,
                                                           height: self.txtViewMessage.frame.size.height + 6))
            txtViewMessage.layer.shadowPath = shadowPath2.cgPath
            txtViewMessage.layer.masksToBounds = false
            txtViewMessage.layer.shadowRadius = 4.0
            txtViewMessage.layer.shadowOpacity = 0.2
            txtViewMessage.layer.shadowColor = AppColor.Orange.cgColor
            txtViewMessage.layer.shadowOffset = CGSize(width: 2 , height:2)
        }
    }

    func callContactUsApi() {
        
        viewModel.email = txtEmail.text!
        viewModel.name = txtName.text!
        viewModel.subject = txtSubject.text!
        viewModel.message = txtViewMessage.text!
        
        guard viewModel.validation() else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        
        viewModel.contactUs { [self] (isSuccess) in
            
            if isSuccess {
                
                successAlert(AppName, message: viewModel.errorMessage, button: "Ok") {
                    self.backVC()
                }
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    //********************************************
    //MARK:- Action
    //********************************************
    
    @IBAction func clickOnBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOnBtnSubmit(_ sender: Any) {
        callContactUsApi()
    }
}
