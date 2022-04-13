//
//  FavouriteSong.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import Foundation
import UIKit

class FavouriteSongView: UIView {
    
    //MARK:- Outlete
    
    @IBOutlet  weak var mainView:UIView!
    @IBOutlet  private var lblFavouriteSong:[UILabel]!
    @IBOutlet  private var btnSelected:[UIButton]!
    @IBOutlet  var btnOk:UIButton!
    
    //MARK:- Properties

    typealias FavouriteSongs = (Int) -> Void
    var songsType : Int!
    
    //MARK:-
    
    override func awakeFromNib() {
        //setUpUI()
        btnSelected[0].isSelected = true
        songsType = 0
        setSelectedType(indexView:0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpUI()
    }
    
    //MARK:- Method
    
    func setUpUI() {
        
        mainView.cornerRadius = 10
        btnOk.cornerRadius = 10
    }
    
    func getSongsType(type:FavouriteSongs) {
        type(songsType)
    }
    
    func setSelectedType(indexView:Int) {
        btnSelected.enumerated().forEach { (index, img) in
            if indexView == index {
                btnSelected[index].isSelected = true
                lblFavouriteSong[index].textColor = AppColor.Orange
                songsType = index
            } else {
                btnSelected[index].isSelected = false
                lblFavouriteSong[index].textColor = AppColor.black
            }
        }
    }
    
    //MARK:- IBAction
    
    @IBAction func btnOk(_ sender:UIButton) {
        closeXIB(XIB: self)
    }
    
    @IBAction func btnActionSelected(_ sender:UIButton) {
        setSelectedType(indexView:sender.tag)
    }
}
