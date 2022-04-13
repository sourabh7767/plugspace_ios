//
//  MatchAndChatVIew.swift
//  PlugSpace
//
//  Created by MAC on 17/02/22.
//

import Foundation
import UIKit

class MatchAndChatView: UIView {
    
    //MARK:- Outlets
    
    @IBOutlet private weak var btnOk: UIButton!
    
    @IBOutlet private weak var mainView: UIView!
    
    @IBOutlet private weak var lblName: UILabel!
    
    //MARK:- Properties
        
    //MARK:-
    
    override func awakeFromNib() {
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnOk.cornerRadius = 10
        mainView.cornerRadius = 10
    }
    
    func setData(title:String) {
        let attributedWithTextColor: NSAttributedString = "You and \(title) have liked each other.".attributedStringWithColor([" and have liked each other."], color: AppColor.FontBlack, font: UIFont(name: AppFont.reguler, size: 16)!)
        lblName.attributedText = attributedWithTextColor
    }
    
    //MARK:- Method
    
    //MARK:- IBAction
    @IBAction private func onBtnOk(_ sender: UIButton) {
        
        closeXIB(XIB: self)
    }
}
