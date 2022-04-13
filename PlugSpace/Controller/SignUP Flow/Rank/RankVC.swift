//
//  RankVC.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit
import MultiSlider

class RankVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var multiSlider: UIView!
    @IBOutlet private weak var lblRankDescription: UILabel!
    @IBOutlet private weak var lblGenderBaseTitle : UILabel!
    
    // MARK: - Properties
    
    var viewModel = RankVM()
    var gender = ""
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setUpMultiSlider()
        callRankPersonAPi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        lblGenderBaseTitle.text = SignUPVM.shared.gender.contains("Male") ? StringConstant.maleTitle : StringConstant.femaleTitle
        
        btnNext.cornerRadius = 10
        lblName.isHidden = true
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
    
    private func callRankPersonAPi() {
        
        viewModel.rank = "1"
        viewModel.gender = SignUPVM.shared.gender
        
        guard viewModel.validation() else {
            self.errorAlert(message: viewModel.errorMessage)
            return
        }
        
        viewModel.getManRankPerson { [self] (isSuccess) in
            
            if isSuccess {
                getRankPerson()
                
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    private func setUpMultiSlider() {
        
        let horizontalMultiSlider = MultiSlider()
        
        horizontalMultiSlider.isValueLabelRelative = true
        horizontalMultiSlider.disabledThumbIndices = [3]
        horizontalMultiSlider.thumbCount = 1
        horizontalMultiSlider.thumbImage = UIImage(named: "sinlgeProgressBar")
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.minimumValue = 1
        horizontalMultiSlider.maximumValue = 10
        horizontalMultiSlider.outerTrackColor = .white
        horizontalMultiSlider.value = [2]
        horizontalMultiSlider.valueLabelPosition = .top
        horizontalMultiSlider.tintColor = AppColor.Orange
        horizontalMultiSlider.trackWidth = 6
        horizontalMultiSlider.showsThumbImageShadow = true
        horizontalMultiSlider.setShadow(3.0, 0.0, 1, AppColor.FontBlack, 0.2)
        horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        horizontalMultiSlider.snapStepSize = 1
        horizontalMultiSlider.valueLabelColor = #colorLiteral(red: 0.9764705882, green: 0.4156862745, blue: 0.1176470588, alpha: 1)
        horizontalMultiSlider.valueLabelFont = UIFont(name: AppFont.bold, size: 20)
        
        multiSlider.addConstrainedSubview(horizontalMultiSlider, constrain: .leftMargin, .rightMargin, .bottomMargin)
        multiSlider.layoutMargins = UIEdgeInsets(top: -30, left: 16, bottom: -10, right: 16)
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        
        viewModel.rank = String(format: "%.0f", slider.value[0])
        viewModel.gender = SignUPVM.shared.gender
        
        guard viewModel.validation() else {
            self.errorAlert(message: viewModel.errorMessage)
            return
        }
        callRankPersonAPi()
    }
    
    func getRankPerson() {
        
        lblName.text?.removeAll()
        
        if viewModel.rankNameArr[0].data.count != 0 {
            for (index, name) in viewModel.rankNameArr[0].data.enumerated() {
                lblName.text?.append("\(index + 1). "+"\(name)\n")
            }
            lblName.isHidden = false
            lblRankDescription.isHidden = false
        } else {
            // lblName.text = "The rankers not found which you are selected!"
            lblName.isHidden = true
            lblRankDescription.isHidden = true
        }
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
        SignUPVM.shared.rankUser = viewModel.rank != "" ? viewModel.rank : "0"
        SignUPVM.shared.rankUser != "" ? pushVC(AddPhotoVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
    }
}
