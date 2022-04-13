//
//  ChildrenVC.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit

class ChildrenVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var tblChildren: UITableView!
    @IBOutlet private weak var tblHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var viewModel = ChildrenVM()

    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.children = ""
        viewModel.selectedStateIndexPath = IndexPath(row: 0, section: 0)
        tblChildren.delegate = self
        tblChildren.dataSource = self
        tblChildren.register(UINib(nibName: "ChildrenTVCell", bundle: nil), forCellReuseIdentifier: "ChildrenTVCell")
        
        tblChildren.reloadData()
        
        self.tblChildren.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblChildren.layer.removeAllAnimations()
        tblHeight.constant = tblChildren.contentSize.height
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
        
        SignUPVM.shared.children = viewModel.numberArray[viewModel.selectedStateIndexPath!.row]
        SignUPVM.shared.children != "" ? pushVC(HowManyChildrenVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        backNormalVC(animated: false)
    }
}

//MARK:- UITableView

extension ChildrenVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(ChildrenTVCell.self, indexPath: indexPath)
        cell.SetData(text: viewModel.numberArray[indexPath.row])
        if let ipath = viewModel.selectedStateIndexPath {
            
            ipath == indexPath ? cell.setBorder() : cell.removeBorder()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectedStateIndexPath = indexPath
         tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}
