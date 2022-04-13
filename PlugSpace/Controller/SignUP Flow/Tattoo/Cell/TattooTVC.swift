//
//  TattooTVC.swift
//  PlugSpace
//
//  Created by MAC on 19/11/21.
//

import UIKit

class TattooTVC: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var lblChildrenNumber: UILabel!
    
    //MARK:- Properties
    
    
    // MARK: - SetupUI
  
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Method
    
    func SetData(text:String)  {
        lblChildrenNumber.text = text
    }
    
    func setBorder()  {
        lblChildrenNumber.textColor = AppColor.Orange
        lblChildrenNumber.font = UIFont(name: AppFont.bold, size: setCustomFont(18))
        shadowView.setBorder(0.2, AppColor.Orange)
    }
    
    func removeBorder()  {
        lblChildrenNumber.textColor = AppColor.FontBlack
        lblChildrenNumber.font = UIFont(name: AppFont.reguler, size: setCustomFont(18))
        shadowView.setBorder(0, AppColor.Orange)
    }
    
    private func setupUI() {
        
        
        setAfter { [self] in
            
            shadowView.cornerRadius = 10
            
            shadowView.layer.masksToBounds = false
            shadowView.layer.cornerRadius = 10
            shadowView.layer.shadowColor = AppColor.Orange.cgColor
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius:shadowView.layer.cornerRadius).cgPath
            shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowView.layer.shadowOpacity = 0.2
            shadowView.layer.shadowRadius = 3.0
            shadowView.backgroundColor = UIColor.white
            
        }
    }
    
}
