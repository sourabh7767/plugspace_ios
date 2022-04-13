//
//  NotificationTableCell.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var imgProfle: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Properties
    
    lazy private var df = DateFormatter()

    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpScreen()
    }
    
    
    //MARK:- Method
    func setUpScreen() {

        setAfter { [self] in
            imgProfle.setCornerRadius(imgProfle.frame.height / 2)
            
        }
    }
    private func dayDifference(from interval : TimeInterval) -> String {
        df.dateFormat = "hh:mm a"
        let msgTime = Date(timeIntervalSince1970: interval)
        return df.string(from: msgTime)
    }
    
    func setData(data:NotificationDetailsModel) {
        
        imgProfle.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        lblTime.text = dayDifference(from: TimeInterval(data.time/1000))
        let attributedWithTextColor: NSAttributedString = "@\(data.name) \(data.message)".attributedStringWithColor(["\(data.message)"], color: AppColor.FontBlack, font: UIFont(name: AppFont.reguler, size: 16)!)
        lblTitle.attributedText = attributedWithTextColor
    }
}
