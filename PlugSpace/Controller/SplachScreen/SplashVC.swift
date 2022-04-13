//
//  SplashVC.swift
//  Turnstile
//
//  Created by MAC on 21/05/21.
//

import UIKit

class SplashVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imgLogo: UIImageView!
    
    // MARK: - Properties
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
//        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Logo Animation", withExtension: "gif")!), let jeremyGif = UIImage.gifImageWithData(imageData) {
//            imgLogo.animationImages = jeremyGif.images
//            imgLogo.animationDuration = jeremyGif.duration
//            imgLogo.animationRepeatCount = 1
//            imgLogo.startAnimating()
//
//            imgLogo.image = UIImage(named: "ic_SplashLogo")
//
//        } else {
//            imgLogo.image = UIImage(named: "ic_SplashLogo")
//        }

        fadeIn(duration: 2.0, delay: 2.0) { isComplete in
            if isComplete {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                        AppDelegate.shared.goToHomeVc()
            
                }
            }
        }
    }
    
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
//            self.imgTitleLogo.alpha = 1.0
        }, completion: completion)
    }
}
