//
//  ReceiverTVC.swift
//  PlugSpace
//
//  Created by MAC on 23/11/21.
//

import UIKit

class ReceiverTVC: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var lblReceiverMsg: UILabel!
    @IBOutlet private weak var ReceiverView: UIView!
    @IBOutlet private weak var lblTime: UILabel!
    
    //MARK:- Properties
    
    lazy private var df = DateFormatter()

    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        df.dateFormat = "dd MMM yyyy hh:mm a"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setAfter {
            self.ReceiverView.Set_Corner([.topLeft, .bottomRight, .topRight], 12)
        }
    }
    
    private func dayDifference(from interval : TimeInterval) -> String {
            df.dateFormat = "hh:mm a"
            let msgTime = Date(timeIntervalSince1970: interval)
            return df.string(from: msgTime)
    }
    
    // MARK: - SetupUI
   
    
    func setData(msg:String,msgtime:Int64)  {
        
        lblReceiverMsg.text = msg
        lblTime.isHidden =  msgtime != 0 ? false : true
        lblTime.text = dayDifference(from: TimeInterval(msgtime/1000))
    }
}
