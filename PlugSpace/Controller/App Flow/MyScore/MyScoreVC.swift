//
//  MyScoreVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class MyScoreVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBOutlet weak var viewScorePrivate: UIView!
    @IBOutlet weak var viewRealittyScore: UIView!
    @IBOutlet weak var viewIScoreMyself: UIView!
    @IBOutlet weak var viewRealittyScoreRound: UIView!
    @IBOutlet weak var viewIScoreMyselfRound: UIView!
    
    @IBOutlet weak var lblPlugspaceScore: UILabel!
    @IBOutlet weak var lblSelfScore: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    
    @IBOutlet weak var tblCharacteristics: UITableView!
    @IBOutlet weak var heightTbl: NSLayoutConstraint!
    
    //MARK:- Propties
    
    var viewModel = MyScoreVM()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        getMyScoreApi()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblCharacteristics.layer.removeAllAnimations()
        heightTbl.constant = tblCharacteristics.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    //MARK:- Function
    
    func setUpScreen() {
        
        tblCharacteristics.register(UINib(nibName: "MyScoreTVCell", bundle: nil), forCellReuseIdentifier: "MyScoreTVCell")
        
        setAfter { [self] in
            
            viewScorePrivate.setCornerRadius(10)
            viewScorePrivate.setShadow(4, 0, 0, AppColor.Orange, 0.2)
            
            viewRealittyScore.setCornerRadius(10)
            viewRealittyScoreRound.setCornerRadius(viewRealittyScoreRound.frame.height / 2)
            viewRealittyScore.setShadow(4, 0, 0, AppColor.Orange, 0.2)
            viewRealittyScoreRound.setShadow(3, 0, 0, AppColor.Orange, 0.2)
            
            viewIScoreMyself.setCornerRadius(10)
            viewIScoreMyselfRound.setCornerRadius(viewIScoreMyselfRound.frame.height / 2)
            viewIScoreMyself.setShadow(4, 0, 0, AppColor.FontBlack, 0.2)
            viewIScoreMyselfRound.setShadow(3, 0, 0, AppColor.FontBlack, 0.2)
        }
    }
    
    func setData() {
        lblPlugspaceScore.text =  viewModel.userScoreData.plugSpaceRank
        lblSelfScore.text =  viewModel.userScoreData.rank != "" ? viewModel.userScoreData.rank : "0"
        mySwitch.isOn =  viewModel.userScoreData.isPrivate == "0" ? false : true
        tblCharacteristics.delegate = self
        tblCharacteristics.dataSource = self
        self.tblCharacteristics.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tblCharacteristics.reloadData()
    }
    
    private func NoDataFound() {
        
        removeNewNoDataViewFrom(containerView: tblCharacteristics)
        if  viewModel.userScoreData == nil  {
            setNoDataFoundView(containerView: tblCharacteristics, text:"")
        }
    }
    
    //MARk:- Api
    func privateScoreApi() {
        
        viewModel.isPrivateScore { [self] (isSuccess) in
            
            if isSuccess {
                
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    func getMyScoreApi() {
        
        viewModel.getMyScore { [self] (isSuccess) in
            NoDataFound()
            isSuccess ? setData() : alertWith(message: viewModel.errorMessage)
        }
    }
    
    //MARK:- Action
    
    @IBAction func clickOnSwicth(_ sender: UISwitch) {
        
        viewModel.isPrivate = sender.isOn ? "1" : "0"
        
        guard viewModel.validation() else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        
        privateScoreApi()
    }
}

//MARK:- TableView

extension MyScoreVC :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userScoreData.characteristics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(MyScoreTVCell.self, indexPath: indexPath)
        cell.setData(data: viewModel.userScoreData.characteristics[indexPath.row])
        
        return cell
    }
}
