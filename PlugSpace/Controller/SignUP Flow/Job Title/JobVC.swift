//
//  JobVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class JobVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var txtJobName: UITextField!
    @IBOutlet private weak var jobNameView: UIView!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.jobTitle = ""
        txtJobName.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        jobNameView.cornerRadius = 10
        
        setAfter { [self] in
            txtJobName.setBlankView(20, .Left)
            jobNameView.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
            
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
        }
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
     
        SignUPVM.shared.jobTitle = txtJobName.text!

        SignUPVM.shared.jobTitle != "" ? pushVC(SalaryVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
    }
}

//MARK:- UITexField

extension JobVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        jobNameView.setBorder(0.2, AppColor.Orange)
            if textField == txtJobName {
               
            return true
        }
        return true
    }
     
    func textFieldDidEndEditing(_ textField: UITextField) {
        jobNameView.setBorder(0.0, AppColor.Orange)
    }
}
