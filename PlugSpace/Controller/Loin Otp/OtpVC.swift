//
//  OtpVC.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit

class OtpVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnVerifyCode: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet var txtView: [UIView]!
    @IBOutlet private var txtCode: [MyTextField]!

    // MARK: - Properties
    
    var viewModel = OtpVM()
    var viewLoginModel = LoginVM()
    var txtNumber = ""
    var ccode = ""
        
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        
        btnVerifyCode.cornerRadius = 10
        
        for txt in txtCode {
            txt.delegate = self
            txt.textAlignment = .center
            txt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            txt.textContentType = .oneTimeCode
        }
        
        for view in txtView {
            view.cornerRadius = 8
            view.setShadow(4, 0.0, 2, AppColor.Orange, 0.2)
        }
        
        setAfter { [self] in
            cornerView.Set_Corner([.bottomLeft, .bottomRight], 40)
            
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
        }
    }
    
    
    //MARK:- Not Use
//    func callLoginApi() {
//        viewLoginModel.phone = txtNumber
//        viewLoginModel.ccode = ccode
//        viewLoginModel.isApple = "0"
//        viewLoginModel.appleId = "0"
//        viewLoginModel.isInsta = "0"
//        viewLoginModel.instaId = "0"
//
//        guard viewLoginModel.validation() else {
//            self.errorAlert(message: self.viewLoginModel.errorMessage)
//            return
//        }
//
//        self.view.endEditing(true)
//
//        viewLoginModel.login { [self] (isSuccess) in
//
//            if isSuccess {
////                self.successAlert(AppName, message: viewLoginModel.errorMessage, button: "OK") {
//                    appdelegate.goToHomeVc()
//
//            }else {
//                alertWith(message: viewLoginModel.errorMessage)
//            }
//        }
//    }
    
    func OtpResendSendApiCall()  {
        
        viewModel.phone = txtNumber
        viewModel.ccode = ccode
        viewModel.isSignup = "0"
        
        guard viewModel.validationOtpNumber() else {
            self.errorAlert(message: self.viewModel.errorMessage)
            return
        }
        
        self.view.endEditing(true)
        
        viewModel.sendOtp { [self] (isSuccess) in
            if isSuccess {
                showToast(message: StringConstant.otpSent, y: self.view.center.y, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
//                combinedArr = viewModel.otp[0].otpcode ?? ""
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnVerifyCode(_ sender: UIButton) {
        
        viewModel.phone = txtNumber
        viewModel.ccode = ccode
        viewModel.otpCode = txtCode[0].text! + txtCode[1].text! + txtCode[2].text! + txtCode[3].text!
        
        guard viewModel.validation() else {
            self.errorAlert(message: self.viewModel.errorMessage)
            return
        }
        
        self.view.endEditing(true)
        
        viewModel.verifyOTP { [self] (isSuccess) in
            
            if isSuccess {
                if viewModel.isLogin == "1" && viewModel.data != nil {
                    AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                    appdelegate.goToHomeVc()
                } else {
                    AppPrefsManager.shared.setIsUserLogin(isUserLogin: false)
//                    alertWith(message: viewModel.errorMessage)
                    SignUPVM.shared.phone = viewModel.phone
                    SignUPVM.shared.ccode = viewModel.ccode
                    SignUPVM.shared.isApple = "0"
                    SignUPVM.shared.appleId = "0"
                    SignUPVM.shared.isInsta = "0"
                    SignUPVM.shared.instaId = "0"
                    pushVC(GenderVC.self,animated: false)
                }
         
            }else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    @IBAction private func onBtnResend(_ sender: UIButton) {
        OtpResendSendApiCall()
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backVC()
        
    }
}


// MARK: - UITextFieldDelegate
extension OtpVC: UITextFieldDelegate, MyTextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text ?? ""
        
        if text.count == 0 {
            switch textField {
            case txtCode[0]:
                txtCode[0].becomeFirstResponder()
            case txtCode[1]:
                txtCode[0].becomeFirstResponder()
            case txtCode[2]:
                txtCode[1].becomeFirstResponder()
            case txtCode[3]:
                txtCode[2].becomeFirstResponder()
            case txtCode[4]:
                txtCode[3].becomeFirstResponder()
            case txtCode[5]:
                txtCode[4].becomeFirstResponder()
            default:
                break
            }
        } else if text.count == 1 {
            switch textField {
            case txtCode[0]:
                if (txtCode[1].text ?? "").isEmptyOrWhiteSpace {
                    txtCode[1].becomeFirstResponder()
                } else {
                    txtCode[0].resignFirstResponder()
                }
                
            case txtCode[1]:
                if (txtCode[2].text ?? "").isEmptyOrWhiteSpace {
                    txtCode[2].becomeFirstResponder()
                } else {
                    txtCode[1].resignFirstResponder()
                }
                
            case txtCode[2]:
                if (txtCode[3].text ?? "").isEmptyOrWhiteSpace {
                    txtCode[3].becomeFirstResponder()
                } else {
                    txtCode[2].resignFirstResponder()
                }
                
            case txtCode[3]:
                txtCode[3].resignFirstResponder()
                
            default:
                break
            }
        } else {
            
        }
        
        
        if txtCode.contains(where: { ($0.text ?? "").isEmptyOrWhiteSpace }) {
            print("Textfield empty.")
        } else {
            view.endEditing(true)
        }
    }
    
    func textField(_ textField: UITextField, didDeleteBackwardAnd wasEmpty: Bool) {
        if textField.text?.count == 0  {
            switch textField {
            case txtCode[0]:
                txtCode[0].becomeFirstResponder()
            case txtCode[1]:
                txtCode[0].becomeFirstResponder()
            case txtCode[2]:
                txtCode[1].becomeFirstResponder()
            case txtCode[3]:
                txtCode[2].becomeFirstResponder()
            case txtCode[4]:
                txtCode[3].becomeFirstResponder()
            case txtCode[5]:
                txtCode[4].becomeFirstResponder()
            default:
                break
            }
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    

}

