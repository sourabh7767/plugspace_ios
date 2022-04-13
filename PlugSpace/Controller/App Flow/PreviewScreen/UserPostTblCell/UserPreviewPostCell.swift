//
//  UserPostCell.swift
//  PlugSpace
//
//  Created by MAC on 24/11/21.
//

import UIKit
import DropDown

protocol updateProfileDelegate {
    func btnEditOrDelete(action:String,image:UIImage,cell:UserPreviewPostCell)
}

class UserPreviewPostCell: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bgBtnView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    //MARK:- Properties
    
    private var dropDown = DropDown()
    var delegate:updateProfileDelegate!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        setAfter { [self] in
            mainView.setCornerRadius(20)
            imgProfile.setCornerRadius(20)
            bgBtnView.setShadowView(color: AppColor.black, opacity: 1, offset: CGSize(width: 1.0, height: 1.0), radius: 10)
        }
    }

    //MARK:- Method

    func showDropdown(button: UIButton) {
      
        let arrDataSource = ["Edit", "Delete"]
        
        dropDown.dataSource = arrDataSource
        dropDown.width = btnMore.frame.width + 60
        dropDown.anchorView = btnMore
        dropDown.separatorColor = .clear
        dropDown.bottomOffset = CGPoint(x: -60, y: ((dropDown.anchorView?.plainView.bounds.height)!+10))
        
        dropDown.selectionAction = { [self] (index, item) in
            delegate.btnEditOrDelete(action: item, image: imgProfile.image!, cell: self)
//            self!.btnMore.setTitle(item, for: .normal)
        }
    }
    
    func setData(data:MediaDetails) {
        
        if data.media_type == "image" || data.type == "feed" {
                imgProfile.sd_setImage(with: URL(string: data.feedImage), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
                lblCaption.text = data.description
        } else {
                imgProfile.image = getThumnailImage(videoURL: data.feedImage)
                lblCaption.text = data.description
                btnPlay.isHidden = false
            }
    }
    
    //MARK:- IBAction
    
    @IBAction func clickBtnMore(_ sender: UIButton) {
        showDropdown(button: btnMore)
        dropDown.clearSelection()
        dropDown.show()
    }
}
