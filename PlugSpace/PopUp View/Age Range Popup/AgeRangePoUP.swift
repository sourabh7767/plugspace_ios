//
//  AgeRangePoUP.swift
//  PlugSpace
//
//  Created by MAC on 21/02/22.
//

import Foundation
import UIKit
import RangeSeekSlider

protocol ageRangeValueDelegate {
    func getValue(value:String, view:AgeRangePopUP)
}

class AgeRangePopUP: UIView {
    
    //MARK:- Outlets
    
    @IBOutlet private weak var btnDone: UIButton!
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var multiSlider: UIView!

    
    //MARK:- Properties
        
    private let horizontalMultiSlider = RangeSeekSlider()
    var delegate:ageRangeValueDelegate!

    
    //MARK:-
    
    override func awakeFromNib() {
        setupUI()
        setUpMultiSlider()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        mainView.setShadowView(color: AppColor.black, opacity: 0.5, offset: CGSize(width: 0.5, height: 0.5),radius: 6)
        btnDone.cornerRadius = 10
        mainView.cornerRadius = 10
    }
    
    //MARK:- Method
    
    private func setUpMultiSlider() {
    
        horizontalMultiSlider.handleColor = AppColor.Orange
        horizontalMultiSlider.handleBorderColor = AppColor.Orange
        horizontalMultiSlider.tintColor = .white
        horizontalMultiSlider.minValue = 18
        horizontalMultiSlider.maxValue = 100
        horizontalMultiSlider.selectedMinValue = 18
        horizontalMultiSlider.selectedMaxValue = 26
        horizontalMultiSlider.minLabelFont = UIFont(name: AppFont.bold, size: setCustomFont(18))!
        horizontalMultiSlider.maxLabelFont = UIFont(name: AppFont.bold, size: setCustomFont(18))!
        horizontalMultiSlider.minLabelColor = #colorLiteral(red: 0.9607843137, green: 0.6784313725, blue: 0.09803921569, alpha: 1)
        horizontalMultiSlider.maxLabelColor = AppColor.Orange
        horizontalMultiSlider.labelPadding = -90
        horizontalMultiSlider.colorBetweenHandles = AppColor.Orange
        horizontalMultiSlider.handleImage = UIImage(named: "ic_maximumThume")
        horizontalMultiSlider.lineHeight = 8
        
        multiSlider.addConstrainedSubview(horizontalMultiSlider, constrain: .leftMargin, .rightMargin, .bottomMargin)
    }
    
    //MARK:- IBAction
    @IBAction private func onBtnbtnDone(_ sender: UIButton) {
        let minValue = String(format: "%.0f", horizontalMultiSlider.selectedMinValue)
        let maxValue = String(format: "%.0f", horizontalMultiSlider.selectedMaxValue)
        delegate.getValue(value: "\(minValue)-" + "\(maxValue)", view: self)
        closeXIB(XIB: self)
    }
}
