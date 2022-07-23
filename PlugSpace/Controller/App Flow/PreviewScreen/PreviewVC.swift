//
//  PreviewVC.swift
//  PlugSpace
//
//  Created by MAC on 24/11/21.
//

import UIKit
import DKImagePickerController

class PreviewVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet private weak var imgUserProfile: UIImageView!

    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblUserEducation: UILabel!
    @IBOutlet private weak var lblUserWork: UILabel!
    @IBOutlet private weak var lblAboutMe: UILabel!
    @IBOutlet private weak var lblUserlocation: UILabel!
    @IBOutlet private weak var lblRankScore: UILabel!
    @IBOutlet private weak var lblSelfMan: UILabel!
    @IBOutlet private weak var lblScreenTitle: UILabel!
    
    @IBOutlet private weak var basicInfoCollectionView: UICollectionView!
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private  var infoViewView: [UIView]!
    @IBOutlet private weak var imgUserProfileView: UIView!
    @IBOutlet private weak var imgbgView: UIView!
    
    //MARK:- Propties
    
    var viewModel = PreviewVM()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        setImageController()
        previewUpdateProCallApi()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        basicInfoCollectionView.layer.removeAllAnimations()
        collectionViewHeight.constant = basicInfoCollectionView.contentSize.height
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
        
        lblScreenTitle.text = viewModel.userId != "" ?  "Profile": lblScreenTitle.text
        
        infoViewView.setBorder(0.2, AppColor.Orange, 10)
        infoViewView.setShadow(3.0, 0.0, 2.0, AppColor.Orange, 0.2)
    
        basicInfoCollectionView.registerNib(UserBasicInfoCell.self)
        
        tableView.registerNib(UserPreviewPostCell.self)
        imgUserProfile.setCornerRadius(10)
        imgUserProfileView.setCornerRadius(10)
    
    }
    
    private func noFeedFound()  {
        removeNewNoDataViewFrom(containerView: tableView)
        if viewModel.postArr.count == 0 {
            setNoDataFoundView(containerView: tableView, text:"No feed Found!")
        }
    }
    
    func setdata() {
        
        viewModel.basicInfoArr.removeAll()
        
        if viewModel.userDataPreView.mediaDetail.count != 0 {
            imgUserProfile.sd_setImage(with: URL(string: viewModel.userDataPreView.mediaDetail[0].profile), placeholderImage: UIImage(named: "ic_user"), options: .retryFailed)
        }
        
        lblUserName.text = viewModel.userDataPreView.name + ", \(viewModel.userDataPreView.age)"
        lblUserWork.text = viewModel.userDataPreView.jobTitle
        lblUserEducation.text = viewModel.userDataPreView.educationStatus
        lblUserlocation.text = viewModel.userDataPreView.location != "" ? viewModel.userDataPreView.location : "Enable Location"
        lblRankScore.text = viewModel.userDataPreView.menRank != "" ? viewModel.userDataPreView.menRank : "0"
        lblSelfMan.text = viewModel.userDataPreView.mySelfMan
        lblAboutMe.text = viewModel.userDataPreView.aboutYou
        
        viewModel.basicInfoArr.append(viewModel.userDataPreView.height)
        viewModel.basicInfoArr.append(viewModel.userDataPreView.weight)
        viewModel.basicInfoArr.append(viewModel.userDataPreView.children)
        viewModel.basicInfoArr.append(viewModel.userDataPreView.relationshipStatus)
              viewModel.basicInfoArr.append(viewModel.userDataPreView.ethinicity)
              viewModel.basicInfoArr.append(viewModel.userDataPreView.makeOver != "" ? viewModel.userDataPreView.makeOver : "0")
              viewModel.basicInfoArr.append(viewModel.userDataPreView.dressSize)
              viewModel.basicInfoArr.append(viewModel.userDataPreView.timesofEngaged)
              viewModel.basicInfoArr.append(viewModel.userDataPreView.yourBodyTatto)
              
              basicInfoCollectionView.delegate = self
              basicInfoCollectionView.dataSource = self
              
              basicInfoCollectionView.reloadData()
              self.basicInfoCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
              
              for (index,imageData) in viewModel.userDataPreView.mediaDetail.enumerated() {
            
            if imageData.type == "feed" {
                viewModel.postArr.append(index)
                break
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        noFeedFound()
        tableView.reloadData()
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func setUpdateData() {
        viewModel.action == "Delete" ? alertWith(message: StringConstant.DeleteProfileSuccess) : alertWith(message: StringConstant.UpdateProfile)
        
        tableView.reloadData()
    }
    
    func previewUpdateProCallApi() {
        
        viewModel.previewUpdatePro { [self] (isSuccess) in
            noFeedFound()
            if isSuccess {
                
                viewModel.type == "" ? setdata() : setUpdateData()
                
            }else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    func setImageController() {
        
        viewModel.imagePickerController.maxSelectableCount = 1
        viewModel.imagePickerController.sourceType = .both
        viewModel.imagePickerController.showsCancelButton = true
        viewModel.imagePickerController.singleSelect = true
        viewModel.imagePickerController.setEditing(true, animated: true)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font : UIFont(name: AppFont.reguler, size: setCustomFont(18))!,
            NSAttributedString.Key.foregroundColor : AppColor.Orange
        ]
        
        viewModel.imagePickerController.didSelectAssets = { [self] (assets: [DKAsset]) in
            
            for image in assets {
                image.fetchOriginalImage(completeBlock: { (image, _) in
                    if let cell = self.tableView.cellForRow(at: self.viewModel.indexPath) as? UserPreviewPostCell {
                        cell.imgProfile.image = image
                    }
                        let type = self.viewModel.userDataPreView.mediaDetail[self.viewModel.indexPath.row].type
                    if type == "profile"
                    {
                        
                        self.viewModel.profileImg = image!.jpegData(compressionQuality: 0.5)!
                        self.viewModel.MediaId = self.viewModel.userDataPreView.mediaDetail[self.viewModel.indexPath.row].media_id
                    }
                    else
                    {
                      //  self.viewModel.type = self.viewModel.userDataPreView.mediaDetail[self.viewModel.indexPath.row].type
                        self.viewModel.removeMediaId = self.viewModel.userDataPreView.mediaDetail[self.viewModel.indexPath.row].feedId
                        self.viewModel.feedId = self.viewModel.userDataPreView.mediaDetail[self.viewModel.indexPath.row].feedId
                        self.viewModel.feedImage = image!.jpegData(compressionQuality: 0.5)!
                    }
                    self.viewModel.type = type
                   
                    self.viewModel.removeMediaId = ""
                    
                    self.viewModel.isEdit = true
              
                    
                    self.previewUpdateProCallApi()
                })
            }
        }
    }
    let CurrentUserId = SignUpModel.init(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    private func goToFavouriteVC() {
        let vc = UIStoryboard.instantiateVC(FavouriteVC.self, .Home)
        vc.viewModel.userID = viewModel.userId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Action
    
    @IBAction func btnBack(_ sender:UIButton) {
        backVC()
    }
    
    @IBAction func clickBtnMusicChoice(_ sender: Any) {
        
        viewModel.userId == "" ? pushVC(MusicVC.self, storyboard: .Home) : goToFavouriteVC()
       
    }
}


//MARK:- UITableView

extension PreviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.basicInfoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserBasicInfoCell", for: indexPath) as! UserBasicInfoCell
        if viewModel.iconImgArr[indexPath.row] != "0" {
            cell.setdata(img: viewModel.iconImgArr[indexPath.row], title: viewModel.basicInfoArr[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row < 3 {
            let width = (collectionView.frame.size.width - 20) / 3
            return CGSize(width: width, height: 44)
        } else if indexPath.row <= 4 {
            let width = (collectionView.frame.size.width - 16) / 2
            return CGSize(width: width, height: 44)
        } else {
            let width = (collectionView.frame.size.width - 30) / 4
            return CGSize(width: width, height:  44)
        }
    }
}

//MARK:- UITableView

extension PreviewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userDataPreView.mediaDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPreviewPostCell") as! UserPreviewPostCell
        
        let obj = viewModel.getMediaDetails(indexpath: indexPath)
            cell.setData(data: obj)
            cell.btnMore.addTarget(self, action: #selector(clickbtn(_:)), for: .touchUpInside)
            cell.bgBtnView.isHidden = viewModel.userId == "" ? false : true
            cell.delegate = self
            return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let obj = viewModel.getMediaDetails(indexpath: indexPath)
//        if obj.type == "profile" {
//
//            return 0
//        } else {
            return UITableView.automaticDimension
//        }
    }
    
    @objc  func clickbtn(_ sender:UIButton) {
       let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        
        viewModel.indexPath = self.tableView.indexPathForRow(at:buttonPosition)
    }
}

//MARK:- Edit OR Delete Delegate Method

extension PreviewVC : updateProfileDelegate {
    
    func btnEditOrDelete(action: String, image: UIImage, cell: UserPreviewPostCell) {
        
        viewModel.action = action
        if action == "Edit" {
            present(viewModel.imagePickerController, animated: true)
            
        } else if action == "Delete" {
            
            let alert = UIAlertController(title: AppName, message: StringConstant.DeleteProfile, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { [self] action in
                self.viewModel.MediaId = ""
                let type = viewModel.userDataPreView.mediaDetail[viewModel.indexPath.row].type
                if type == "profile"
                {
                    viewModel.removeMediaId = viewModel.userDataPreView.mediaDetail[viewModel.indexPath.row].media_id
                }
                else{
                    viewModel.removeMediaId = viewModel.userDataPreView.mediaDetail[viewModel.indexPath.row].feedId
                }
                viewModel.type = type
                self.viewModel.isEdit = false
                previewUpdateProCallApi()
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
