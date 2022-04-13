//
//  UserPostCell.swift
//  PlugSpace
//
//  Created by MAC on 24/11/21.
//

import UIKit

class UserPostCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgProfle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        setAfter { [self] in
            imgProfle.setCornerRadius(20)
            mainView.setCornerRadius(20)
        }
    }
 
    //MARK:- Method
    
    func setdata(data:UserMediaDetail) {
        
        if data.media_type == "image" {
            imgProfle.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "ic_SplachLogo"), options: .retryFailed)
            lblTitle.text  = data.description
        } else {
            imgProfle.sd_setImage(with: URL(string: data.feedImage), placeholderImage: UIImage(named: "ic_SplachLogo"), options: .retryFailed)
            lblTitle.text  = data.description
        }
    }
}
