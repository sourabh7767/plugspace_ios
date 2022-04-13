//
//  AddPhotoVM.swift
//  PlugSpace
//
//  Created by MAC on 30/11/21.
//

import Foundation
import UIKit
import DKImagePickerController

class AddPhotoVM: BaseVM {
    
    //MARK:- Properties
    
    var imgArr = [UIImage]()
    var index = 0
    let multiImagePickerController = DKImagePickerController()
    var assets: [DKAsset]?

}
