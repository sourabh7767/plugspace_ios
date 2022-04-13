//
//  StoryCollectionCell.swift
//  PlugSpace
//
//  Created by MAC on 19/11/21.
//

import UIKit

class StoryCollectionCell: UICollectionViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    //MARk:- Properties
    
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        setAfter { [self] in
            imgProfile.setCornerRadius(imgProfile.frame.height / 2)
            viewBorder.setCornerRadius(viewBorder.frame.height / 2)
//            viewBorder.borderColor = AppColor.Orange
            viewBorder.borderWidth = 1
        }
    }

    //MARK:- Method
    
    func setData(data:StoryDetailsModel) {

        lblName.text = data.userId == userId.userId ? "Your Story" :  data.name
        viewBorder.borderColor = data.isShowStory == "0" ?  AppColor.Orange :  AppColor.darkGray
        imgProfile.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
    }
}
