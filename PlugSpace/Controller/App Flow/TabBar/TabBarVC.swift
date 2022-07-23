//
//  TabBarVC.swift
//  PlugSpace
//
//  Created by MAC on 23/11/21.
//

import UIKit
import DKImagePickerController

class TabBarVC: BaseVC {
    
    //MARK:-   Outlets
    
    @IBOutlet var btnTab: [UIButton]!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var curveTabbarView: UIView!
    @IBOutlet var btnmsgBange: BadgeButton!
    
    //MARK:-   Properties
    
    var viewModel = TabBarVM()
    private var selectImage = UIView.getView(viewT: SelectImageVC.self)
    
    //MARK:-   VC Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectVC(HomeVC.self)
        viewModel.selectedIndex = 0
        viewModel.imagePicker.delegate = self
        setImageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        NotificationCenter.default.addObserver(self, selector: #selector(setMessageBtnToBadge(_:)), name: NSNotification.Name(rawValue: "SetMessageBadgeIcon"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAfter { [self] in
            
            self.curveTabbarView.Set_Corner([.topLeft,.topRight], 30)
            radiusView.cornerRadius = 30
            radiusView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            radiusView.layer.shadowOffset = CGSize.zero
            radiusView.layer.shadowOpacity = 0.3
            radiusView.layer.shadowRadius = 5.0
            radiusView.layer.masksToBounds =  false
        }
    }
    
    //MARK:- Methods
    
    open func selectVC(_ viewcontroller: UIViewController.Type) {
        
        if viewModel.selectedVC != nil {
            let previousVC = viewModel.selectedVC
            previousVC!.willMove(toParent: nil)
            previousVC!.removeFromParent()
            previousVC!.view.removeFromSuperview()
            viewModel.selectedVC = nil
        }
        
        let vc = getVC(viewcontroller)
        addChild(vc)
        
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        setPageControllerConstraint(vc)
        viewModel.selectedVC = vc
//                vc.view.transform = CGAffineTransform(translationX:  vc.view.bounds.width, y:0)
//                UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowAnimatedContent, animations: {() -> Void in
//                    vc.view.transform = CGAffineTransform.identity
//                }, completion: { [self] (_ finished: Bool) -> Void in
//
//                })
    }
    
    @objc func setMessageBtnToBadge(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let badgeShow = dict["isShow"] as? Bool {
                if badgeShow {
                    btnmsgBange.badge = ""
                } else {
                    btnmsgBange.badge = nil
                }
            }
        }
    }
    
    func getVC(_ vc: UIViewController.Type) -> UIViewController {
        return UIStoryboard.instantiateVC(vc, .Home)
    }
    
    func setPageControllerConstraint(_ vc: UIViewController) {
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: vc.view as Any, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: vc.view as Any, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: vc.view as Any, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: vc.view as Any, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    func setImageController() {
        
        viewModel.imagePickerController.maxSelectableCount = 1
        viewModel.imagePickerController.sourceType = .camera
        viewModel.imagePickerController.showsCancelButton = true
        viewModel.imagePickerController.singleSelect = true
        viewModel.imagePickerController.setEditing(true, animated: true)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font : UIFont(name: AppFont.reguler, size: setCustomFont(18))!,
            NSAttributedString.Key.foregroundColor : AppColor.Orange
        ]
        
        viewModel.imagePickerController.didSelectAssets = { [self] (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            for image in assets {
                image.fetchOriginalImage(completeBlock: { (image, _) in
                    self.selectImage = UIView.getView(viewT: SelectImageVC.self)
                    self.selectImage.clickImage  = image
                    self.selectImage.setData()
                    self.selectImage.viewModel.storyImage = image!.jpegData(compressionQuality: 0.5)!
                    openXIB(XIB: self.selectImage)
                })
            }
        }
    }
    
    //MARK:-  IBAction
    
    @IBAction func btnTabbarAction(_ sender: UIButton) {
        changeSelectedTab(at: sender.tag)
    }
    
    func changeSelectedTab(at ind: Int) {
        viewModel.selectedIndex = ind
        selectVC(viewModel.vcIds[ind])
        btnTab.enumerated().forEach { (index, _ ) in
            
            if index == ind {
                btnTab[index].setImage(UIImage(named: viewModel.selectedArr[index]), for: .normal)
            } else {
                btnTab[index].setImage(UIImage(named: viewModel.normalArr[index]), for: .normal)
            }
        }
    }
    
    @IBAction func btnCameraAction(_ sender:UIButton) {
        
        alertWith(AppName, message: nil, type: .actionSheet, cancelTitle: "Cancel", othersTitle: viewModel.title, cancelTap: nil) { [self] (index, _) in
            
            switch index {
            
//            case 0 :
//                present(viewModel.imagePickerController, animated: true)
//                break
            case 0 :
                openAddStroy()
           // openUIImagePickerController(for: viewModel.imagePicker, type: .cameraVideo)
                break
            case 1 :
                openUIImagePickerController(for: viewModel.imagePicker, type: .photoLibrary)
                break
            case 2 :
                openUIImagePickerController(for: viewModel.imagePicker, type: .videoPhotoLibrary)
                break
            default :
                print("okk")
                
            }
        }
    }
}

func openAddStroy()  {
    
    let vc = UIStoryboard.instantiateVC(AddStoryVC.self, .Home)
    (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.navigationController?.pushViewController(vc, animated: true)
}

//MARK:- Image piker

extension TabBarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectImage = UIView.getView(viewT: SelectImageVC.self)
            selectImage.clickImage  = editedImage
            selectImage.setData()
            selectImage.viewModel.storyImage = editedImage.jpegData(compressionQuality: 0.5)!
            openXIB(XIB: selectImage)
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("videourl: ", videoUrl)
            // trying compression of video
            // let data = NSData(contentsOf: videoUrl as URL)!
            // print("File size before compression: \(Double(data.length / 1048576)) mb")
            
            selectImage = UIView.getView(viewT: SelectImageVC.self)
            selectImage.videoURL  = videoUrl
            selectImage.setupVideoPlayer()
            
            do {
                let videoData = try Data(contentsOf: videoUrl)
               // selectImage.viewModel.storyVideo = videoData
                selectImage.viewModel.storyVideo.append(videoData)
                } catch let error {
                        print("*** Error : \(error.localizedDescription)")
                }
            openXIB(XIB: selectImage)
        }
        else {
            print("Something went wrong in video")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
}
