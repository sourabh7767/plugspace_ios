//
//  NotificationDateTVC.swift
//  PlugSpace
//
//  Created by MAC on 29/11/21.
//

import UIKit

class NotificationDateTVC: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var lblTime: UILabel!
    
    var dateFormatter = DateFormatter()
    //MARK:-
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
    
    // MARK: - SetupUI
   
    
    func setData(time:String)  {
        
        lblTime.text = time
    }
}

