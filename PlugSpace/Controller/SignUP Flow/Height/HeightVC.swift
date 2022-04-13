//
//  HeightVC.swift
//  PlugSpace
//
//  Created by MAC on 16/11/21.
//

import UIKit

class HeightVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var tblHeight:UITableView!
    @IBOutlet private weak var HeightTbl:NSLayoutConstraint!
    @IBOutlet private weak var moreArrawView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    
    private var viewModel = HeightVM()
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.height = ""
        tblHeight.register(UINib(nibName: "HeightTVCell", bundle: nil), forCellReuseIdentifier: "HeightTVCell")
        tblHeight.delegate = self
        tblHeight.dataSource = self
        scrollView.delegate = self

        viewModel.selectedStateIndexPath = IndexPath(row: 0, section: 0)
        self.tblHeight.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblHeight.layer.removeAllAnimations()
        HeightTbl.constant = tblHeight.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        
        btnNext.cornerRadius = 10
        
        setAfter { [self] in
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
        
        SignUPVM.shared.height != "" ? pushVC(WeightVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self) 
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
    
//    @IBAction private func onBtnHeight(_ sender: UIButton) {
//
//        btnHeight.enumerated().forEach { (index, img) in
//
//            if index == sender.tag {
//                btnHeight[index].setTitleColor(AppColor.Orange, for: .normal)
//                btnHeight[index].titleLabel?.font = UIFont(name: AppFont.bold, size: setCustomFont(18))
//                btnHeight[index].setBorder(0.2, AppColor.Orange)
//            } else {
//                btnHeight[index].setTitleColor(AppColor.FontBlack, for: .normal)
//                btnHeight[index].titleLabel?.font = UIFont(name: AppFont.reguler, size:                               setCustomFont(18))
//                btnHeight[index].setBorder(0, AppColor.Orange)
//            }
//        }
//    }
}

//MARK:- UITableView

extension HeightVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.HeightArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(HeightTVCell.self, indexPath: indexPath)
        cell.SetData(text: viewModel.HeightArray[indexPath.row])
        
        if let ipath = viewModel.selectedStateIndexPath {
            
            ipath == indexPath ? cell.setBorder() : cell.removeBorder()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVC(WeightVC.self,animated: false)
        viewModel.selectedStateIndexPath = indexPath
        SignUPVM.shared.height = viewModel.HeightArray[viewModel.selectedStateIndexPath!.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        moreArrawView.isHidden = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        moreArrawView.isHidden = true
    }
}
