//
//  NameVC.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit

class NameVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var txtName: UITextField!
    @IBOutlet private weak var nameView: UIView!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isDevelopmentMode {
            txtName.text = "Sumit"
        }
        
        SignUPVM.shared.name = ""
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        nameView.cornerRadius = 10
        txtName.delegate = self
        
        setAfter { [self] in
            txtName.setBlankView(20, .Left)
            nameView.setShadow(3.0, 2, 2, AppColor.Orange, 0.2)
            
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
     
        SignUPVM.shared.name = txtName.text!
        SignUPVM.shared.name != "" ? pushVC(RankVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self) 
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
}

//MARK:- UITexField

extension NameVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        nameView.setBorder(0.2, AppColor.Orange)
            if textField == txtName {
               
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameView.setBorder(0.0, AppColor.Orange)
    }
}
