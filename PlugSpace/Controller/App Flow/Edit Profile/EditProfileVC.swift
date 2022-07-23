//
//  EditProfileVC.swift
//  PlugSpace
//
//  Created by MAC on 23/11/21.
//

import UIKit
import DropDown
import DKImagePickerController
import MultiSlider

class EditProfileVC: BaseVC {
    
    //MARK:- Outlets
    
    @IBOutlet private weak var mainView:UIView!
    @IBOutlet private var txtView:[UIView]!
    @IBOutlet private var btnCloseView:[UIView]!
    
    @IBOutlet private var imgProfile:[UIImageView]!
    
    @IBOutlet private weak var aboutTextView:UITextView!
    
    @IBOutlet private var btnimgProfile:[UIButton]!
   
    @IBOutlet private var txtTextFiled:[UITextField]!
   
    @IBOutlet private weak var btnSave:UIButton!
    
    @IBOutlet private var txtDob:UITextField!
    @IBOutlet private var txtname:UITextField!
    @IBOutlet private var txtGender:UITextField!
    @IBOutlet private var txtHeight:UITextField!
    @IBOutlet private var txtWeight:UITextField!
    @IBOutlet private var txtEducationStatus:UITextField!
    @IBOutlet private var txtChildren:UITextField!
    @IBOutlet private var txtMarringRace:UITextField!
    @IBOutlet private var txtRelationShipStatus:UITextField!
    @IBOutlet private var txtEthinicity:UITextField!
    @IBOutlet private var txtCompanyName:UITextField!
    @IBOutlet private var txtJobTitle:UITextField!
    @IBOutlet private var txtMakeOver:UITextField!
    @IBOutlet private var txtDessSize:UITextField!
    @IBOutlet private var txtHowManyTimeEngage:UITextField!
    @IBOutlet private var txtHowManyTattoo:UITextField!
    @IBOutlet private var txtAgeRange:UITextField!
    @IBOutlet private var txtmyself:UITextField!
    @IBOutlet private var txtNiceMeet:UITextField!
    
    @IBOutlet weak var rankSlider: UIView!
    @IBOutlet weak var rankNameLbl: UILabel!
    
    //MARK:- Properties
    
