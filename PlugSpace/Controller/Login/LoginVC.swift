//
//  LoginVC.swift
//  PlugSpace
//
//  Created by MAC on 13/11/21.
//

import UIKit
import AuthenticationServices
import AVKit

class LoginVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var viewApple: UIView!
    @IBOutlet private weak var btnInstagram: UIButton!
    @IBOutlet private weak var btnContinue: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var txtShadowView: UIView!
    @IBOutlet private weak var txtCornerView: UIView!
    @IBOutlet private weak var txtMobilenumber: UITextField!
    @IBOutlet private weak var lblCode: UILabel!
    @IBOutlet private weak var imgCountry: UIImageView!
    @IBOutlet private weak var orView: UIStackView!
    @IBOutlet private weak var lblOr: UILabel!
    
    // MARK: - Properties
    
    var viewModel = OtpVM()
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMobilenumber.delegate = self
        setupUI()
        if isDevelopmentMode {
            txtMobilenumber.text = "79840"
            lblCode.text = "+91"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getCountry), name: NSNotification.Name(rawValue: "getCountry"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - SetupUI
    private func setupUI() {
    
        imgCountry.clipsToBounds = true
        imgCountry.cornerRadius = 8
        btnInstagram.cornerRadius = 10
        btnContinue.cornerRadius = 10
        txtCornerView.cornerRadius = 10
        btnInstagram.setBorder(1, AppColor.Orange)
        txtMobilenumber.setBlankView(10, .Left)
        
        if #available(iOS 13.0, *) {
            viewApple.isHidden = false
            setupLoginView()
        } else {
            orView.isHidden = true
            lblOr.isHidden = true
            viewApple.isHidden = true
        }
        setAfter { [self] in
            cornerView.Set_Corner([.bottomLeft, .bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
            
            txtShadowView.cornerRadius = 10
            txtShadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            txtShadowView.layer.shadowOffset = CGSize.zero
            txtShadowView.layer.shadowOpacity = 0.2
            txtShadowView.layer.shadowRadius = 5.0
            txtShadowView.layer.masksToBounds =  false
        }
    }
     
    @objc private func getCountry() {
        let temp =  CountryPiker.shared.getCountryAndCode()
        lblCode.text = temp.0
        imgCountry.image = temp.1
    }
    
    //MARK:- Play WelCome Video
    
//    func playVideo() {
//
//        guard let path = Bundle.main.path(forResource: "PlugspaceWelcome", ofType:"mp4") else {
//            debugPrint("PlugspaceWelcome.mp4 not found")
//            return
//        }
//
//        let player = AVPlayer(url: URL(fileURLWithPath: path))
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        playerViewController.showsPlaybackControls = false
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//    }
//
//    @objc func playerDidFinishPlaying(sender: Notification) {
//        dismiss(animated: true, completion: nil)
//
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//    }
    
    @available(iOS 13.0, *)
    func setupLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn , style: .black)
        authorizationButton.layer.masksToBounds = true
//        authorizationButton.cornerRadius = 10
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
            AppleData.shared.isLogin = true
            AppleData.shared.loginWithApple()
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnContinue(_ sender: UIButton) {
     
        viewModel.phone = txtMobilenumber.text!
        viewModel.ccode = lblCode.text!
        viewModel.isSignup = "0"
        
        guard viewModel.validationOtpNumber() else {
            self.errorAlert(message: self.viewModel.errorMessage)
            return
        }
        
        self.view.endEditing(true)
        
        viewModel.sendOtp { [self] (isSuccess) in
            
            if isSuccess {
                
                let vc = UIStoryboard.instantiateVC(OtpVC.self)
                vc.txtNumber = txtMobilenumber.text!
                vc.ccode = lblCode.text!
//                vc.combinedArr =  viewModel.otp[0].otpcode ?? ""
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
    
    @IBAction private func onBtnSignup(_ sender: UIButton) {
        pushVC(SignUpVC.self)
    }
    
    @IBAction private func onBtnInsta(_ sender: UIButton) {
        let vc = UIStoryboard.instantiateVC(InstagramVC.self)
        vc.isLogin = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func onBtnApple(_ sender: UIButton) {
//        if #available(iOS 13.0, *) {
//            AppleData.shared.loginWithApple()
//        } else {
//            alertWith(message: StringConstant.appleLogin)
//        }
    }
}

//MARK:- TextFiled

extension LoginVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtMobilenumber {
//            txtMobilenumber.text = ""
            txtCornerView.setBorder(0.2, AppColor.Orange)
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            txtCornerView.setBorder(0.0, AppColor.Orange)
    }
}
