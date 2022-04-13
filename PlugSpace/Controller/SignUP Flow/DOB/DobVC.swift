//
//  DobVC.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit

class DobVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var txtDob: UITextField!
    @IBOutlet private weak var txtTotalYear: UITextField!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var totalYearView: UIView!
    @IBOutlet private weak var dobView: UIView!
    
    // MARK: - Properties
    
    var viewModel = DobVM()
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.dob = ""
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        totalYearView.isHidden = true
        btnNext.cornerRadius = 10
        txtDob.cornerRadius = 10
        dobView.cornerRadius = 10
        txtTotalYear.cornerRadius = 10
        
        txtDob.delegate = self
        
        setAfter { [self] in
            
            txtDob.setBlankView(20, .Left)
            txtTotalYear.textAlignment = .center
            dobView.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
            txtTotalYear.setShadow(4.0, 2, 2, AppColor.Orange, 0.2)
            
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
        }
    }
    
    //MARK:- Handle DatePicker
    @objc func handleDatePicker()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        txtDob.text = dateFormatter.string(from: viewModel.date.date)
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
         
        txtTotalYear.text = viewModel.date.date.timeAgoSinceNow
        totalYearView.isHidden = false
        txtTotalYear.setBorder(0.2, AppColor.Orange)
      
        viewModel.date.date.lessthenYears() < 18 ? alertWith(message: StringConstant.dobValide) : nil
        txtDob.text! = viewModel.date.date.lessthenYears() < 18 ? "" : dateFormatter.string(from: viewModel.date.date)
    }
    
//    func callAgeCalculatorApi() {
//        viewModel.dob = txtDob.text!
//        guard viewModel.validation() else {
//            self.errorAlert(message: self.viewModel.errorMessage)
//            return
//        }
//
//        viewModel.ageCalculator { (isSuccess) in
//
//            if isSuccess {
//
//            }
//        }
//    }
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
        view.endEditing(true)
        SignUPVM.shared.dob = txtDob.text!
        SignUPVM.shared.dob != "" ? pushVC(ChildrenVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
}

//MARK:- Date Piker

extension DobVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        dobView.setBorder(0.2, AppColor.Orange)
            if textField == txtDob {
                if #available(iOS 14, *) {
                    viewModel.date.preferredDatePickerStyle = .wheels
                    viewModel.date.sizeToFit()
            }
                viewModel.date.datePickerMode = .date
                viewModel.date.maximumDate = Date()
                txtDob.inputView = viewModel.date
                viewModel.date.addTarget(self, action: #selector(handleDatePicker), for: UIControl.Event.valueChanged)
            return true
        }
      
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dobView.setBorder(0.0, AppColor.Orange)
    }
}
