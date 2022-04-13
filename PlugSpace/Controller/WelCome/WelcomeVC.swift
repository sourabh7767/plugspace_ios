//
//  WelcomeVC.swift
//  PlugSpace
//
//  Created by MAC on 13/11/21.
//

import UIKit
import AVKit

class WelcomeVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var btnSignup: UIButton!
    @IBOutlet private weak var videoView: UIView!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let path = Bundle.main.path(forResource: "PlugspaceWelcome", ofType:"mp4") else {
            debugPrint("PlugspaceWelcome.mp4 not found")
            return
        }
       VideoPlayer.shared.showVideo(videoURL: URL(fileURLWithPath: path), width: self.videoView.Getwidth, height: self.videoView.Getheight, videoView: videoView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        VideoPlayer.shared.pauseVideo()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        btnLogin.cornerRadius = 10
        btnSignup.cornerRadius = 10
        btnSignup.setBorder(1, #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    // MARK: - IBAction
    @IBAction private func onBtnLogin(_ sender: UIButton) {
     
        AppDelegate.shared.goToLoginVc()
        AppPrefsManager.shared.setIsVideoShow(isShowVideo: true)
    }
    
    @IBAction private func onBtnSignup(_ sender: UIButton) {
        
        AppPrefsManager.shared.setIsVideoShow(isShowVideo: true)
        let vc = UIStoryboard.instantiateVC(SignUpVC.self)
        vc.fromWelcome = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
