//
//  MyScoreTVCell.swift
//  PlugSpace
//
//  Created by MAC on 08/02/22.
//

import UIKit

class MyScoreTVCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var lblDescription:UILabel!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Method
    
    func setData(data:MyCharacteristicsModel) {
        lblTitle.text = data.name
        lblDescription.text = data.text
    }
}
