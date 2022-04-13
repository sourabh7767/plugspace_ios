//
//  SubscriptionVC.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit

class SubscriptionVC: BaseVC {
   
    //MARK:- Outlet
    
    @IBOutlet  private var viewPlan : [UIView]!
    @IBOutlet private  var lblPlanTitle: [UILabel]!
    @IBOutlet private  var lblPlanPrice: [UILabel]!
    @IBOutlet private  var lblPlanMonths: [UILabel]!
    @IBOutlet private weak var btnContinue: UIButton!
    
    @IBOutlet private var btnPlan: [UIButton]!
    
    
    //MARK:- Propties
 

    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
    }
    
    //MARK:- Function
    
    func setUpScreen() {
        setAfter { [self] in
            
            viewPlan.setCornerRadius(10)
            btnContinue.setCornerRadius(10)
            setShadowPlanView(indexView:0)
        }
    }
    
    //MARK:- Action
    
    @IBAction func clickOnBtnBack(_ sender: Any) {
        backVC()
    }
    
    @IBAction func clickOnBtnContinue(_ sender: Any) {
        alertWith(message: StringConstant.developmentTime)
    }
    
    @IBAction func clickOnPlanBtn(_ sender: UIButton) {
        setShadowPlanView(indexView:sender.tag)
    }
    
    //MARK:- Method
    
    func setShadowPlanView(indexView:Int) {
        btnPlan.enumerated().forEach { (index, img) in
            if indexView == index {
                viewPlan[index].setShadow(3.0, 0.0, 1.0, AppColor.Orange, 0.2)
                viewPlan[index].setBorder(0.2, AppColor.Orange)
                lblPlanTitle[index].textColor = AppColor.Orange
                lblPlanPrice[index].textColor = AppColor.Orange
                lblPlanMonths[index].alpha = 1
                
            } else {
                viewPlan[index].setShadow(3.0, 0.0, 1.0, AppColor.FontBlack, 0.2)
                lblPlanTitle[index].textColor = AppColor.FontBlack
                lblPlanPrice[index].textColor = AppColor.FontBlack
                lblPlanMonths[index].alpha = 0.5
                viewPlan[index].setBorder(0.2, AppColor.black)

            }
        }
    }
}

//MARK:- extension
