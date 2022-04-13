//
//  StoryVC.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit
import AVKit

class StoryVC: BaseVC, SegmentedProgressBarDelegate {
    
    //MARK:- Outlet
    
    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var imgStory: UIImageView!
    
    @IBOutlet private weak var lblStoryTitle: UILabel!
    @IBOutlet private weak var lblTime: UILabel!
    @IBOutlet private weak var lblStoryCount: UILabel!
    
    @IBOutlet private weak var viewStoryView: UIView!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var bgBackView: UIView!
    @IBOutlet private weak var CommentView: UIView!
    
    @IBOutlet private weak var txtComment: UITextField!
    @IBOutlet private weak var txtCommentBottom: NSLayoutConstraint!
    
    @IBOutlet private weak var btnSend: UIButton!
    @IBOutlet private weak var btnDelete: UIButton!
    
    //MARK:- Properties
    
    var viewModel = StoryVM()
    private var player: AVPlayer!
    let avPlayerController = AVPlayerViewController()
    let userId = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    private var ReportViewPopUP = UIView.getView(viewT: ReportView.self)

    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        getStoryApiCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotificationObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpScreen() {
        
        CommentView.setCornerRadius(10)
        CommentView.layer.borderWidth = 2
        CommentView.layer.borderColor = UIColor.white.cgColor
        
        imgProfile.sd_setImage(with: URL(string: viewModel.userStoryDetails[viewModel.indexUser.row].profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        lblStoryTitle.text = viewModel.userStoryDetails[viewModel.indexUser.row].userId == userId.userId ? "Your Story" : viewModel.userStoryDetails[viewModel.indexUser.row].name
        
        viewModel.userStoryDetails[viewModel.indexUser.row].userId == userId.userId ? callStoryViewDetailsAPI() : btnDelete.setImage(UIImage(named: "ic_report"), for: .normal)
        
        CommentView.isHidden =  viewModel.userStoryDetails[viewModel.indexUser.row].userId == userId.userId ? true : false
        viewStoryView.isHidden = viewModel.userStoryDetails[viewModel.indexUser.row].userId == userId.userId ? false : true
        
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(tappedView)))
        
        txtComment.delegate = self
        
        let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUpGesture(_:)))
        swipeGestureRecognizerUp.direction = .up
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDownGesture(_:)))
        swipeGestureRecognizerDown.direction = .down
        
        self.view.addGestureRecognizer(swipeGestureRecognizerUp)
        self.view.addGestureRecognizer(swipeGestureRecognizerDown)
        
        setAfter { [self] in
            imgProfile.setCornerRadius(imgProfile.frame.height / 2)
            txtComment.setBlankView(20, .Left)
        }
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
    
    func setupVideoPlayer(videoURL:String) {
        imgStory.isHidden = false
        videoView.isHidden = true
        player = AVPlayer(url: URL(string:videoURL)!)
        avPlayerController.player = player
        
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width:self.videoView.Getwidth, height: self.videoView.Getheight)
        avPlayerController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayerController.showsPlaybackControls = false
        
        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.addChild(avPlayerController)
        
        self.videoView.addSubview(avPlayerController.view)
        
        avPlayerController.player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        IndicatorManager.hideLoader()
        imgStory.isHidden = true
        videoView.isHidden = false
    }
    
    @objc func playerDidFinishPlaying(_ note: NSNotification) {
        print("Video Finished")
        nextStoryShow()
    }
    
    //MARk:- Api Calling
    
    func callStoryViewDetailsAPI() {
        
        viewModel.getMyViewStory { (isSuccess) in
            
            if isSuccess {
                
            } else {
                
            }
        }
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
    
    func    getStoryApiCall() {
        
        viewModel.viewUserID = viewModel.userStoryDetails[viewModel.indexUser.row].userId
        
        viewModel.getStoryDetails { [self] (isSuccess) in
            
            if isSuccess {
                
                viewModel.userStoryDetails[viewModel.indexUser.row].userId != userId.userId ? setData() : nil
                
                guard viewModel.userStoryData.count != 0 else {
                    backVC()
                    return
                }
                
                lblStoryCount.text = String(viewModel.userStoryData[0].count)
                segmentedProgressBarChangedIndex(index: 0)
                viewModel.storySegmentBar = SegmentedProgressBar(numberOfSegments: viewModel.userStoryData[0].storyMediaDetail.count)
                viewModel.storySegmentBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                viewModel.storySegmentBar.delegate = self
                viewModel.storySegmentBar.topColor = UIColor.white
                viewModel.storySegmentBar.bottomColor = UIColor.white.withAlphaComponent(0.25)
                viewModel.storySegmentBar.padding = 2
                view.addSubview(viewModel.storySegmentBar)
                viewModel.storySegmentBar.startAnimation()
            }
        }
    }
    
    func setData() {
        
        imgProfile.sd_setImage(with: URL(string: viewModel.userStoryDetails[viewModel.indexUser.row].profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        lblStoryTitle.text =  viewModel.userStoryDetails[viewModel.indexUser.row].name
    }
    
    func segmentedProgressBarChangedIndex(index: Int) {
        
        player != nil ?  player.pause() : nil
        player = player != nil ? nil : player
        
        print("Now showing index: \(index)")
        
        guard viewModel.userStoryData[0].storyMediaDetail.count != 0 else {
            return
        }
        
        lblTime.text = viewModel.userStoryData[0].storyMediaDetail[index].dateTime
        
        if viewModel.userStoryData[0].storyMediaDetail[index].mediaType == "image" {
            videoView.isHidden = true
            imgStory.isHidden = false
            
            imgStory.sd_setImage(with: URL(string: viewModel.userStoryData[0].storyMediaDetail[index].media), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        } else {
            IndicatorManager.showLoader()
            imgProfile.image = getThumnailImage(videoURL: viewModel.userStoryData[0].storyMediaDetail[index].media)
            setupVideoPlayer(videoURL:viewModel.userStoryData[0].storyMediaDetail[index].media)
        }
        viewModel.storyId =  viewModel.userStoryData[0].storyMediaDetail[index].storyId
        viewModel.storyMediaId =  viewModel.userStoryData[0].storyMediaDetail[index].storyMediaId
        
        viewModel.isFirstStory = index == 0 ?  true : false
            
        viewModel.isLastStory = index == viewModel.userStoryData[0].storyMediaDetail.count - 1 ? true : false
    }
    
    func nextStoryShow() {
        if viewModel.isLastStory {
            
            guard viewModel.indexUser.row != viewModel.userStoryDetails.count - 1 && viewModel.userStoryDetails[viewModel.indexUser.row].userId != userId.userId else {
                backVC()
                return
            }
            
            viewModel.indexUser.row = viewModel.indexUser.row + 1
            getStoryApiCall()
        } else {
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp, animations: { [self] in
                imgStory.frame = CGRect(x: 0, y: -imgStory.frame.height, width: imgStory.frame.width, height: imgStory.frame.height)
            })
            
            viewModel.storySegmentBar.skip()
        }
    }
    
    @objc func swipeUpGesture(_ sender: UISwipeGestureRecognizer? = nil) {
        nextStoryShow()
    }
    
    @objc func swipeDownGesture(_ sender: UISwipeGestureRecognizer? = nil) {
        
        if viewModel.isFirstStory {
            
            guard viewModel.indexUser.row != viewModel.userStoryDetails.startIndex && viewModel.userStoryDetails[viewModel.indexUser.row].userId != userId.userId else {
                backVC()
                return
            }
            viewModel.indexUser.row = viewModel.indexUser.row - 1
            getStoryApiCall()
            
        } else {
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp, animations: { [self] in
                imgStory.frame = CGRect(x: 0, y: +imgStory.frame.height, width: imgStory.frame.width, height: imgStory.frame.height)
            })
            viewModel.storySegmentBar.rewind()
        }
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
    
    func segmentedProgressBarFinished() {
        viewModel.isLastStory = true
    }
    
    @objc private func tappedView(_ sender: UIPinchGestureRecognizer? = nil) {
        viewModel.storySegmentBar.isPaused = !viewModel.storySegmentBar.isPaused
    }
    
    //MARK:- Action
    
    @IBAction func clickBtnBack(_ sender: Any) {
        backVC()
    }
    
    @IBAction func clickBtnStoryAction(_ sender: Any) {
        removeNotificationObservers()
        viewModel.userStoryDetails[viewModel.indexUser.row].userId == userId.userId ? callDeleteStoryAPI() : callReportAPI()
    }
    
    @IBAction func clickBtnSend(_ sender: Any) {
        
        viewModel.friendId = viewModel.userStoryDetails[viewModel.indexUser.row].userId
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
    
    @IBAction func clickBtnStoryView(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoryViewVC") as! StoryViewVC
        vc.viewModel.viewStoryCount = String(viewModel.userStoryData[0].count)
        vc.viewModel.storyViewDetailsArr = viewModel.storyViewDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- TextFiled Delegate

extension StoryVC: UITextFieldDelegate {
    
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
