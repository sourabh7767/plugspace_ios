//
//  SuccessPopUpVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class SuccessPopUpVC: BaseVC {
    
    //********************************************
    //MARK:- Outlet
    //********************************************
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnOk: UIButton!
    
    //********************************************
    //MARK:- Propties
    //********************************************

    //********************************************
    //MARK:- Life Cycle
    //********************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAfter { [self] in
            viewMain.setCornerRadius(10)
            btnOk.setCornerRadius(10)
        }
    }

    //********************************************
    //MARK:- Function
    //********************************************

    //********************************************
    //MARK:- Action
    //********************************************

    @IBAction func clickBtnOk(_ sender: Any) {
        dismiss(animated: true)
        appdelegate.goToHomeVc()
    }
    

}
