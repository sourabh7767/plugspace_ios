//
//  SelectImageVC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit
import AVKit
import SVProgressHUD
class SelectImageVC: UIView {
    
    //MARK:- Outlets
    
    @IBOutlet weak var viewStory: UIView!
    @IBOutlet weak var viewFeed: UIView!
    @IBOutlet weak var imgClick: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var viewStoryAndFeed: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    //MARK:- Properties
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    var clickImage:UIImage?
    let viewModel = SelectedImageVM()
    var videoURL: URL!
    private var player: AVPlayer!
    private var avPController: AVPlayerViewController!
    
    //MARK:-
    override func awakeFromNib() {
        
        setAfter { [self] in
            viewFeed.setCornerRadius(10)
            viewStory.setCornerRadius(10)
        }
    }
    
    //MARK:- Method
    
    func setData()  {
        guard clickImage != nil else {
            return
        }
        imgClick.image = clickImage
    }
    
    func setupVideoPlayer() {
        player = AVPlayer(url: videoURL)
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = player
        
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width:self.videoView.Getwidth, height: self.videoView.Getheight)
        avPlayerController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayerController.showsPlaybackControls = false
        
        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.addChild(avPlayerController)
        
        self.videoView.addSubview(avPlayerController.view)
        
        avPlayerController.player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @objc func playerDidFinishPlaying(_ note: NSNotification) {
        print("Video Finished")
        player.play()
    }
    
    //MARK:- IBAction
    
    @IBAction func btnActionStory(_ sender: UIButton) {
        
        viewStoryAndFeed.isHidden = true
        
        activityIndicator.center = CGPoint(x: btnBack.bounds.size.width/2, y: btnBack.bounds.size.height/2)
        activityIndicator.color = AppColor.Orange
        btnBack.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        player != nil ?  self.stopVideo() : nil
        setMsgWithSVProgress("Uploading...")
        viewModel.createStory { [self] (isSuccess) in
            
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                    self.activityIndicator.stopAnimating()
                }
                closeXIB(XIB: self)
//                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: StringConstant.uploadImageFeed)
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.first?.showToast(message: StringConstant.uploadImageFeed, y: 0, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
                appdelegate.goToHomeVc()
            } else {
                viewStoryAndFeed.isHidden = false
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: self.viewModel.errorMessage)
            }
        }
    }
    
    @IBAction func btnActionFeed(_ sender: UIButton) {
       
        player != nil ?  self.stopVideo() : nil
        
        let vc = UIStoryboard.instantiateVC(AddDescriptionVC.self, .Home)
      //  vc.feedImage = clickImage != nil ? clickImage!.jpegData(compressionQuality: 0.5)! : viewModel.storyVideo
    
        if clickImage != nil
        {
            vc.feedImage = clickImage!.jpegData(compressionQuality: 0.5)!
        }
        else
        {
            guard let videoAsFeed = viewModel.storyVideo.first else { return  }
            vc.feedImage = videoAsFeed
        }
        
        
        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnActionClose(_ sender: UIButton) {
        closeXIB(XIB: self)
       
        guard player != nil else {
            return
        }
        
        self.stopVideo()
    }
    
    func stopVideo() {
        player.pause()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
