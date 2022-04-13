//
//  UserBasicInfoCell.swift
//  PlugSpace
//
//  Created by MAC on 24/11/21.
//

import UIKit

class UserBasicInfoCell: UICollectionViewCell {

    //MARK:- Outlet
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialisation code
    }

    //MARK:- Method
    func setdata(img:String,title:String) {
        
        if title != "" {
            imgIcon.image = img != "" ? UIImage(named: img) : nil
            lblDetail.text = title != "" ? title : ""
        }
    }
}
