//
//  HomeVC.swift
//  PlugSpace
//
//  Created by MAC on 19/11/21.
//

import UIKit
import FirebaseDatabase
import SwiftUI

class HomeVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet private weak var storyCollectionView: UICollectionView!
    @IBOutlet private weak var basicInfoCollectionView: UICollectionView!

    @IBOutlet private weak var basicInfoCollectionHeight: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var profileImgHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var viewProfile: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var imgUserProfileView: UIView!
    @IBOutlet private weak var imgbgView: UIView!
    @IBOutlet private weak var imgLocation: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet private var infoViewView: [UIView]!
    @IBOutlet private weak var UserDataView: UIView!
    
    @IBOutlet private weak var lblViewCount: UILabel!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblEducation: UILabel!
    @IBOutlet private weak var lblWork: UILabel!
    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var lblAboute: UILabel!
    @IBOutlet private weak var lblNoDataFound: UILabel!
    
    @IBOutlet private weak var txtMySelf: UITextField!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet private weak var imgProfile: UIImageView!
    
    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var btnLike: UIButton!
    @IBOutlet private weak var btnSearch: UIButton!
   
    //MARK:- Propties
  
    var viewModel = HomeVM()
    private var ReportViewPopUP = UIView.getView(viewT: ReportView.self)
    
    //MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        apiCalling()
        setUpScreen()
        
        profileImgHeight.constant = mainView.Getheight - topView.Getheight - 140
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        basicInfoCollectionView.layer.removeAllAnimations()
        basicInfoCollectionHeight.constant = basicInfoCollectionView.contentSize.height
        tableView.layer.removeAllAnimations()
        tableViewHeight.constant = tableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    //MARK:- Function
    
    func setUpScreen() {
        
        setAfter { [self] in
            imgbgView.Set_Corner([.bottomLeft,.bottomRight], 10)
        }
        
        txtSearch.isHidden = true
        txtSearch.delegate = self
        
        txtSearch.setBlankView(10, .Left)
        txtMySelf.setBlankView(20, .Left)
        
        infoViewView.setBorder(0.2, AppColor.Orange, 10)
        infoViewView.setShadow(3.0, 0.0, 2.0, AppColor.Orange, 0.2)
        
        storyCollectionView.registerNib(StoryCollectionCell.self)
        basicInfoCollectionView.registerNib(BasicInfoCell.self)
        tableView.registerNib(UserPostCell.self)
        
        txtSearch.setCornerRadius(10)
        viewProfile.setCornerRadius(10)
        imgProfile.setCornerRadius(10)
        imgUserProfileView.setCornerRadius(10)
    }
    
    func apiCalling() {
        
        viewModel.getHomeDetails { [self] (isSuccess) in
            NoStoryData()
            NoUserData()
            if isSuccess {
            
                NoUserData()
               
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    private func NoStoryData() {
        removeNewNoDataViewFrom(containerView: storyCollectionView)
        if viewModel.storyData.count == 0 {
            setNoDataFoundView(containerView: storyCollectionView, text:"No Story's Found!")
        }
    }
    
    private func NoUserData() {
        
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        storyCollectionView.reloadData()
        
        guard viewModel.userdata.count != 0 else {
            showToast(message: StringConstant.usrNotFound, y: mainView.Getheight - 160, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
            UserDataView.isHidden = true
            lblNoDataFound.isHidden = false
            return
        }
        
        lblNoDataFound.isHidden = true
        UserDataView.isHidden = false
        
       
            self.setData()
        
    }
    
    func setData() {
        
        viewModel.basicInfoArr.removeAll()
        lblName.text = viewModel.userdata[0].name + ", \(viewModel.userdata[0].age)" 
        lblWork.text = viewModel.userdata[0].jobTitle
        lblEducation.text = viewModel.userdata[0].educationStatus
        lblLocation.text = viewModel.userdata[0].location != "" ? viewModel.userdata[0].location : ""
        lblViewCount.text = viewModel.userdata[0].rank != "" ? viewModel.userdata[0].rank : "0"
        lblAboute.text = viewModel.userdata[0].aboutYou
        txtMySelf.text = viewModel.userdata[0].mySelfMen
        
       
        
        
        viewModel.basicInfoArr.append(viewModel.userdata[0].height)
        viewModel.basicInfoArr.append(viewModel.userdata[0].weight)
        viewModel.basicInfoArr.append(viewModel.userdata[0].children)
        viewModel.basicInfoArr.append(viewModel.userdata[0].relationshipStatus)
        viewModel.basicInfoArr.append(viewModel.userdata[0].ethinicity)
        viewModel.basicInfoArr.append(viewModel.userdata[0].makeOver != "" ? viewModel.userdata[0].makeOver : "")
        viewModel.basicInfoArr.append(viewModel.userdata[0].dressSize)
        viewModel.basicInfoArr.append(viewModel.userdata[0].timesOfEngaged)
        viewModel.basicInfoArr.append(viewModel.userdata[0].yourBodyTatto)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: {
            self.setProfileData()
        })
        
    }
    
    func setProfileData() {
        btnLike.tintColor = viewModel.userdata[0].isLike == "1" ? .red : .white
        
        if viewModel.userdata[0].mediaDetail.count != 0 {
            imgProfile.sd_setImage(with: URL(string: viewModel.userdata[0].mediaDetail[0].profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        }
        imgLocation.isHidden = viewModel.userdata[0].location != "" ? false : true
        
        basicInfoCollectionView.delegate = self
        basicInfoCollectionView.dataSource = self
        basicInfoCollectionView.reloadData()
        self.basicInfoCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    //********************************************
     //MARK:- Action
    //********************************************
    
    @IBAction func clickBtnNotification(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.viewModel.notificationData = viewModel.notificationData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickBtnSearch(_ sender: Any) {
       
        txtSearch.delegate = self
        
        txtSearch.transform.scaledBy(x: 1, y: 1)
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .allowAnimatedContent) { [self] in
            txtSearch.backgroundColor = AppColor.Orange.withAlphaComponent(0.10)
            viewSearch.isHidden = false
            txtSearch.setCornerRadius(10)
            txtSearch.setBlankView(10, .Left)
            txtSearch.placeholder = "Search"
            txtSearch.isHidden = false
        }
    }
    
    @IBAction private func onBtnClose(_ sender: UIButton) {
        
        if !viewModel.searchText.isEmptyOrWhiteSpace {
            txtSearch.text = ""
            viewModel.searchText = ""
        } else {
                view.endEditing(true)
                viewSearch.isHidden = true
        }
    }
    
    @IBAction func clickBtnLike(_ sender: Any) {
        
        guard viewModel.userdata.count != 0 else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        if viewModel.userdata[0].requestSent == 1 {
            let alert = UIAlertController(title: AppName, message: "Accept request with", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Send a message", style: .default, handler: { _ in
                alert.dismiss(animated: true)
                self.getMessages()
            }))
            
            alert.addAction(UIAlertAction(title: "Go to match screen", style: .default, handler: { _ in
                alert.dismiss(animated: true)
                self.likeUser(nil, nil)
                let tab = (self.parent as? TabBarVC)
                tab?.changeSelectedTab(at: 2)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    (tab?.viewModel.selectedVC as? ChatSegmentVC)?.segmentedPager.showPage(at: 2, animated: true)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: AppName, message: "Would you like to add comment?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Add Comment", style: .default, handler: { _ in
                alert.dismiss(animated: true)
                self.addCommentAlert()
            }))
            
            alert.addAction(UIAlertAction(title: "Like Only", style: .default, handler: { _ in
                alert.dismiss(animated: true)
                self.likeUser(nil, nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                alert.dismiss(animated: true)
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func getMessages() {
        viewModel.getDefaultMessages { isSuccess in
            if !isSuccess.isEmpty {
                let alert = UIAlertController(title: AppName, message: "Please choose message or type a message", preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "Enter message."
                }
                alert.addAction(UIAlertAction(title: "Send Message", style: .destructive, handler: { _ in
                    if alert.textFields?.first?.text?.trimmed().isEmpty ?? true {
                        self.getMessages()
                    } else {
                        let msg = alert.textFields?.first?.text ?? ""
                        self.sendMessageAndChat(msg)
                    }
                }))
                
                for message in isSuccess {
                    alert.addAction(UIAlertAction(title: message, style: .default, handler: { _ in
                        self.sendMessageAndChat(message)
                    }))
                }
           
                self.present(alert, animated: true, completion: nil)
            } else {
                self.alertWith(message: self.viewModel.errorMessage)
            }
        }
    }
    
    func sendMessageAndChat(_ text: String) {
        self.likeUser(nil, text)
        let tab = (self.parent as? TabBarVC)
        tab?.changeSelectedTab(at: 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let chatSeg = (tab?.viewModel.selectedVC as? ChatSegmentVC)
            chatSeg?.segmentedPager.showPage(at: 2, animated: true)
            let vc = UIStoryboard.instantiateVC(ChatVC.self,.Home)
            
            vc.conversationData = ChatListModel(dict: ["message_status" : "1" ,"message": text,"name": self.viewModel.userdata[0].name, "user_id": self.viewModel.userdata[0].userId, "time": ServerValue.timestamp(), "device_type": "iOS","device_token":  ""])
            chatSeg?.show(vc, sender: nil)
        }
        
    }
    
    func addCommentAlert() {
        presentCommentView(from: self) { comment in
            self.likeUser(comment, nil)
        }

    }
    
    func likeUser(_ comment: String?, _ message: String?) {
        
        
        viewModel.likeType = viewModel.userdata[0].isLike == "1" ? "2" : "1"
        viewModel.likeUserId = viewModel.userdata[0].userId
        
        guard viewModel.validation() else {
            self.errorAlert(message: self.viewModel.errorMessage)
            return
        }
        
        viewModel.profileLikeDislike(comment, message) { (isSuccess,status) in
            
            if isSuccess {
                self.btnLike.tintColor = self.viewModel.userdata[0].isLike == "1" ? .white : .red
                self.apiCalling()
                //                self.alertWith(message: self.viewModel.errorMessage)
            }else if status == 2
            {
                self.confirmationPopup()
            }
                        else {
                self.alertWith(message: self.viewModel.errorMessage)
            }
        }
    }
    
    
    func confirmationPopup()  {
        self.AskConfirmation(title: "", message: self.viewModel.errorMessage) { (result) in
                if result { //User has clicked on Ok
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC
                    else { return}
                  
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
    }
    
    @IBAction func clickBtnClose(_ sender: Any) {
    
        guard viewModel.userdata.count != 0 else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        
        btnLike.tintColor = .white
        
        viewModel.likeType = "2"
        viewModel.likeUserId = viewModel.userdata[0].userId
        
        guard viewModel.validation() else {
            self.errorAlert(message: self.viewModel.errorMessage)
            return
        }
        
        viewModel.profileLikeDislike(nil, nil) { (isSuccess,status) in
            
            if isSuccess {
                self.apiCalling()
//                self.alertWith(message: self.viewModel.errorMessage)
            } else if status == 2 {
                self.confirmationPopup()
            }else {
                    self.alertWith(message: self.viewModel.errorMessage)
            }
        }
    }
    
    @IBAction func clickBtnEye(_ sender: Any) {
        
        guard viewModel.userdata.count != 0 else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        
        let vc = UIStoryboard.instantiateVC(PlugspaceRankVC.self, .Home)
        vc.viewModel.friendUserId = viewModel.userdata[0].userId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickBtnMusicChoice(_ sender: Any) {
        guard viewModel.userdata.count != 0 else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        let vc = UIStoryboard.instantiateVC(FavouriteVC.self, .Home)
        vc.viewModel.userID = viewModel.userdata[0].userId
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickBtnReport(_ sender: Any) {
        
        moreBtnAction { tapped in
            switch tapped {
            case "Save":
                print("User click Save button")
               self.saveProfile()
            case "Report":
                print("User click Report button")
                self.reportUser()
            case "Remove":
                print("User click Remove button")
                self.block_Profile()
            default:
                print("User click Cancel button")
            }
        }
    }
    
    func saveProfile()  {
        guard viewModel.userdata.count != 0 else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        let otherUserId = viewModel.userdata[0].userId
        viewModel.saveProfile(otherUserId) { [self] isSuccess  in
            if isSuccess {
                self.apiCalling()
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.showToast(message: StringConstant.profileSavedSuceess, y: self.view.Getheight - 100, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
            }else {
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: viewModel.errorMessage)
            }
        }
        
        
    }
    
    
    func block_Profile()  {
        guard viewModel.userdata.count != 0 else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        let otherUserId = viewModel.userdata[0].userId
        viewModel.blockUserProfile(otherUserId) { [self] isSuccess in
            if isSuccess {
                self.apiCalling()
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.showToast(message: StringConstant.profileRemovedSuceess, y: self.view.Getheight - 100, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
            } else {
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: viewModel.errorMessage)
            }
        }
        
        
    }
    
    
    func reportUser()
    {
        guard viewModel.userdata.count != 0 else {
            alertWith(message: viewModel.errorMessage)
            return
        }
        
        ReportViewPopUP = UIView.getView(viewT: ReportView.self)
        
        ReportViewPopUP.extraId = viewModel.userdata[0].mediaDetail[0].media_id
        ReportViewPopUP.type = "profile"
        ReportViewPopUP.friendId = viewModel.userdata[0].userId
        openXIB(XIB: ReportViewPopUP)
    }
    
    
    func moreBtnAction(completion : @escaping (_ userTapped: String) -> Void) {
        let alert = UIAlertController(title: "Plugspace", message: "", preferredStyle: .actionSheet)
         alert.addAction(UIAlertAction(title: "Save", style: .default , handler:{ (UIAlertAction)in
             completion("Save")
         }))
         alert.addAction(UIAlertAction(title: "Report", style: .default , handler:{ (UIAlertAction)in
             completion("Report")
         }))
         alert.addAction(UIAlertAction(title: "Remove", style: .default , handler:{ (UIAlertAction)in
          completion("Remove")
             
         }))
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in }))
         alert.view.tintColor = #colorLiteral(red: 0.9647058824, green: 0.3803921569, blue: 0.1607843137, alpha: 1)
         self.present(alert, animated: true, completion: {})
        }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == storyCollectionView {
            return viewModel.storyData.count
            
        } else {
            return viewModel.basicInfoArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == storyCollectionView {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionCell", for: indexPath) as! StoryCollectionCell
            cell.setData(data: viewModel.getStoryDetails(IndexPath: indexPath))
        return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicInfoCell", for: indexPath) as! BasicInfoCell
            cell.setData(img: viewModel.iconImgArr[indexPath.row], details: viewModel.basicInfoArr[indexPath.row])
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if collectionView == storyCollectionView {
            return CGSize(width: 70, height: 105)
        } else {
            
            if indexPath.row < 3 {
                let width = (collectionView.frame.size.width - 20) / 3
             
                return CGSize(width: width, height: 44)
            } else if indexPath.row <= 4 {
                let width = (collectionView.frame.size.width - 16) / 2
              
                return CGSize(width: width, height: 44)
                
            } else {
                let width = (collectionView.frame.size.width - 30) / 4
               
                return CGSize(width: width, height: 44)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == storyCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
            vc.pages = viewModel.storyData
             vc.currentIndex = indexPath.row
           // vc.viewModel.userStoryDetails = viewModel.storyData
            self.navigationController?.pushViewController(vc, animated: true)
        
         
        
        
//                let vc = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
//                vc.viewModel.userStoryDetails = viewModel.storyData
//                vc.viewModel.indexUser = indexPath
//                self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}






extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.userdata[0].mediaDetail.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostCell") as! UserPostCell
        cell.setdata(data: viewModel.getMediaDetails(indexPath: indexPath))
        cell.btnReport.addTarget(self, action: #selector(clickMoreBtn(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func clickMoreBtn(_ sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        ReportViewPopUP = UIView.getView(viewT: ReportView.self)
        
        ReportViewPopUP.extraId = viewModel.userdata[0].mediaDetail[indexPath!.row].media_id
        ReportViewPopUP.type = "feed"
        ReportViewPopUP.friendId = viewModel.userdata[0].userId
        openXIB(XIB: ReportViewPopUP)
    }
}

//MARK:- UITextfield

extension HomeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            return false
        }
        
        let text = (txtSearch.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.searchText = text
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        viewModel.searchText = txtSearch.text!
        
        guard viewModel.searchText.count != 0 else {
//            alertWith(message: viewModel.errorMessage)
            return
        }
        self.apiCalling()
    }
}
extension UIViewController {

func AskConfirmation (title:String, message:String, completion:@escaping (_ result:Bool) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    

    alert.addAction(UIAlertAction(title: "Subscribe now", style: .default, handler: { action in
        completion(true)
    }))

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        completion(false)
    }))
    alert.view.tintColor = AppColor.Orange
    self.present(alert, animated: true, completion: nil)
  }
}
