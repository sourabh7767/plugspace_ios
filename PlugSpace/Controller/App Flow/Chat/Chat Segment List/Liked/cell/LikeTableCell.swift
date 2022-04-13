//
//  LikeTableCell.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class LikeTableCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setAfter { [self] in
            imgProfile.setCornerRadius(imgProfile.frame.height / 2)
        }
    }

    //MARK:- Method
    
    func setData(data:likeDetailsModel)  {
        imgProfile.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "img_nt_1"), options: .retryFailed)
        lblName.text = data.name + ", \(data.age)"
        lblProfession.text = data.jobTitle
        lblTime.text = data.dateTime
    }
    
}
