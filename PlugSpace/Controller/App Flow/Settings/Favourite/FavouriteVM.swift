//
//  FavouriteVM.swift
//  PlugSpace
//
//  Created by MAC on 03/12/21.
//

import Foundation

class FavouriteVM :BaseVM {
    
    //MARK:- Properties
    
    var musicArrSelectedimg = ["ic_exercise_selected","ic_relax_selected","ic_cars_selected","ic_wedding_selected","ic_regions_selected"]
    
    var musicArrDeselectedimg = ["ic_exercise","ic_relax","ic_cars","ic_wedding","ic_regions"]
    
    var musicArr = ["Exercise Songs","Relax Songs","Cars songs","Wedding Songs","Regions Songs"]
    var musicTypeArr = ["exercise","relax","cars","wedding","regions"]
    var indexpath:IndexPath!
    var userID = ""
}
