//
//  SignUpVC.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit
import AuthenticationServices
import CountryPickerView

class SignUpVC : BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var viewApple: UIView!
    @IBOutlet private weak var btnInstagram: UIButton!
    @IBOutlet private weak var btnContinue: UIButton!
    @IBOutlet private weak var txtShadowView: UIView!
    @IBOutlet private weak var txtCornerView: UIView!
    @IBOutlet private weak var txtMobileNumber: UITextField!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var lblCode: UILabel!
    @IBOutlet private weak var imgCountry: UIImageView!
    @IBOutlet private weak var orView: UIStackView!
    @IBOutlet private weak var lblOr: UILabel!
    @IBOutlet private weak var btnBack: UIButton!
    
    // MARK: - Properties
    
    var viewModel = OtpVM()
    var fromWelcome = false
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isDevelopmentMode {
            txtMobileNumber.text = "79840"
            lblCode.text = "+91"
        }
        txtMobileNumber.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(getCountry), name: NSNotification.Name(rawValue: "getCountry"), object: nil)
        btnBack.isHidden = fromWelcome ? true : false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnInstagram.cornerRadius = 10
        btnContinue.cornerRadius = 10
        txtCornerView.cornerRadius = 10
        
        imgCountry.clipsToBounds = true
        imgCountry.cornerRadius = 8
        
        btnInstagram.setBorder(1, AppColor.Orange)
        
        self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
        shadowView.cornerRadius = 34
        shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.masksToBounds =  false
        
        setAfter { [self] in 
            txtShadowView.cornerRadius = 10
            txtShadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            txtShadowView.layer.shadowOffset = CGSize.zero
            txtShadowView.layer.shadowOpacity = 0.2
            txtShadowView.layer.shadowRadius = 5.0
            txtShadowView.layer.masksToBounds =  false
        }
        
        if #available(iOS 13.2, *) {
            viewApple.isHidden = false
            setupLoginView()
        } else {
            orView.isHidden = true
            lblOr.isHidden = true
            viewApple.isHidden = true
        }
    }
    
    @available(iOS 13.2, *)
    func setupLoginView() {
        
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
        authorizationButton.layer.masksToBounds = true
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        viewApple.addSubview(authorizationButton)
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(item: authorizationButton, attribute: .leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewApple, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0)
        
        let trailing = NSLayoutConstraint(item: authorizationButton, attribute: .trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewApple, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0)
        
        let top = NSLayoutConstraint(item: authorizationButton, attribute: .top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewApple, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0)
        
        let bottom = NSLayoutConstraint(item: authorizationButton, attribute: .bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewApple, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0)
        
        self.view.addConstraint(leading)
        self.view.addConstraint(trailing)
        self.view.addConstraint(top)
        self.view.addConstraint(bottom)
    }
    
    @available(iOS 13.0, *)
    @objc func handleAuthorizationAppleIDButtonPress() {
            AppleData.shared.isLogin = false
            AppleData.shared.loginWithApple()
    }
    
   @objc private func getCountry() {
        let temp =  CountryPiker.shared.getCountryAndCode()
        lblCode.text = temp.0
        imgCountry.image = temp.1
   }
    
    // MARK: - IBAction
    @IBAction private func onBtnContinue(_ sender: UIButton) {
        
        viewModel.phone = txtMobileNumber.text!
        viewModel.ccode = lblCode.text!
        viewModel.isSignup = "1"
        
        guard viewModel.validationOtpNumber() else {
            self.errorAlert(message: self.viewModel.errorMessage)
            return
        }
        
        self.view.endEditing(true)
        
        viewModel.sendOtp { [self] (isSuccess) in
            
            if isSuccess {
                    let vc = UIStoryboard.instantiateVC(SignUpOtpVC.self)
                    vc.txtNumber = txtMobileNumber.text!
                    vc.ccode = lblCode.text!
//                    vc.combinedArr = viewModel.otp[0].otpcode ?? ""
                    vc.showToast(message: StringConstant.otpSent, y: view.Getheight - 120, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
                    navigationController?.pushViewController(vc, animated: true)
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    @IBAction private func onBtnCountry(_ sender: UIButton) {
        
        view.endEditing(true)
        CountryPiker.shared.setCountryPiker(controller: self)
    }
    
    @IBAction private func onBtnLogin(_ sender: UIButton) {
        pushVC(LoginVC.self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        backVC()
    }
    
    @IBAction private func onBtnInsta(_ sender: UIButton) {
        let vc = UIStoryboard.instantiateVC(InstagramVC.self)
        vc.isLogin = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- TextFiled

extension SignUpVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtMobileNumber {
//            txtMobileNumber.text = ""
            txtCornerView.setBorder(0.2, AppColor.Orange)
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtCornerView.setBorder(0.0, AppColor.Orange)
    }
}

//MARK:- Country

extension SignUpVC : CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
                self.lblCode.text = country.code
                self.imgCountry.image = country.flag
    }
}
