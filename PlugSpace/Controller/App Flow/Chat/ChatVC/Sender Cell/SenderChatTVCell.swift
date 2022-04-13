//
//  SenderChatTVCell.swift
//  PlugSpace
//
//  Created by MAC on 23/11/21.
//

import UIKit

class SenderChatTVCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var lblSenderMsg: UILabel!
    @IBOutlet private weak var senderView: UIView!
    @IBOutlet private weak var lblTime: UILabel!
    @IBOutlet private weak var imgReadOrNot: UIImageView!
    
    //MARK:- Properties
    
    lazy private var df = DateFormatter()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        df.dateFormat = "dd MMM yyyy hh:mm a"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAfter {
            self.senderView.Set_Corner([.topLeft, .bottomLeft, .topRight], 12)
        }
    }
    
    private func dayDifference(from interval : TimeInterval) -> String {
//        let calendar = Calendar.current
//        let date = Date(timeIntervalSince1970: interval)
            df.dateFormat = "hh:mm a"
            let msgTime = Date(timeIntervalSince1970: interval)
            return df.string(from: msgTime)
        
    }
    
    // MARK: - SetupUI
    
 
    func setData(msg:String,readOrNot:String,time:Int64)  {
        
        lblSenderMsg.text = msg
        imgReadOrNot.image =  readOrNot == "1" ? #imageLiteral(resourceName: "ic_unseen_msg") : #imageLiteral(resourceName: "ic_SendTextImage")
        lblTime.isHidden =  time != 0 ? false : true
        lblTime.text = dayDifference(from: TimeInterval(time/1000))
    }
    
}
