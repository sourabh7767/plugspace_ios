//
//  AudioPleyer.swift
//  PlugSpace
//
//  Created by MAC on 04/02/22.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class AudioPlayer: NSObject {
    
    //MARK:- Properties
    
    static let shared = AudioPlayer()
    private var audioPlayer: AVAudioPlayer?
    private var myPlayerItem:AVPlayerItem?
    private var player: AVPlayer!
    let avPlayerController = AVPlayerViewController()
    
    //MARK:- Method
    
    func playAudio(alertSound:String) {
        
        let aSound = NSURL(string: alertSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound! as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print(error.localizedDescription,"Cannot play the file")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.myPlayerItem)
    }
    
    func playMp4Audio(videoURL:URL) {
        player = AVPlayer(url: videoURL)
        
        avPlayerController.player = player
        
        avPlayerController.player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
     @objc func playerDidFinishPlaying(_ noti: Notification) {
        if let playerItem = noti.object as? AVPlayerItem {
               playerItem.seek(to: CMTime.zero, completionHandler: nil)
            playMp4Audio()
           }
    }
    
    func playMp4Audio() {
        player.play()
    }
    
    func pauseMp4Audio() {
        
        guard player != nil else {
            return
        }
        
        player.pause()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func playAudio() {
        audioPlayer?.play()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
    }
}
