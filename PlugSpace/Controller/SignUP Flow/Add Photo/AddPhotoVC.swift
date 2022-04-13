//
//  AddPhotoVC.swift
//  PlugSpace
//
//  Created by MAC on 16/11/21.
//

import UIKit
import DKImagePickerController


class AddPhotoVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet var imgProfile:[UIImageView]!
    @IBOutlet private weak var lblNote1: UILabel!
    @IBOutlet private weak var lblNote2: UIView!
    @IBOutlet private weak var lblNote3: UIView!
    @IBOutlet private weak var btnNext:UIButton!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private var imgView:[UIView]!
    @IBOutlet private weak var stackViewNote: UIStackView!
    @IBOutlet private weak var lblNote: UILabel!
    
    // MARK: - Properties
    
    private var viewModel = AddPhotoVM()
    
    // MARK: - VC Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUPVM.shared.profile = [Data]()
        setImageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        btnNext.cornerRadius = 10
        setAfter { [self] in
            
            self.cornerView.Set_Corner([.bottomLeft,.bottomRight], 34)
            shadowView.cornerRadius = 34
            shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.masksToBounds =  false
            
            for view in self.imgView {
                view.layer.masksToBounds = false
                view.layer.cornerRadius = 10
                view.layer.shadowColor = AppColor.Orange.cgColor
                view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
                view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                view.layer.shadowOpacity = 0.2
                view.layer.shadowRadius = 3.0
                view.backgroundColor = UIColor.white
            }
            
            for view in self.imgProfile {
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 10
            }
        }
    }
    
    func setImageController() {
        viewModel.multiImagePickerController.allowSwipeToSelect = true
        viewModel.multiImagePickerController.maxSelectableCount = 7
        viewModel.multiImagePickerController.allowSelectAll = false
        viewModel.multiImagePickerController.sourceType = .both
        viewModel.multiImagePickerController.showsCancelButton = true
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font : UIFont(name: AppFont.reguler, size: setCustomFont(18))!,
            NSAttributedString.Key.foregroundColor : AppColor.Orange
        ]
        
        viewModel.multiImagePickerController.didSelectAssets = { [self] (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            SignUPVM.shared.profile.removeAll()
            
            for (index,image) in assets.enumerated() {
                image.fetchOriginalImage(completeBlock: { (image, _) in
                    self.imgProfile[index].image = image
                    SignUPVM.shared.profile.append((image!.jpegData(compressionQuality: 0.5)!))
                })
                
                if index == 1 {
                    
                    lblNote1.isHidden = true
                }else if index == 2 {
                    lblNote.isHidden = true
                }else if index == 3 {
                    stackViewNote.isHidden = true
                    lblNote2.isHidden = true
                    lblNote3.isHidden = true
                }
            }
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction private func btnclick(_ sender: UIButton) {
        
    }
    
    @IBAction private func onBtnimg1(_ sender: UIButton) {
        present(viewModel.multiImagePickerController, animated: true)
    }
    
    @IBAction private func onBtnNext(_ sender: UIButton) {
        
        SignUPVM.shared.profile.count != 0 ? pushVC(HeightVC.self,animated: false) :SignUPVM.shared.callValidationMethod(Vc: self)
    }
    
    @IBAction private func onBtnBack(_ sender: UIButton) {
        
        backNormalVC(animated: false)
    }
}

//MARK:- Image piker

//extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        picker.dismiss(animated: true, completion: nil)
//
//        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//
//            imgProfile[viewModel.index].image = editedImage
//            SignUPVM.shared.profile.append(editedImage.jpegData(compressionQuality: 0.5)!)
//
//            if viewModel.index == 1 {
//
//                lblNote1.isHidden = true
//            }else if viewModel.index == 2 {
//                lblNote.isHidden = true
//            }else if viewModel.index == 3 {
//                stackViewNote.isHidden = true
//                lblNote2.isHidden = true
//                lblNote3.isHidden = true
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("Cancelled")
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
