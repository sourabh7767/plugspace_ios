//
//  SavedProfileVC.swift
//  PlugSpace
//
//  Created by Kaushal on 25/06/22.
//

import UIKit

class SavedProfileVC: BaseVC {
    //MARK:- Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Propties
    
     let viewModel = SavedProfileVM()

    //MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(LikeTableCell.self)
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 85
       
    }
    
    
    func getProfiles() {
        viewModel.getSavedProfile { isSuccess in
            
            if isSuccess
            {
                self.tableView.reloadData()
            }
            else
            {
                self.alertWith(message: self.viewModel.errorMessage)
                self.noSavedProfileData(isSearch: false)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfiles()
//        viewModel.superVc.txtSearch.delegate = self
    }
    
    //MARK:- Function

    func noSavedProfileData(isSearch:Bool) {
        guard tableView != nil else {return}
        if isSearch {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.SavedUserSearchArr.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No Saved Profile Found!")
            }
        } else {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.SavedUserArr.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No Saved Profile Found!")
            }
        }
    }
    
    private func applySearch() {
        if !viewModel.superVc.searchText.isEmptyOrWhiteSpace {
            viewModel.SavedUserSearchArr = viewModel.SavedUserArr.filter { $0.name.range(of: viewModel.superVc.searchText, options: .caseInsensitive) != nil }
            noSavedProfileData(isSearch: true)
            tableView.reloadData()
        }
    }
    
    //MARK:- Action
}

//MARK:- Function

extension SavedProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.SavedUserArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableCell") as! LikeTableCell
        cell.setDataForSavedProfile(data: viewModel.SavedUserArr[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.viewModel.userId = viewModel.SavedUserArr[indexPath.row].userId
        viewModel.superVc.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -   UITextFieldDelegate

extension SavedProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            return false
        }
        
        viewModel.SavedUserSearchArr.removeAll()
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.superVc.searchText = text
        applySearch()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        noSavedProfileData(isSearch: false)
        tableView.reloadData()
    }
}
