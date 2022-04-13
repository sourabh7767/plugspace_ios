//
//  BaseVC.swift
//  PlugSpace
//
//  Created by MAC on 13/11/21.
//

import UIKit

class BaseVC: UIViewController {

    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Properties
    
//    var indexValue = 0
    
    //MARK:- Method
    
    func setNoDataFoundView(containerView: UIView, text: String) {
        let noDataFoundViewNew = Bundle.main.loadNibNamed("NoDataFoundView", owner: nil, options: nil)?.first as! NoDataFoundView
        noDataFoundViewNew.tag = -1000
        noDataFoundViewNew.lblNoData.text = text
        noDataFoundViewNew.frame.size = containerView.frame.size
        containerView.addSubview(noDataFoundViewNew)
    }
    
    func removeNewNoDataViewFrom(containerView: UIView) {
        for subview in containerView.subviews where subview.tag == -1000 {
            subview.removeFromSuperview()
            break
        }
    }
}
