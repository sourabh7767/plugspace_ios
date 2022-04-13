//
//  CountryExtention.swift
//  PlugSpace
//
//  Created by MAC on 25/01/22.
//

import Foundation
import UIKit
import CountryPickerView

class CountryPiker: NSObject {
    
    //MARK:- Properties
    
    static let shared = CountryPiker()
    
    private let countryPiker = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    private var flag = UIImage()
    private var PhoneCode = ""
    var CountryCode = ""
    
    //MARK:- Method
    
    func setCountryPiker(controller:UIViewController)  {
     
        countryPiker.delegate = self
        countryPiker.dataSource = self
        countryPiker.showCountriesList(from: controller)
    }
    
    func getCountryAndCode() -> (String,UIImage) {
        return (PhoneCode, flag)
    }
}

//MARK:- Country

extension CountryPiker : CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
                PhoneCode = country.phoneCode
                flag = country.flag
                CountryCode = country.code
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getCountry"), object: nil)
    }
    
    func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont(name: AppFont.bold, size: setCustomFont(18))!
    }

    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        return AppColor.Orange
    }
    
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont(name: AppFont.reguler, size: setCustomFont(18))!
    }

    func cellLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        return AppColor.black
    }

    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale {
        return Locale.current
    }

}
