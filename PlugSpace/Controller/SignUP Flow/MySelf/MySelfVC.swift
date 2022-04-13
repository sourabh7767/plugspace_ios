//
//  MySelfVC.swift
//  PlugSpace
//
//  Created by MAC on 19/11/21.
//

import UIKit

class MySelfVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private var btnMySelf:[UIButton]!

    // MARK: - Properties
    
    var viewModel = ChildrenVM()
        
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.mySelfMen = ""
        setupUI()
        setShadow(indexView:0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        
        setAfter { [self] in
            
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.5
            shadowView.layer.shadowRadius = 6.0
            shadowView.layer.masksToBounds =  false
            
            for btn in self.btnMySelf {
                
                btn.layer.masksToBounds = false
                btn.layer.cornerRadius = 10
                btn.layer.shadowColor = AppColor.Orange.cgColor
                btn.layer.shadowPath = UIBezierPath(roundedRect: btn.bounds, cornerRadius:btn.layer.cornerRadius).cgPath
                btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                btn.layer.shadowOpacity = 0.2
                btn.layer.shadowRadius = 3.0
                
                btn.backgroundColor = UIColor.white
            }
        }
    }
    
    func setShadow(indexView:Int) {
        
        btnMySelf.enumerated().forEach { (index, img) in
            
            if indexView == index {
                btnMySelf[index].setTitleColor(AppColor.Orange, for: .normal)
                btnMySelf[index].titleLabel?.font = UIFont(name: AppFont.bold, size: setCustomFont(18))
                btnMySelf[index].setBorder(0.2, AppColor.Orange)
                btnNext.tag = index
            } else {
                btnMySelf[index].setTitleColor(AppColor.FontBlack, for: .normal)
                btnMySelf[index].titleLabel?.font = UIFont(name: AppFont.reguler, size: setCustomFont(18))
                btnMySelf[index].setBorder(0, AppColor.Orange)
            }
        }
        
    }
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
        SignUPVM.shared.mySelfMen =  btnMySelf[sender.tag].titleLabel!.text!
         pushVC(AboutVC.self,animated: false)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
    }
    
    @IBAction private func onBtnMySelf(_ sender: UIButton) {
        setShadow(indexView:sender.tag)
    }
}
