//
//  DropDown.swift
//  PlugSpace
//
//  Created by MAC on 08/01/22.
//

import Foundation
import DropDown
import UIKit

extension Sequence where Iterator.Element == DropDown {
    
    func setDropdown(dropDown:DropDown ,dataArr: [String], anchorView:AnchorView) {
    
        self.forEach { (v) in
        
            v.setData(dropDown: dropDown, dataArr: dataArr, anchorView: anchorView)
        }
    }
}

extension DropDown {
    
    func setData(dropDown:DropDown, dataArr: [String], anchorView: AnchorView) {
                dropDown.dataSource = dataArr
                dropDown.anchorView = anchorView
                dropDown.separatorColor = .clear
                dropDown.selectionAction = { (index, item) in
        }
    }
    
    func showDropDown(dropDown:DropDown) {
        UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first?.endEditing(true)
        dropDown.show()
    }
}

