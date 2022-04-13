//
//  CustomDatePickerView.swift
//  
//
//  Created by MAC on 28/03/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class CustomDatePickerView: NSObject {
    
    fileprivate var textField: UITextField!
    var datePickerView: UIDatePicker!
    fileprivate var formatter: DateFormatter!
    fileprivate var dateFormat: String!
    fileprivate var mode: UIDatePicker.Mode!
    
    fileprivate var minDate: Date!
    fileprivate var maxDate: Date!
    fileprivate var countDownDuration: TimeInterval!
    
    internal var handlerForPickedDate: ((String, Date) -> Void)?
    
    init(textField: UITextField, format: String, mode: UIDatePicker.Mode, minDate: Date? = nil, maxDate: Date? = nil, countDownDuration: TimeInterval? = nil) {
        super.init()
        
        self.textField = textField
        self.dateFormat = format
        self.mode = mode
        self.minDate = minDate
        self.maxDate = maxDate
        
        self.countDownDuration = countDownDuration
        
        setupDatePicker()
    }
    
    // MARK: Methods
    
    fileprivate func setupDatePicker() {
        
        formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = mode
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = maxDate
        
        if datePickerView.datePickerMode == .countDownTimer {
            datePickerView.countDownDuration = countDownDuration
        }
       
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        keyboardToolbar.tintColor = AppColor.Orange
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickToKeyboardToolbarDone(_:)))
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [flex, barButtonItem]
        keyboardToolbar.setItems(items, animated: true)
        
        textField.inputAccessoryView = keyboardToolbar
        textField.inputView = datePickerView
    }
    
    func setMinimumDate(date: Date) {
        datePickerView.minimumDate = date
    }
    
    func setMaximumDate(date: Date) {
        datePickerView.maximumDate = date
    }
    
    func pickerView(selectionDone handler: @escaping (_ selectedDate: String, Date) -> Void) {
        self.handlerForPickedDate = handler
    }
    
    // MARK: IBAction
    @objc fileprivate func clickToKeyboardToolbarDone(_ sender: UIBarButtonItem) {
        if(textField.isFirstResponder) {
            let formatedDateStr = formatter.string(from: datePickerView.date)
            self.handlerForPickedDate?(formatedDateStr, datePickerView.date)
        }
        
        textField.resignFirstResponder()
    }
}
