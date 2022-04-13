//
//  MakeOverVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class SalaryVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var txtSalary: UITextField!
    @IBOutlet private weak var salaryView: UIView!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSalary.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        salaryView.cornerRadius = 10
        
        setAfter { [self] in
            txtSalary.setBlankView(20, .Left)
            salaryView.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
            
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
     
        SignUPVM.shared.makeOver = txtSalary.text!

        pushVC(DressSizeVC.self,animated: false)
    }
    
    @IBAction private func onBtnSkip(_ sender: UIButton) {
     
        pushVC(DressSizeVC.self,animated: false)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
}


//MARK:- UITexField

extension SalaryVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        salaryView.setBorder(0.2, AppColor.Orange)
            if textField == txtSalary {
               
            return true
        }
        return true
    }
      
    func textFieldDidEndEditing(_ textField: UITextField) {
        salaryView.setBorder(0.0, AppColor.Orange)
    }
}
