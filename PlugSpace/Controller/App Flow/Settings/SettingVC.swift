//
//  SettingVC.swift
//  PlugSpace
//
//  Created by MAC on 15/11/21.
//

import UIKit

class SettingVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Propties
    
    var viewModel = SettingVM()
    let nameArr = ["Subscriptions","Favourite","Help","FAQ's","Contact Us","Logout"]
    var vcIds : [UIViewController.Type] = [SubscriptionVC.self,FavouriteVC.self,HelpVC.self,FAQVC.self,ContactUsVC.self]
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(SettingsTableCell.self)
        tableView.contentInset.top = 10
    }
    
    //MARK:- Method
    
    func logOutApi() {
        
        let alert = UIAlertController(title: AppName, message: StringConstant.logout, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { [weak self] action in
            let vc = self
            //MARK:- Changes
            vc?.viewModel.logOut { (isSuccess) in
                
                if isSuccess {
                    
                    appdelegate.logoutFromApplication()
                } else {
                    if let vc = vc {
                        vc.alertWith(message: vc.viewModel.errorMessage)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Action
    
    @IBAction func clickOnBtnBack(_ sender: UIButton) {
        backVC()
    }
}

//MARK:- UITableView

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableCell") as! SettingsTableCell
      
        cell.lblName.text = nameArr[indexPath.row]
        indexPath.row == nameArr.count - 1 ? cell.hideImage() : nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexPath.row == nameArr.count - 1 ? logOutApi() : pushVC(vcIds[indexPath.row], storyboard: .Home)
    }
}