    private var viewModel = EditProfileVM()
    private var educationStatus = DropDown()
    private var genderDropDown = DropDown()
    private var heightDropDown = DropDown()
    private var weightDropDown = DropDown()
    private var childrenDropDown = DropDown()
    private var marringRaceDropDown = DropDown()
    private var relationShipStatus = DropDown()
    private var enthicityDropDown = DropDown()
    private var dressSizeDropDown = DropDown()
    private var timesEngagedDropDown = DropDown()
    private var tattoosDropDown = DropDown()
    private var meetNiceDropDown = DropDown()
    private var considerMyself = DropDown()
    private var ageRangePopUP = UIView.getView(viewT: AgeRangePopUP.self)

    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.imagePicker.delegate = self
        txtDob.delegate = self
        aboutTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom:10, right: 10)
       
        setDropDown()
        setImageController()
        setUpMultiSlider()
    }
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpUI()
    }
    
    //MARK:- Method
    
    func setUpUI() {
        
        btnSave.cornerRadius = 10
        txtTextFiled.setBlankView(20, .Left)
        aboutTextView.cornerRadius = 10
        
        for (index,_) in txtTextFiled.enumerated() {
            
            txtTextFiled[index].delegate = self
        }
        
        setAfter { [self] in
            
            btnCloseView.setRound()
            mainView.setBorder(0.3, AppColor.FontBlack)
            mainView.setBorder(0.3, AppColor.FontBlack)
            mainView.setBorder(0.3, AppColor.FontBlack)
            
            for view in txtView {
                
                view.layer.masksToBounds = false
                view.layer.cornerRadius = 10
                view.layer.shadowColor = AppColor.Orange.cgColor
                view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
                view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                view.layer.shadowOpacity = 0.2
                view.layer.shadowRadius = 4.0
                view.backgroundColor = UIColor.white
            }
            
            for view in imgProfile {
                
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 10
                view.layer.shadowColor = AppColor.Orange.cgColor
                view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
                view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                view.layer.shadowOpacity = 0.2
                view.layer.shadowRadius = 3.0
                view.backgroundColor = UIColor.white
            }
        }
    }
    
    
    private func setUpMultiSlider() {
        
        let horizontalMultiSlider = MultiSlider()
        
        horizontalMultiSlider.isValueLabelRelative = true
        horizontalMultiSlider.disabledThumbIndices = [3]
        horizontalMultiSlider.thumbCount = Int(Double(viewModel.rank) ?? 1)
        horizontalMultiSlider.thumbImage = UIImage(named: "sinlgeProgressBar")
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.minimumValue = 1
        horizontalMultiSlider.maximumValue = 11
        horizontalMultiSlider.outerTrackColor = .white
        horizontalMultiSlider.value = [CGFloat(Double(viewModel.rank) ?? 1)]
        horizontalMultiSlider.valueLabelPosition = .top
        horizontalMultiSlider.tintColor = AppColor.Orange
        horizontalMultiSlider.trackWidth = 6
        horizontalMultiSlider.showsThumbImageShadow = true
        horizontalMultiSlider.setShadow(3.0, 0.0, 1, AppColor.FontBlack, 0.2)
        horizontalMultiSlider.addTarget(self, action: #selector(rankSliderChanged), for: .valueChanged)
        
        horizontalMultiSlider.snapStepSize = 1
        horizontalMultiSlider.valueLabelColor = #colorLiteral(red: 0.9764705882, green: 0.4156862745, blue: 0.1176470588, alpha: 1)
        horizontalMultiSlider.valueLabelFont = UIFont(name: AppFont.bold, size: 20)
        
        rankSlider.addConstrainedSubview(horizontalMultiSlider, constrain: .leftMargin, .rightMargin, .bottomMargin)
        rankSlider.layoutMargins = UIEdgeInsets(top: -30, left: 16, bottom: -10, right: 16)
        rankSliderChanged(horizontalMultiSlider)
    }
    
    @objc func rankSliderChanged(_ slider: MultiSlider) {
        
        viewModel.rank = String(format: "%.0f", slider.value[0])
        viewModel.gender = txtGender.text!
        if viewModel.rank.isEmptyOrWhiteSpace {
            self.errorAlert(message: StringConstant.rankUser)
            return
        }
        viewModel.getManRankPerson { [self] (isSuccess) in
            
            if isSuccess {
                getRankPerson()
                
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    
    func getRankPerson() {
        rankNameLbl.text?.removeAll()
        if viewModel.rankNameArr.first?.data.isEmpty == false {
            var str = [String]()
            for (index, name) in viewModel.rankNameArr[0].data.enumerated() {
                    str.append("\(index + 1). \(name)")
            }
            rankNameLbl.text = str.joined(separator: ", ")
            rankNameLbl.isHidden = false
        } else {
            // lblName.text = "The rankers not found which you are selected!"
            rankNameLbl.isHidden = true
        }
    }
    
    func setDropDown() {
    
        txtEducationStatus.setViewOnText()
        
        txtGender.setViewOnText()
        
        txtHeight.setViewOnText()
        
        txtWeight.setViewOnText()
        
        txtChildren.setViewOnText()
       
        txtMarringRace.setViewOnText()
    
        txtRelationShipStatus.setViewOnText()
       
        txtEthinicity.setViewOnText()
     
        txtDessSize.setViewOnText()
       
        txtHowManyTimeEngage.setViewOnText()
        
        txtHowManyTattoo.setViewOnText()
       
        txtAgeRange.setViewOnText()
        
        txtNiceMeet.setViewOnText()
        
        for item in 60...viewModel.weightValue {
            viewModel.WeightArray.append("\(item) lbs")
        }
        
        educationStatus.setData(dropDown: educationStatus, dataArr: viewModel.educationStatusArr, anchorView: txtEducationStatus)
        
        genderDropDown.setData(dropDown: genderDropDown, dataArr: viewModel.genderArr, anchorView: txtGender)
        
        heightDropDown.setData(dropDown: heightDropDown, dataArr: viewModel.HeightArray, anchorView: txtHeight)
        
        weightDropDown.setData(dropDown: weightDropDown, dataArr: viewModel.WeightArray, anchorView: txtWeight)
        
        childrenDropDown.setData(dropDown: childrenDropDown, dataArr: viewModel.Children, anchorView: txtChildren)
        
        marringRaceDropDown.setData(dropDown: marringRaceDropDown, dataArr: viewModel.marryingOtherRace, anchorView: txtMarringRace)
        
        relationShipStatus.setData(dropDown: relationShipStatus, dataArr: viewModel.RelationshipStatus, anchorView: txtRelationShipStatus)
        
        enthicityDropDown.setData(dropDown: enthicityDropDown, dataArr: viewModel.ethinicityArr, anchorView: txtEthinicity)
        
        dressSizeDropDown.setData(dropDown: dressSizeDropDown, dataArr: viewModel.DressSize, anchorView: txtDessSize)
        
        timesEngagedDropDown.setData(dropDown: timesEngagedDropDown, dataArr: viewModel.manyTimesEngaged, anchorView: txtHowManyTimeEngage)
        
        tattoosDropDown.setData(dropDown: tattoosDropDown, dataArr: viewModel.tattooArr, anchorView: txtHowManyTattoo)
        
        meetNiceDropDown.setData(dropDown: meetNiceDropDown, dataArr: viewModel.niceMeetArr, anchorView: txtNiceMeet)
        
        considerMyself.setData(dropDown: considerMyself, dataArr: viewModel.considerMyselfType, anchorView: txtmyself)
        
        educationStatus.selectionAction = { [self] (index, item) in
            txtEducationStatus.text = item
        }
        
        genderDropDown.selectionAction = { [self] (index, item) in
            txtGender.text = item
        }
        
        heightDropDown.selectionAction = { [self] (index, item) in
            txtHeight.text = item
        }
        
        weightDropDown.selectionAction = { [self] (index, item) in
            txtWeight.text = item
        }
        
        childrenDropDown.selectionAction = { [self] (index, item) in
            txtChildren.text = item
        }
        
        marringRaceDropDown.selectionAction = { [self] (index, item) in
            txtMarringRace.text = item
        }
        
        relationShipStatus.selectionAction = { [self] (index, item) in
            txtRelationShipStatus.text = item
        }
        
        enthicityDropDown.selectionAction = { [self] (index, item) in
            txtEthinicity.text = item
        }
        
        dressSizeDropDown.selectionAction = { [self] (index, item) in
            txtDessSize.text = item
        }
        
        timesEngagedDropDown.selectionAction = { [self] (index, item) in
            txtHowManyTimeEngage.text = item
        }
        
        tattoosDropDown.selectionAction = { [self] (index, item) in
            txtHowManyTattoo.text = item
        }
        
        meetNiceDropDown.selectionAction = { [self] (index, item) in
            txtNiceMeet.text = item
        }
        
        considerMyself.selectionAction = { [weak self] (index, item) in
            self?.txtmyself.text = item
        }
    }
    
    func setData() {
        
        let userData = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
        txtname.text = userData.name
    
        viewModel.profileTotalImageArr.removeAll()
        
        for (index,imageData) in userData.mediaDetail.enumerated() {
            if index <= 6 {
                    if imageData.type == "profile" {
                        btnCloseView[index].isHidden =  false
                        btnimgProfile[index].isUserInteractionEnabled = false
                        imgProfile[index].sd_setImage(with: URL(string: imageData.profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
                        viewModel.profileTotalImageArr.append(index)
                    }
            }
        }
        
        txtGender.text = userData.gender
        txtHeight.text = userData.height
        txtEducationStatus.text = userData.educationStatus
        txtDob.text = userData.dob
        txtChildren.text = userData.children
        txtMarringRace.text = userData.marringRace
        txtRelationShipStatus.text = userData.relationshipStatus
        txtEthinicity.text = userData.ethinicity
        txtCompanyName.text = userData.companyName
        txtJobTitle.text = userData.jobTitle
        txtMakeOver.text = userData.makeOver
        txtDessSize.text = userData.dressSize
        txtHowManyTimeEngage.text = userData.timesofEngaged
        txtHowManyTattoo.text = userData.yourBodyTatto
        txtmyself.text = userData.mySelfMan
        txtAgeRange.text = userData.ageRangeMarriage
        txtNiceMeet.text = userData.niceMeet
        aboutTextView.text = userData.aboutYou
        viewModel.rank = userData.menRank
        
    }
    
    func openPopUp() {
        self.view.endEditing(true)
        ageRangePopUP = UIView.getView(viewT: AgeRangePopUP.self)
        ageRangePopUP.delegate = self
        openXIB(XIB: ageRangePopUP)
    }
    
    //MARK:- Handle DatePicker
    @objc func handleDatePicker()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
//        txtDob.text = dateFormatter.string(from: viewModel.date.date)
        viewModel.date.date.lessthenYears() < 18 ? alertWith(message: StringConstant.dobValide) : nil
        txtDob.text! = viewModel.date.date.lessthenYears() < 18 ? txtDob.text! : dateFormatter.string(from: viewModel.date.date)
    }
    
    func updateProfileApiCall() {
        
        viewModel.name = txtname.text!
        viewModel.gender = txtGender.text!
        viewModel.isGeoLocation = ""
        viewModel.height = txtHeight.text!
        viewModel.weight = txtWeight.text!
        viewModel.educationStatus = txtEducationStatus.text!
        viewModel.dob = txtDob.text!
        viewModel.children = txtChildren.text!
        viewModel.wantChildrens = txtChildren.text!
        viewModel.marringRace = txtMarringRace.text!
        viewModel.relationshipStatus = txtRelationShipStatus.text!
        viewModel.ethinicity = txtEthinicity.text!
        viewModel.companyName = txtCompanyName.text!
        viewModel.makeOver = txtMakeOver.text!
        viewModel.dressSize = txtDessSize.text!
        viewModel.timesOfEngaged = txtHowManyTimeEngage.text!
        viewModel.yourBodyTatto = txtHowManyTattoo.text!
        viewModel.ageRangeMarriage = txtAgeRange.text!
        viewModel.mySelfMen = txtmyself.text!
        viewModel.niceMeet = txtNiceMeet.text!
        viewModel.jobTitle = txtJobTitle.text!
        viewModel.aboutYou = aboutTextView.text!
        
        viewModel.updateProfile { [self] (isSuccess) in
            if isSuccess {
                setData()
                alertWith(message: viewModel.errorMessage)
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
    }
    
    func updatePhotoAPiCall() {
        
        let userData = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
        
        guard viewModel.index <= viewModel.profileTotalImageArr.count - 1 else {
            return
        }
        
        viewModel.removeMediaId = userData.mediaDetail[viewModel.index].media_id
        viewModel.type = userData.mediaDetail[viewModel.index].type
        
        viewModel.previewDelete { [self] (isSuccess) in
            if isSuccess {
                setData()
//                alertWith(message: viewModel.errorMessage)
            } else {
                alertWith(message: viewModel.errorMessage)
            }
        }
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
            
            for image in assets {
                image.fetchOriginalImage(completeBlock: { (image, _) in
                    self.imgProfile[self.viewModel.index].image = image
                    self.btnimgProfile[self.viewModel.index].isUserInteractionEnabled = false
                    self.btnCloseView[self.viewModel.index].isHidden = false
                    self.viewModel.profile.append(image!.jpegData(compressionQuality: 0.5)!)
                })
            }
        }
    }
    
    //MARK:- IBAction
    
    @IBAction func btnAction(_ sender:UIButton) {
        viewModel.index = sender.tag
        alertWith(AppName, message: nil, type: .actionSheet, cancelTitle: "Cancel", othersTitle: viewModel.title, cancelTap: nil) { [self] (index, _) in
            
            switch index {
            
            case 0 :
                present(viewModel.imagePickerController, animated: true)
                break
            case 1 :
                openUIImagePickerController(for: viewModel.imagePicker, type: .photoLibrary)
                break
            default :
                print("okk")
            }
        }
    }
    
    @IBAction func btnCloseAction(_ sender:UIButton) {
        viewModel.index = sender.tag
        imgProfile[sender.tag].image = UIImage(named: "ic_SelectImage")
        btnimgProfile[sender.tag].isUserInteractionEnabled = true
        btnCloseView[sender.tag].isHidden = true
//        viewModel.selectedTotalImageArr.remove(at: viewModel.index)
        updatePhotoAPiCall()
        
    }
    
    @IBAction func btnPreview(_ sender:UIButton) {
        pushVC(PreviewVC.self,storyboard: .Home)
    }
    
    @IBAction func btnSetting(_ sender:UIButton) {
        pushVC(SettingVC.self,storyboard: .Home)
    }
    
    @IBAction func btnSave(_ sender:UIButton) {
        self.view.endEditing(true)
        updateProfileApiCall()
    }
}

//MARK:- Date Piker

extension EditProfileVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField == txtEducationStatus ? educationStatus.showDropDown(dropDown: educationStatus) : nil
       
        textField == txtGender ? genderDropDown.showDropDown(dropDown: genderDropDown) : nil
        
        textField == txtHeight ? heightDropDown.showDropDown(dropDown: heightDropDown) : nil
        
        textField == txtWeight ? weightDropDown.showDropDown(dropDown: weightDropDown) : nil
        
        textField == txtChildren ? childrenDropDown.showDropDown(dropDown: childrenDropDown) : nil
        
        textField == txtMarringRace ? marringRaceDropDown.showDropDown(dropDown: marringRaceDropDown) : nil
        
        textField == txtRelationShipStatus ? relationShipStatus.showDropDown(dropDown: relationShipStatus) : nil
        
        textField == txtEthinicity ? enthicityDropDown.showDropDown(dropDown: enthicityDropDown) : nil
        
        textField == txtDessSize ? dressSizeDropDown.showDropDown(dropDown: dressSizeDropDown) : nil
        
        textField == txtHowManyTimeEngage ? timesEngagedDropDown.showDropDown(dropDown: timesEngagedDropDown) : nil
        
        textField == txtHowManyTattoo ? tattoosDropDown.showDropDown(dropDown: tattoosDropDown) : nil
        
        textField == txtAgeRange ? openPopUp() : nil
        
        textField == txtNiceMeet ? meetNiceDropDown.showDropDown(dropDown: meetNiceDropDown) : nil
        
        textField == txtmyself ? considerMyself.showDropDown(dropDown: considerMyself) : nil
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtDob {
            
            if #available(iOS 14, *) {
                viewModel.date.preferredDatePickerStyle = .wheels
                viewModel.date.sizeToFit()
            }
            
            viewModel.date.datePickerMode = .date
            txtDob.inputView = viewModel.date
            viewModel.date.addTarget(self, action: #selector(handleDatePicker), for: UIControl.Event.valueChanged)
            return true
        }
        return true
    }
}

//MARK:- Image piker

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let Image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgProfile[viewModel.index].image = Image
            btnimgProfile[viewModel.index].isUserInteractionEnabled = false
            btnCloseView[viewModel.index].isHidden = false
            viewModel.profile.append(Image.jpegData(compressionQuality: 0.5)!)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- AgeRangeDelegate

extension EditProfileVC: ageRangeValueDelegate {
    func getValue(value: String, view: AgeRangePopUP) {
        txtAgeRange.text = value
    }
}
