//
//  RankManVC.swift
//  PlugSpace
//
//  Created by MAC on 22/11/21.
//

import UIKit
import MultiSlider

class RankManVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var multiSlider: UIView!
    @IBOutlet private weak var lblDescription: UILabel!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMultiSlider()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
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
    
    private func setUpMultiSlider() {
        
        let horizontalSlider = MultiSlider()
        
//        horizontalMultiSlider.minimumImage = UIImage(named:  "ic_minimumThume")
//        horizontalMultiSlider.maximumImage = UIImage(named: "ic_maximumThume")
        
        horizontalSlider.isValueLabelRelative = true
        horizontalSlider.disabledThumbIndices = [3]
        horizontalSlider.orientation = .horizontal
        horizontalSlider.minimumValue = 1
        horizontalSlider.maximumValue = 11
        horizontalSlider.outerTrackColor = .white
        horizontalSlider.value = [0]
        horizontalSlider.thumbImage = UIImage(named: "ic_maximumThume")
        horizontalSlider.valueLabelPosition = .top
        horizontalSlider.tintColor = AppColor.Orange
        horizontalSlider.trackWidth = 6
        horizontalSlider.showsThumbImageShadow = true
        horizontalSlider.setShadow(3.0, 0.0, 1, AppColor.FontBlack, 0.2)
        horizontalSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        horizontalSlider.distanceBetweenThumbs = 10
        horizontalSlider.keepsDistanceBetweenThumbs = true
        horizontalSlider.snapStepSize = 1
        horizontalSlider.valueLabelColor = #colorLiteral(red: 0.9764705882, green: 0.4156862745, blue: 0.1176470588, alpha: 1)
        horizontalSlider.valueLabelFont = UIFont(name: AppFont.bold, size: 20)
        
        multiSlider.addConstrainedSubview(horizontalSlider, constrain: .leftMargin, .rightMargin, .bottomMargin)
        multiSlider.layoutMargins = UIEdgeInsets(top: -30, left: 16, bottom: -10, right: 16)
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
//        print("thumb \(slider.draggedThumbIndex) moved")
//        print("now thumbs are at \(slider.value)")
        lblName.text = slider.value == [10] ? "1.Jasmine Tookes\n2.Genevieve Nnaji\n3.Rihanna Robyn Fenty\n4.Amara La Negra\n5.Jessica Alba\n6.Megan Fox\n7.Minka Kelly\n8.Scarlett Jonasson\n9.Amber Heard\n10.Kelly Rowland" : ""
        lblName.isHidden =  slider.value == [10] ?  false : true
        lblDescription.isHidden =  slider.value == [10] ?  false : true

    }
    
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
     
        pushVC(MeetVC.self,animated: false)
    }
}
