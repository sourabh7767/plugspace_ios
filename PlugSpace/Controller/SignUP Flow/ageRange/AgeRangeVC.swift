//
//  AgeRangeVC.swift
//  PlugSpace
//
//  Created by MAC on 22/11/21.
//

import UIKit
import MultiSlider
import RangeSeekSlider

class AgeRangeVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var multiSlider: UIView!

    // MARK: - Properties
    
    let horizontalMultiSlider = RangeSeekSlider()
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.ageRangeMarriage = ""
        setupUI()
        setUpMultiSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        setAfter { [self] in
           
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
        }
    }       
    
    private func setUpMultiSlider() {
        
        multiSlider.setShadow(3.0, 0.0, 1, AppColor.FontBlack, 0.2)
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
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
        SignUPVM.shared.ageRangeMarriage = "\(Int(horizontalMultiSlider.selectedMinValue))-" + "\(Int(horizontalMultiSlider.selectedMaxValue))"
        SignUPVM.shared.ageRangeMarriage != "" ? pushVC(MySelfVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }

    @IBAction private func onBtnBack(_ sender: UIButton) {
            backNormalVC(animated: false)
    }
}
