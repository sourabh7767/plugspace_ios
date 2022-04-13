//
//  MeetVC.swift
//  PlugSpace
//
//  Created by MAC on 22/11/21.
//

import UIKit

class MeetVC: BaseVC {
    
    //MARK:- Outlets
    
    @IBOutlet weak var cornerView:UIView!
    @IBOutlet weak var shadowView:UIView!
    @IBOutlet var imgSelected:[UIImageView]!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet var borderView:[UIView]!
    @IBOutlet var lblGender:[UILabel]!
    
    //MARK:- Properties
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.niceMeet = ""
        setupUI()
        setShadow(indexView:0)
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        borderView.setCornerRadius(10)
        setAfter { [self] in
           
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
            borderView.setShadow(5.0, 0.0, 1, AppColor.Orange, 0.2)
        }
    }
    
    //MARK:- Method

    
    func setShadow(indexView:Int) {
        borderView.enumerated().forEach { (index, img) in
            
            if indexView == index {
                imgSelected[index].isHidden = false
                borderView[index].setBorder(0.2, AppColor.Orange)
                lblGender[index].textColor = AppColor.Orange
                btnNext.tag = index
            } else {
                imgSelected[index].isHidden = true
                borderView[index].setBorder(0, AppColor.Orange)
                lblGender[index].textColor = AppColor.FontBlack
            }
        }
    }
    

    //MARK:- IBAction
    
    @IBAction func btnDone(_ sender:UIButton) {
        SignUPVM.shared.niceMeet = lblGender[sender.tag].text!
        pushVC(SplashScreen2VC.self,storyboard: .Home)
      
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
    }
    
    
    @IBAction func btnMeet(_ sender:UIButton) {
        setShadow(indexView:sender.tag)
    }
}
