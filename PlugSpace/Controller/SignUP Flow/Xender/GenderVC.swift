//
//  GenderVC.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit
import CoreLocation

class GenderVC : BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private var btnXender: [UIButton]!
    @IBOutlet private var btnImage: [UIImageView]!
    
    // MARK: - Properties
    private var locationView = UIView.getView(viewT: LocationPopUpView.self)
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.gender = ""
        locationPermission()
        setShadow(indexView:0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        
        setAfter { [self] in
            for btn in self.btnXender {
                
                btn.layer.masksToBounds = false
                btn.layer.cornerRadius = 10
                btn.layer.shadowColor = AppColor.Orange.cgColor
                btn.layer.shadowPath = UIBezierPath(roundedRect: btn.bounds, cornerRadius:btn.layer.cornerRadius).cgPath
                btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                btn.layer.shadowOpacity = 0.2
                btn.layer.shadowRadius = 3.0
                btn.backgroundColor = UIColor.white
            }
            
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
        }
}
    
    func locationPermission() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||  !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined  {
            
            locationView = UIView.getView(viewT: LocationPopUpView.self)
            openXIB(XIB: locationView)
        }
    }
    
    func setShadow(indexView:Int) {
        btnXender.enumerated().forEach { (index, img) in
            
            if indexView == index {

                btnXender[index].titleLabel?.font = UIFont(name: AppFont.bold, size: setCustomFont(18))
                btnImage[index].isHidden = false
//                btnXender[index].setImage(UIImage(named: "ic_Selected"), for: .normal)
                btnXender[index].setBorder(0.2, AppColor.Orange)
                btnXender[index].setTitleColor(AppColor.Orange, for: .normal)
                btnNext.tag = index
            } else {
//                btnXender[index].setImage(UIImage(named: ""), for: .normal)
                btnImage[index].isHidden = true
                btnXender[index].titleLabel?.font = UIFont(name: AppFont.reguler, size: setCustomFont(18))
                btnXender[index].setBorder(0, AppColor.Orange)
                btnXender[index].setTitleColor(AppColor.FontBlack, for: .normal)
            }
        }
    }
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
        
        SignUPVM.shared.gender = btnXender[sender.tag].currentTitle ?? ""
        pushVC(NameVC.self,animated: false)
        
        // Location
        SignUPVM.shared.isGeoLocation =  CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||  !CLLocationManager.locationServicesEnabled() ? "0": "1"
        LocationManager.shared.getLocationString(completion: { (city) in
            SignUPVM.shared.location = city ?? ""
        })
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
    
    @IBAction private func onBtnXender(_ sender: UIButton) {
        setShadow(indexView:sender.tag)
    }
}
