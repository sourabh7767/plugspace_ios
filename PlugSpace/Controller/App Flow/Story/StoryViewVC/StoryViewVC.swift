//
//  StoryViewVC.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit

class StoryViewVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblViewsCount: UILabel!
    
    //MARK:- Propties
    
    let viewModel = StoryViewsVM()
    
    //MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        lblViewsCount.text = viewModel.viewStoryCount != "0" ? viewModel.viewStoryCount + " | Views" : "Views"
        tableView.delegate = self
        tableView.dataSource = self
        NoStoryViewFound()
        tableView.reloadData()
        tableView.registerNib(StoryViewTableCell.self)
        tableView.contentInset.top = 10
    }
    
    //MARK:- Function
    
    private func NoStoryViewFound() {
        removeNewNoDataViewFrom(containerView: tableView)
        if viewModel.storyViewDetailsArr.count == 0 {
            setNoDataFoundView(containerView: tableView, text:"No Story Views Found!")
        }
    }
    
    //********************************************
    //MARK:- Action
    //********************************************
    
    @IBAction func clickBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//********************************************
//MARK:- Action
//********************************************

extension StoryViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.storyViewDetailsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryViewTableCell") as! StoryViewTableCell
        cell.setData(data: viewModel.storyViewDetailsArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.viewModel.userId = viewModel.storyViewDetailsArr[indexPath.row].viewUserId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
