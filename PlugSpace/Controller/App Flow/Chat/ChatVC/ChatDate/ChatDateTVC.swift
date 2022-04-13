//
//  ChatDateTVC.swift
//  PlugSpace
//
//  Created by MAC on 25/11/21.
//

import UIKit

class ChatDateTVC: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblTime: UILabel!
    
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
