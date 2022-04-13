//
//  FavouriteCVCell.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import UIKit

class FavouriteCVCell: UICollectionViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var imgMusic:UIImageView!
    @IBOutlet weak var lblMusic:UILabel!
    @IBOutlet weak var musicView:UIView!
    
    //MARK:-

    override func awakeFromNib() {
        super.awakeFromNib()
        musicView.cornerRadius = 10
        // Initialization code
    }

    func setData(musicName:String) {
        
        lblMusic.text = musicName
        
    }
    
    func setOrangeShadow(image:String) {
        
        imgMusic.image = UIImage(named: image)
//        imgMusic.tintColor = AppColor.Orange
        lblMusic.textColor = AppColor.Orange
        musicView.setShadow(4.0, 1.0, 2.0, AppColor.Orange, 0.2)
        musicView.setBorder(0.1, AppColor.Orange)
    }
    
    func setBlackShadow(image:String) {
        imgMusic.image = UIImage(named: image)
//        imgMusic.tintColor = AppColor.black
        lblMusic.textColor = AppColor.black
        musicView.setShadow(4.0, 1.0, 2.0, AppColor.black, 0.2)
        musicView.setBorder(0.1, AppColor.FontBlack)
    }
    
}
