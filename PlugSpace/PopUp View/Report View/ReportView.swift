//
//  ReportView.swift
//  PlugSpace
//
//  Created by MAC on 19/02/22.
//

import Foundation
import UIKit

class ReportView: UIView {
    
    //MARK:- Outlets
    
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnSubmit:UIButton!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var textView:UITextView!
    @IBOutlet private weak var txtCommentBottom: NSLayoutConstraint!

    
    //MARK:- Properties
    
    var type = ""
    var friendId = ""
    var viewModel = StoryVM()
    var extraId = ""
    
    //MARK:-
    
    override func awakeFromNib() {
        setupUI()
        registerNotificationObservers()
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: { [self] in
                self.layoutIfNeeded()
                txtCommentBottom.constant = hasTopNotch ? (keyboardHeight - 28) : keyboardHeight
            }) { (completed) in
//                 self.scrollToBottom()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        txtCommentBottom.constant = hasTopNotch ? 0 : 8
    }
    
    //MARK:- Method
    
    private func setupUI() {
        
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom:0, right: 10)
        
        btnSubmit.cornerRadius = 10
        btnCancel.cornerRadius = 10
        mainView.cornerRadius = 10
        textView.cornerRadius = 10  
        
        btnCancel.setBorder(1.5, AppColor.Orange)
        textView.setBorder(0.6, AppColor.Orange)
    }
    
    //MARK:- IBAction
    
    @IBAction func btnActionCancel() {
        closeXIB(XIB: self)
        removeNotificationObservers()
    }
    
    @IBAction func btnActionSubmit() {
        
        viewModel.message = textView.text
        viewModel.type = type
        viewModel.friendId = friendId
        viewModel.extraId = extraId
        
        guard viewModel.reportValidation() else {
            (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: viewModel.errorMessage)
            return
        }
        closeXIB(XIB: self)
        self.endEditing(true)
        removeNotificationObservers()
        viewModel.reportStory { [self] (isSuccess) in
            
            if isSuccess {
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.showToast(message: StringConstant.reportSuceess, y: self.Getheight - 100, font: UIFont(name: AppFont.reguler, size: setCustomFont(18))!)
            } else {
                (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: viewModel.errorMessage)
            }
        }
        
    }
}
