//
//  MusicTVCell.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import UIKit

class MusicTVCell:UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var imgMusicLogo:UIImageView!
    @IBOutlet weak var roundView:UIView!
    @IBOutlet weak var heartView:UIView!
    @IBOutlet weak var btnHeart:UIButton!
    @IBOutlet weak var lblMusicTitle:UILabel!
    @IBOutlet weak var lblArtistsName:UILabel!
    @IBOutlet weak var imgHeart:UIImageView!
    @IBOutlet weak var imgPlayOrPause:UIImageView!
    
    //MARK:- Properties
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialisation code
    }

    //MARK:- setUpUI
    
    func setupUI()  {
        
        imgMusicLogo.setRound()
        roundView.setRound()
        heartView.setRound()
        heartView.setBorder(0.2, AppColor.Orange)
        heartView.setShadow(0.4, 0.0, 2.0, AppColor.Orange, 0.3)
    }
    
    func setData(data:MusicModel) {
        lblMusicTitle.text = data.subtitle
        lblArtistsName.text = data.headerDesc
        imgMusicLogo.sd_setImage(with: URL(string: data.imageUrl), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        imgHeart.image = data.isFavorite == "0" ? UIImage(named: "ic_Heart") : UIImage(named: "ic_like_filed")
    }
    
    func setPlayOrPuase(isPlay:Bool) {
        imgPlayOrPause.image = isPlay ? UIImage(named: "ic_pause") : UIImage(named: "ic_play")
    }
    
    //MARK:- IBAction
    
    @IBAction func btnHeartAction(_ sender:UIButton) {
    }
}

