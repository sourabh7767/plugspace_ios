//
//  StoryViewTableCell.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit

class StoryViewTableCell: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    //MARK:-
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAfter { [self] in
            imgProfile.setCornerRadius(imgProfile.frame.height / 2)
        }
    }

    //MARK:- Method
    
    func setData(data:StoryViewModel) {
        
        imgProfile.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "ic_SelectImage"), options: .retryFailed)
        lblName.text = data.name
        lblProfession.text = data.jobTitle
        lblTime.text = data.dateTime
    }
}
