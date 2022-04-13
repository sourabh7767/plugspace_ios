//
//  FaqTableCell.swift
//  PlugSpace
//
//  Created by MAC on 16/11/21.
//

import UIKit

class FaqTableCell: UITableViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var viewDiscription: UIView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var viewDivider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpScreen()
    }
    

    func setUpScreen() {
        setAfter { [self] in
            mainView.setCornerRadius(10)
            viewTitle.setCornerRadius(10)
            viewDiscription.setCornerRadius(10)
            mainView.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
        }
    }
    
    @IBAction func clickBtnPlus(_ sender: UIButton) {

    }
    
}
