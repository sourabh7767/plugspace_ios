//
//  VideoPlayer.swift
//  PlugSpace
//
//  Created by MAC on 02/02/22.
//

import Foundation
import AVKit
import UIKit

class VideoPlayer: NSObject {
    
    //MARK:- Properties

    static let shared = VideoPlayer()
    private var player: AVPlayer!
    let avPlayerController = AVPlayerViewController()
    
    //MARK:- Method
    
    func showVideo(videoURL:URL,width:CGFloat, height: CGFloat,videoView:UIView) {
        player = AVPlayer(url: videoURL)
        
        avPlayerController.player = player
        
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width:width, height: height)
        avPlayerController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayerController.showsPlaybackControls = false
        
        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.addChild(avPlayerController)
        
        videoView.addSubview(avPlayerController.view)
        
        avPlayerController.player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @objc func playerDidFinishPlaying(_ note: NSNotification) {
        print("Video Finished")
//        isDevelopmentMode ? false :
        if let playerItem = note.object as? AVPlayerItem {
               playerItem.seek(to: CMTime.zero, completionHandler: nil)
                playVideo()
           }
    }
    
    func playVideo() {
        player.play()
    }
    
    func pauseVideo() {
        guard player != nil else {
            return
        } 
        player.pause()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
