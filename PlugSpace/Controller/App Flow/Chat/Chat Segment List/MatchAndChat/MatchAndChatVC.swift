//
//  MatchAndChatVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import MobileCoreServices

class MatchAndChatVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Propties
    
    let viewModel = MatchAndChatVM()
    private var dbRef: DatabaseReference!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.superVc.txtSearch.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(MatchAndChatTableCell.self)
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 85
        getChatUserList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK:- Method
    
    private func noChatData(isSearch:Bool) {
        
        if isSearch {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.arrUserChatSearch.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No chat Found!")
            }
        } else {
            removeNewNoDataViewFrom(containerView: tableView)
            if viewModel.userChatArr.count == 0 {
                setNoDataFoundView(containerView: tableView, text:"No chat Found!")
            }
        }
    }
    
    private func applySearch() {
        if !viewModel.superVc.searchText.isEmptyOrWhiteSpace {
            viewModel.arrUserChatSearch = viewModel.userChatArr.filter { $0.name.range(of: viewModel.superVc.searchText, options: .caseInsensitive) != nil }
            noChatData(isSearch: true)
            tableView.reloadData()
        }
    }
    
     func getChatUserList() {
        
        let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
        
        guard isNetworkReachable() else {
            alertWith(message: NetworkError)
            noChatData(isSearch: false)
            return
        }
        
        IndicatorManager.showLoader()
        
        dbRef = Database.database().reference()
        
        dbRef.child(StringConstant.chatList).child(userId.userId).observe(.value) { [self] (snapshot) in
            IndicatorManager.hideLoader()
            
            self.viewModel.userChatArr.removeAll()
            if snapshot.exists() {
                for i in snapshot.children {
                    let list = i as! DataSnapshot
                    if let data = list.value as? [String:Any], let userData = ChatListModel(dict: data) {
                        self.viewModel.userChatArr.append(userData)
                    }
                }
            } else {
                
            }
    
            self.viewModel.userChatArr = self.viewModel.userChatArr.sorted(by: { (data1, data2) -> Bool in
                return data1.time > data2.time
            })
            
//            for message in self.viewModel.userChatArr {
//                if message.read_count == "0" {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetMessageBadgeIcon"), object: nil, userInfo: ["isShow": false])
//                } else {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetMessageBadgeIcon"), object: nil, userInfo: ["isShow": true])
//                    break
//                }
//            }
            
            
            if self.viewModel.userChatArr.contains(where: { $0.read_count == "0" }) {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetMessageBadgeIcon"), object: nil, userInfo: ["isShow": true])
             } else {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetMessageBadgeIcon"), object: nil, userInfo: ["isShow": false])
             }
             
            noChatData(isSearch:false)
            tableView.reloadData()
        }
    }
    
    func isNetworkReachable() -> Bool {
        return NetworkReachabilityManager(host: "www.apple.com")?.isReachable ?? false
    }
}

//MARK:- TableViewDelegate

extension MatchAndChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.superVc.searchText.count > 0 {
            return viewModel.arrUserChatSearch.count
        }
        
        return viewModel.userChatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchAndChatTableCell") as! MatchAndChatTableCell
        if viewModel.superVc.searchText.count > 0 {
            cell.setData(data: viewModel.arrUserChatSearch[indexPath.row])
        } else {
            cell.setData(data: viewModel.userChatArr[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var obj: ChatListModel
        if viewModel.superVc.searchText.count > 0 {
            obj = viewModel.arrUserChatSearch[indexPath.row]
        } else {
            obj = viewModel.userChatArr[indexPath.row]
        }
        
        let vc = UIStoryboard.instantiateVC(ChatVC.self,.Home)
        vc.conversationData = obj
        viewModel.superVc.show(vc, sender: nil)
    }
}

//MARK: -   UITextFieldDelegate

extension MatchAndChatVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            return false
        }
        
        viewModel.arrUserChatSearch.removeAll()
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.superVc.searchText = text
        applySearch()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        noChatData(isSearch: false)
        tableView.reloadData()
    }
}
