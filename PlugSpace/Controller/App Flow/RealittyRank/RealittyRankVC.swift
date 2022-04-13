//
//  RealittyRankVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class PlugspaceRankVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var viewRealittyScore: UIView!
    @IBOutlet weak var viewIScoreMyself: UIView!
    @IBOutlet weak var viewRealittyScoreRound: UIView!
    @IBOutlet weak var viewIScoreMyselfRound: UIView!
    @IBOutlet weak var lblRealittyScore: UILabel!
    @IBOutlet weak var lblSelfScore: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    //MARK:- Propties

     let viewModel = RealityScoreVM()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        callGetFriendsScoreApi()
    }
   
    //MARK:- Function
    
    func setUpScreen() {
        setAfter { [self] in
            viewRealittyScore.setCornerRadius(10)
            viewRealittyScoreRound.setCornerRadius(viewRealittyScoreRound.frame.height / 2)
            viewRealittyScore.setShadow(6, 0, 0, AppColor.Orange, 0.2)
            viewRealittyScoreRound.setShadow(6, 0, 0, AppColor.Orange, 0.2)
            
            viewIScoreMyself.setCornerRadius(10)
            viewIScoreMyselfRound.setCornerRadius(viewIScoreMyselfRound.frame.height / 2)
            viewIScoreMyself.setShadow(6, 0, 0, AppColor.FontBlack, 0.2)
            viewIScoreMyselfRound.setShadow(6, 0, 0, AppColor.FontBlack, 0.2)
        }
    }

    func callGetFriendsScoreApi() {
        
        viewModel.getFriendsScore { [self] (isSuccess) in
            
//            viewIScoreMyself.isHidden = viewModel.scoreData.isPrivate == "1" ? true : false
            lblRealittyScore.text = viewModel.scoreData.plugspaceRank
            lblSelfScore.text = viewModel.scoreData.rank != "" ? viewModel.scoreData.rank : "0"
            viewIScoreMyself.isHidden = viewModel.scoreData.isPrivate == "1" ? true : false
            guard  viewModel.scoreData.characteristics.count != 0 else {
                lblDescription.text = "-"
                return
            }
                for (_, data) in viewModel.scoreData.characteristics.enumerated() {
//                    let _: NSAttributedString = "\(data.name)\n\n \(data.text)\n\n".attributedStringWithColor(["\(data.text)"], color: AppColor.FontBlack, font: UIFont(name: AppFont.reguler, size: 16)!)
                    lblDescription.text?.append("\(data.text)\n\n")
                }
            }
        }
    
    //MARK:- Action
    
    @IBAction func clickBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
