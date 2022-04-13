//
//  DressSizeVC.swift
//  PlugSpace
//
//  Created by MAC on 19/11/21.
//

import UIKit

class DressSizeVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var tblDressSize:UITableView!
    @IBOutlet private weak var tblHeight:NSLayoutConstraint!
    @IBOutlet private weak var moreArrawView: UIView!
    @IBOutlet private weak var scrollViewDressSize: UIScrollView!

    
    // MARK: - Properties
    
    private var viewModel = DressSizeVM()
    private var selectedStateIndexPath : IndexPath?

    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.dressSize = ""
        selectedStateIndexPath = IndexPath(row: 0, section: 0)
        tblDressSize.delegate = self
        tblDressSize.dataSource = self
        scrollViewDressSize.delegate = self

        tblDressSize.register(UINib(nibName: "DressSizeTVCell", bundle: nil), forCellReuseIdentifier: "DressSizeTVCell")
        
        tblDressSize.reloadData()
        
        self.tblDressSize.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblDressSize.layer.removeAllAnimations()
        tblHeight.constant = tblDressSize.contentSize.height
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
            shadowView.layer.shadowOpacity = 0.5
            shadowView.layer.shadowRadius = 6.0
            shadowView.layer.masksToBounds =  false
        }
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnNext(_ sender: UIButton) {
        
        SignUPVM.shared.dressSize = viewModel.numberArray[selectedStateIndexPath!.row]

        SignUPVM.shared.dressSize != "" ? pushVC(SigniantBillsVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
    
}

//MARK:- UITableView

extension DressSizeVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDressSize.dequeCell(DressSizeTVCell.self, indexPath: indexPath)
        cell.SetData(text: viewModel.numberArray[indexPath.row])
        
        if let ipath = selectedStateIndexPath {
            
            ipath == indexPath ? cell.setBorder() : cell.removeBorder()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVC(SigniantBillsVC.self,animated: false) 
        selectedStateIndexPath = indexPath
         tableView.reloadData()
        SignUPVM.shared.dressSize = viewModel.numberArray[selectedStateIndexPath!.row]

     
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
