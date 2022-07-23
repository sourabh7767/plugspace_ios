//
//  PreViewController.swift
//  ARStories
//
//  Created by Antony Raphel on 05/10/17.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia
import SDWebImage

class PreViewController: UIViewController, SegmentedProgressBarDelegate {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    var viewModel = StoryVM()
    var pageIndex : Int = 0
  
    @IBOutlet weak var viewSrotyOwnerInfo: UIView!
    
    @IBOutlet private weak var lblTime: UILabel!
    @IBOutlet private weak var lblStoryCount: UILabel!
    
    @IBOutlet private weak var viewStoryView: UIView!
    
    var item = [StoryDetails]() //Too show story
    var items = [StoryDetailsModel]()
    var SPB: SegmentedProgressBar!
    var player: AVPlayer!
    let loader = ImageLoader()
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    private var ReportViewPopUP = UIView.getView(viewT: ReportView.self)
    
    
    @IBOutlet private weak var CommentView: UIView!
    
    @IBOutlet private weak var txtComment: UITextField!
    @IBOutlet private weak var txtCommentBottom: NSLayoutConstraint!
    
    @IBOutlet private weak var btnSend: UIButton!
    @IBOutlet private weak var btnDelete: UIButton!
    
    
    @IBOutlet weak var VuewStack: UIStackView!
    @IBOutlet weak var viewForward: UIView!
    @IBOutlet weak var viewBack: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SetupUI()
        callStoryViewDetailsAPI(userid: userId.userId)
    }
   
    func callStoryViewDetailsAPI(userid:String)  {
        viewModel.viewUserID = userid
        viewModel.getMyViewStory { (isSuccess) in
            
            if isSuccess {
                
            } else {
                
            }
        }
    }
    func SetupUI()
    {
        if items[pageIndex].userId != userId.userId
        {
        callStoryViewDetailsAPI(userid: items[pageIndex].userId)
        }
        CommentView.setCornerRadius(10)
        CommentView.layer.borderWidth = 2
        CommentView.layer.borderColor = UIColor.white.cgColor
        txtComment.delegate = self
       
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        userProfileImage.sd_setImage(with: URL(string: items[pageIndex].profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        lblUserName.text = items[pageIndex].userId == userId.userId ? "Your Story" : items[pageIndex].name
       
        item = items[pageIndex].storyMediaDetail
      //  item?.storyMediaDetail.first?.media
        lblStoryCount.text =  "\(items[pageIndex].story_view_count)"
        
        
        
      //  viewModel.userStoryDetails[viewModel.indexUser.row].userId == userId.userId ? callStoryViewDetailsAPI() : btnDelete.setImage(UIImage(named: "ic_report"), for: .normal)
        
        CommentView.isHidden =  items[pageIndex].userId == userId.userId ? true : false
        viewStoryView.isHidden = items[pageIndex].userId == userId.userId ? false : true
        
    }
    
    private func registerNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: { [self] in
                view.layoutIfNeeded()
                txtCommentBottom.constant = hasTopNotch ? (keyboardHeight - 28) : keyboardHeight
            }) { (completed) in
//                 self.scrollToBottom()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        txtCommentBottom.constant = hasTopNotch ? 0 : 8
    }
    
    
    func setupPreview()
    {
        SPB = SegmentedProgressBar(numberOfSegments: item.count, duration: 5)
        if #available(iOS 11.0, *) {
         
            SPB.frame = CGRect(x: 18, y: 35, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 2
        SPB.isPaused = true
        SPB.currentAnimationIndex = 0
       // SPB.duration = getDuration(at: 0)
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        viewForward.addGestureRecognizer(tapGestureImage)
        
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureVideo.numberOfTapsRequired = 1
        tapGestureVideo.numberOfTouchesRequired = 1
        viewForward.addGestureRecognizer(tapGestureVideo)
        
        let RewindTapGestureImage = UITapGestureRecognizer(target: self, action: #selector(rewind(_:)))
        RewindTapGestureImage.numberOfTapsRequired = 1
        RewindTapGestureImage.numberOfTouchesRequired = 1
        viewBack.addGestureRecognizer(RewindTapGestureImage)
        
        let RewindTapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(rewind(_:)))
        RewindTapGestureVideo.numberOfTapsRequired = 1
        RewindTapGestureVideo.numberOfTouchesRequired = 1
        viewBack.addGestureRecognizer(RewindTapGestureVideo)
        
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        setupPreview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.SPB.startAnimation()
         self.playVideoOrLoadImage(index: 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.SPB.currentAnimationIndex = 0
            self.SPB.cancel()
            self.SPB.isPaused = true
            self.resetPlayer()
            //self.SPB.removeFromSuperview()
        }
    }
  
    
   
    
    @IBAction func clickBtnStoryView(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoryViewVC") as! StoryViewVC
        vc.viewModel.viewStoryCount = "\(items[pageIndex].story_view_count)"
        vc.viewModel.storyViewDetailsArr = viewModel.storyViewDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clickBtnSend(_ sender: Any) {
        
        viewModel.friendId = items[pageIndex].userId
        viewModel.userComment = txtComment.text!
        
        guard viewModel.validation() else {
            // alertWith(message: viewModel.errorMessage)
            return
        }
        view.endEditing(true)
        viewModel.storyComment { [self] (isSuccess) in
            
            if isSuccess {
                txtComment.text! = ""
                showToast(message: viewModel.errorMessage, y: view.center.y, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
            } else {
                txtComment.text! = ""
                // alertWith(message: viewModel.errorMessage)
            }
        }
    }
/*
    @IBAction func clickBtnStoryAction(_ sender: Any) {
        removeNotificationObservers()
        viewModel.userStoryDetails[viewModel.indexUser.row].userId == userId.userId ? callDeleteStoryAPI() : callReportAPI()
    }
    
    func callDeleteStoryAPI() {
        
        let alert = UIAlertController(title: AppName, message: StringConstant.DeleteStory, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { [self] action in
            viewModel.deleteStory { [self] (isSuccess) in
                
                if isSuccess {
                    getStoryApiCall()
                } else {
                    
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func callReportAPI() {
        
        ReportViewPopUP = UIView.getView(viewT: ReportView.self)
        ReportViewPopUP.extraId = viewModel.storyMediaId
        ReportViewPopUP.type = "story"
        ReportViewPopUP.friendId = viewModel.userStoryDetails[viewModel.indexUser.row].userId
        openXIB(XIB: ReportViewPopUP)
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - SegmentedProgressBarDelegate
    //1
    func segmentedProgressBarChangedIndex(index: Int) {
       // lblTime.text = viewModel.userStoryData[0].storyMediaDetail[index].dateTime
       
        
     playVideoOrLoadImage(index: index)
    }
    
    //2
    func segmentedProgressBarFinished() {
        ContentViewControllerVC.ShowLoader()
        print("segmentedProgressBarFinished")
        if pageIndex == (items.count - 1) {
            close(UIButton())
        }
        else {
            print("segmentedProgressBarFinished959")
            ContentViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        print("next")
        SPB.skip()
    }
   
    @objc func rewind(_ sender: UITapGestureRecognizer) {
        print("back")
       // print("SPB.currentAnimationIndex",SPB.currentAnimationIndex)
      //  print("pageIndex",pageIndex)
        SPB.rewind()
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
        
        ContentViewControllerVC.ShowLoader()
        if item[index].mediaType == "image" {
           
            self.SPB.duration = 5
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
          //  self.imagePreview.sd_setImage(with: URL(string: item[index].media), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
            self.imagePreview.sd_setImage(with: URL(string: item[index].media), placeholderImage: UIImage(named: "home_1"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                 // your rest code
                
                ContentViewControllerVC.HideLoader()
            })
        } else {
            self.imagePreview.isHidden = true
            self.videoView.isHidden = false
            
            resetPlayer()
            guard let url = NSURL(string: item[index].media) as URL? else {return}
            self.player = AVPlayer(url: url)
           player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)

            let videoLayer = AVPlayerLayer(player: self.player)
            videoLayer.frame = view.bounds
            videoLayer.videoGravity = .resizeAspect
            self.videoView.layer.addSublayer(videoLayer)
            
            let asset = AVAsset(url: url)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            
            self.SPB.duration = durationTime
            self.player.play()
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        ContentViewControllerVC.HideLoader()
                    } else {
                        ContentViewControllerVC.ShowLoader()
                    }
                }
            }
        }
    }
    // MARK: Private func
    private func getDuration(at index: Int) -> TimeInterval {
        var retVal: TimeInterval = 5.0
        if item[index].mediaType == "image" {
            retVal = 5.0
        } else {
            guard let url = NSURL(string: item[index].media) as URL? else { return retVal }
            let asset = AVAsset(url: url)
            let duration = asset.duration
            retVal = CMTimeGetSeconds(duration)
        }
        return retVal
    }
    
    private func resetPlayer() {
        if player != nil {
            player.pause()
            player.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    //MARK: - Button actions
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        resetPlayer()
    }
}
//MARK:- TextFiled Delegate

extension PreViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtComment {
            registerNotificationObservers()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        btnSend.isHidden = string != "" ? false : true
        
        return true
    }
}
extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
