//
//  SettingsTableCell.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnarrawRight: UIButton!

    //MARK:- Properties
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpScreen()
        
    }
    
    //MARK:- Method
    
    func setUpScreen() {
        setAfter { [self] in
            mainView.setCornerRadius(10)
            mainView.setShadow(4, 2, 2, AppColor.Orange, 0.2)
        }
    }
    
    func hideImage()  {
        btnarrawRight.isHidden = true
    }
}
