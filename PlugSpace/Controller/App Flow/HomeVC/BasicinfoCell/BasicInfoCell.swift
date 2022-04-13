//
//  BasicInfoCell.swift
//  PlugSpace
//
//  Created by MAC on 23/11/21.
//

import UIKit

class BasicInfoCell: UICollectionViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var imgInfo: UIImageView!
    @IBOutlet weak var lblInfoDetail: UILabel!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- Method
    
    func setData(img:String,details:String) {
        
        if details != "" {
            imgInfo.image = UIImage(named: img)
            lblInfoDetail.text = details
        }
    }
}
