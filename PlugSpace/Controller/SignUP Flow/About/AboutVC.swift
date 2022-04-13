//
//  AboutVC.swift
//  PlugSpace
//
//  Created by MAC on 22/11/21.
//

import UIKit

class AboutVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var aboutTextView: UITextView!
    @IBOutlet private weak var textView: UIView!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.aboutYou = ""
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        aboutTextView.cornerRadius = 10
        textView.cornerRadius = 10
        aboutTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom:0, right: 10)
        aboutTextView.delegate = self
        
        setAfter { [self] in
           
//          aboutTextView.setShadow(3.0, 0.0, 1, AppColor.Orange, 0.2)
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
            
            textView.layer.masksToBounds = false
            textView.layer.cornerRadius = 10
            textView.layer.shadowColor = AppColor.Orange.cgColor
            textView.layer.shadowPath = UIBezierPath(roundedRect: textView.bounds, cornerRadius:textView.layer.cornerRadius).cgPath
            textView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            textView.layer.shadowOpacity = 0.2
            textView.layer.shadowRadius = 4.0
            
            textView.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
     
        SignUPVM.shared.aboutYou = aboutTextView.text
        SignUPVM.shared.aboutYou != "" ? pushVC(MeetVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
}

//MARK:- UITextView

extension AboutVC:UITextViewDelegate {
    
}
