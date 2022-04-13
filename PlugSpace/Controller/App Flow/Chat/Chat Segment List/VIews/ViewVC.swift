//
//  ViewVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class ViewVC: BaseVC {

    //MARK:- Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Propties
    
    let viewModel = ViewVM()

    //MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 85
        tableView.registerNib(ViewTableCell.self)
        NoViewData(isSearch: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.superVc.txtSearch.delegate = self
    }
    
    //MARK:- Function
    
    private func applySearch() {
        if !viewModel.superVc.searchText.isEmptyOrWhiteSpace {
            viewModel.viewProfileSearchArr = viewModel.viewProfileArr.filter { $0.name.range(of: viewModel.superVc.searchText, options: .caseInsensitive) != nil }
            NoViewData(isSearch: true)
            tableView.reloadData()
        }
    }
    
    func NoViewData(isSearch:Bool) {
        if isSearch {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.viewProfileSearchArr.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No Views Found!")
            }
        } else {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.viewProfileArr.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No Views Found!")
            }
        }
    }
    
    //MARK:- Action
}

//MARK:- Function

extension ViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewProfileArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTableCell") as! ViewTableCell
        cell.setData(data: viewModel.viewProfileArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.viewModel.userId = viewModel.viewProfileArr[indexPath.row].viewUserId
        viewModel.superVc.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -   UITextFieldDelegate

extension ViewVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            return false
        }

        viewModel.viewProfileSearchArr.removeAll()

        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.superVc.searchText = text
        applySearch()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        NoViewData(isSearch: false)
        tableView.reloadData()
    }
}
