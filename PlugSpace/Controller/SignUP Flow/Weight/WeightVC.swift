//
//  WeightVC.swift
//  PlugSpace
//
//  Created by MAC on 16/11/21.
//

import UIKit

class WeightVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var tblWeight:UITableView!
    @IBOutlet private weak var WeightTbl:NSLayoutConstraint!
    @IBOutlet private weak var scrollViewWeight: UIScrollView!
    @IBOutlet private weak var moreArrawView: UIView!
    
    // MARK: - Properties
    
    private var viewModel = WeightVM()

    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.weight = ""
        tblWeight.register(UINib(nibName: "WeightVCell", bundle: nil), forCellReuseIdentifier: "WeightVCell")
        tblWeight.delegate = self
        tblWeight.dataSource = self
        scrollViewWeight.delegate = self
        viewModel.selectedStateIndexPath = IndexPath(row: 0, section: 0)
        self.tblWeight.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblWeight.layer.removeAllAnimations()
        WeightTbl.constant = tblWeight.contentSize.height
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
     
        SignUPVM.shared.weight = "\(viewModel.selectedStateIndexPath!.row + 60)"
        SignUPVM.shared.weight != "" ? pushVC(EducationStatusVC.self,animated: false) : SignUPVM.shared.callValidationMethod(Vc: self)
    }

    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
        
    }
}

//MARK:- UITableView

extension WeightVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weightValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(WeightVCell.self, indexPath: indexPath)
        cell.SetData(text: "\(indexPath.row + 60)")
        if let ipath = viewModel.selectedStateIndexPath {
            
            ipath == indexPath ? cell.setBorder() : cell.removeBorder()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVC(EducationStatusVC.self,animated: false)
        viewModel.selectedStateIndexPath = indexPath
        SignUPVM.shared.weight = "\(viewModel.selectedStateIndexPath!.row + 60)"
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

