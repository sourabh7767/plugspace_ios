//
//  MatchAndChatTableCell.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class MatchAndChatTableCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var viewNotificationRound: UIView!
    @IBOutlet weak var lblNotification: UILabel!
    
    //MARK:- Properties
    
    let gradientLayer = CAGradientLayer()
    let colorTop =  UIColor.init("F5AF19")
    let colorBottom = UIColor.init("FA5A20")
    lazy private var df = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        df.dateFormat = "dd MMM yyyy hh:mm a"
        setAfter { [self] in
            
//            viewNotificationRound.applyGradient(colours: [colorTop, colorBottom])
            viewNotificationRound.setCornerRadius(viewNotificationRound.frame.height / 2)
            viewNotificationRound.clipsToBounds = true
            viewNotificationRound.applyGradient1(colours: [colorTop, colorBottom])
            imgProfile.setCornerRadius(imgProfile.frame.height / 2) 
        }
    }

    //MARK:- Method
    
    private func dayDifference(from interval : TimeInterval) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDateInToday(date) {
            df.dateFormat = "hh:mm a"
            let msgTime = Date(timeIntervalSince1970: interval)
            return df.string(from: msgTime)
        } else {
            df.dateFormat = "MMM dd, yyyy"
            let msgTime = Date(timeIntervalSince1970: interval)
            return df.string(from: msgTime)
        }
    }
    
    func setData(data:ChatListModel)  {
        
        imgProfile.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "img_nt_1"), options: .retryFailed)
        lblName.text = data.name
        lblMessage.text = data.message
        viewNotificationRound.isHidden = data.read_count == "" || data.read_count == "0" ? true : false
        lblNotification.text = data.read_count
        lblTime.isHidden =  data.time != 0 ? false : true
        lblTime.text = dayDifference(from: TimeInterval(data.time/1000))
    }
}
