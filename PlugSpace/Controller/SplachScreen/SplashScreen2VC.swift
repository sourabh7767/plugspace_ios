//
//  SplashScreen2VC.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class SplashScreen2VC: BaseVC {
   
    //MARK:- Outlets
    
    @IBOutlet private weak var imgLogo: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    
    //MARK:- Properties
    
    var viewModel = SignUPVM()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        userSignup()
    }
    
    //********************************************
    //MARK:- Method
    //********************************************
    
    func userSignup() {
        viewModel.SignUp { [self] (isSuccess) in
            if isSuccess {
                setDelay()
            } else {
                backVC()
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    private func setupUI() {
        
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "loader", withExtension: "gif")!), let jeremyGif = UIImage.gifImageWithData(imageData) {
            imgLogo.animationImages = jeremyGif.images
            imgLogo.animationDuration = jeremyGif.duration
            imgLogo.animationRepeatCount = 1
            imgLogo.startAnimating()
            lblTitle.text = "Your \(AppName) score will be ready in 30-60 minutes. In the meantime see people around you."
        }
        
        fadeIn(duration: 10, delay: 0.0) { [self]  isComplete in
            if isComplete {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.imgLogo.stopAnimating()
                }
            }
        }
    }
    
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
        }, completion: completion)
    }
  
    func setDelay() {
            let vc = SuccessPopUpVC()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
    }
}
