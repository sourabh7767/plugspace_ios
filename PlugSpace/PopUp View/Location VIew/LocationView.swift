//
//  LocationView.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import Foundation
import UIKit
import CoreLocation

class LocationPopUpView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnEnable: UIButton!
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - Properties
    
    // MARK: - Method
    
    override func awakeFromNib() {
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnEnable.cornerRadius = 10
        mainView.cornerRadius = 10
    }
    
    // MARK: - IBAction
    
    @IBAction private func onBtnContinue(_ sender: UIButton) {
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
           
        } else {
            AppPrefsManager.shared.getLocationPopUp() ? nil : LocationManager.shared.setupLocationManager()
        }
            
        AppPrefsManager.shared.LocationPopUp(isUserLogin: true)
        closeXIB(XIB: self)
    }
}
