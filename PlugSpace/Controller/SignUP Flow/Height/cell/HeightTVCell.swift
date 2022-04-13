//
//  HeightTVCell.swift
//  PlugSpace
//
//  Created by MAC on 02/12/21.
//

import UIKit

class HeightTVCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var lblHeight: UILabel!
    
    //MARK:- Properties
    
    // MARK: - SetupUI
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Method
    
    func SetData(text:String) {
        lblHeight.text = text + """
        " ft
        """
    }
    
    func setBorder() {
        lblHeight.textColor = AppColor.Orange
        lblHeight.font = UIFont(name: AppFont.bold, size: setCustomFont(18))
        shadowView.setBorder(0.2, AppColor.Orange)
    }
    
    func removeBorder() {
        lblHeight.textColor = AppColor.FontBlack
        lblHeight.font = UIFont(name: AppFont.reguler, size: setCustomFont(18))
        shadowView.setBorder(0, AppColor.Orange)
    }
    
    private func setupUI() {
        setAfter { [self] in
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
