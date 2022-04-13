//
//  RelationshipStatusVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class RelationshipStatusVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private var btnRelationshipStatus: [UIButton]!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.relationshipStatus = ""
        setShadow(indexView:0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        
        setAfter { [self] in
            for btn in self.btnRelationshipStatus {
                
                btn.layer.masksToBounds = false
                btn.layer.cornerRadius = 10
                btn.layer.shadowColor = AppColor.Orange.cgColor
                btn.layer.shadowPath = UIBezierPath(roundedRect: btn.bounds, cornerRadius:btn.layer.cornerRadius).cgPath
                btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                btn.layer.shadowOpacity = 0.2
                btn.layer.shadowRadius = 3.0
                
                btn.backgroundColor = UIColor.white
            }
            
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
        }
    }
    
    func setShadow(indexView:Int) {
        btnRelationshipStatus.enumerated().forEach { (index, img) in
            
            if indexView == index {
                btnRelationshipStatus[index].setTitleColor(AppColor.Orange, for: .normal)
                btnRelationshipStatus[index].titleLabel?.font = UIFont(name: AppFont.bold, size: setCustomFont(18))
                btnRelationshipStatus[index].setBorder(0.2, AppColor.Orange)
                btnNext.tag = index

            } else {
                btnRelationshipStatus[index].setTitleColor(AppColor.FontBlack, for: .normal)
                btnRelationshipStatus[index].titleLabel?.font = UIFont(name: AppFont.reguler, size: setCustomFont(18))
                btnRelationshipStatus[index].setBorder(0, AppColor.Orange)
            }
        }
    }
    
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
        SignUPVM.shared.relationshipStatus = btnRelationshipStatus[sender.tag].titleLabel!.text!
        pushVC(EthiniCityVC.self,animated: false)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
    
    @IBAction private func onBtnMarringRace(_ sender: UIButton) {
       
        setShadow(indexView:sender.tag)
    }
}
