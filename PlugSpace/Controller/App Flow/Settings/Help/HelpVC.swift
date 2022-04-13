//
//  HelpVC.swift
//  PlugSpace
//
//  Created by MAC on 16/11/21.
//

import UIKit

class HelpVC: BaseVC {

    //MARK:- Outlet

    @IBOutlet weak var txtView: UITextView!
    
    //MARK:- Propties
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK:- Method
    
    //MARK:- Action
    
    @IBAction func clickOnBtnBack(_ sender: Any) {
        backVC()
    }
    
}
