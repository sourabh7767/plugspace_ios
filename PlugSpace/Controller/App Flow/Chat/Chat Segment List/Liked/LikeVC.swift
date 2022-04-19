//
//  LikeVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class LikeVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Propties
    
     let viewModel = LikeVM()

    //MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(LikeTableCell.self)
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 85
        noLikeData(isSearch: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.superVc.txtSearch.delegate = self
    }
    
    //MARK:- Function
    
    func noLikeData(isSearch:Bool) {
        guard tableView != nil else {return}
        if isSearch {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.likeUserSearchArr.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No Likes Found!")
            }
        } else {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.likeUserArr.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No Likes Found!")
            }
        }
    }
    
    private func applySearch() {
        if !viewModel.superVc.searchText.isEmptyOrWhiteSpace {
            viewModel.likeUserSearchArr = viewModel.likeUserArr.filter { $0.name.range(of: viewModel.superVc.searchText, options: .caseInsensitive) != nil }
            noLikeData(isSearch: true)
            tableView.reloadData()
        }
    }
    
    //MARK:- Action
}

//MARK:- Function

extension LikeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.likeUserArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableCell") as! LikeTableCell
        cell.setData(data: viewModel.likeUserArr[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.viewModel.userId = viewModel.likeUserArr[indexPath.row].likeUserId
        viewModel.superVc.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -   UITextFieldDelegate

extension LikeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            return false
        }
        
        viewModel.likeUserSearchArr.removeAll()
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.superVc.searchText = text
        applySearch()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        noLikeData(isSearch: false)
        tableView.reloadData()
    }
}
