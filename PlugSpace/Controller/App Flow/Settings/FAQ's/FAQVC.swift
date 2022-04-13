//
//  FAQ'sVC.swift
//  PlugSpace
//
//  Created by MAC on 16/11/21.
//

import UIKit

class FAQVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var FaqtblView: UITableView!
    
    //MARK:- Propties
  
    let titleArr = ["What is plugspace?", "How do I reset my digital plugspace?", "If use plugspace lore ipsum?", "Why choose plugspace?", "What are the different plugspace?"]
    
    var openArr : [Int] = []

    let discriptionArr = ["Lorem Ipsum has been the industry's standard the dummy text ever since the 1500s, when and verys unknown printer took a galley of type and very use scrambled it to make a type specimen book.", "Lorem Ipsum has been the industry's standard the dummy text ever since the 1500s, when and verys unknown printer took a galley of type and very use scrambled it to make a type specimen book., How do I reset my digital plugspace?", "If use plugspace lore ipsum?, Lorem Ipsum has been the industry's standard the dummy text ever since the 1500s, when and verys unknown printer took a galley of type and very use scrambled it to make a type specimen book, Lorem Ipsum has been the industry's standard the dummy text ever since the 1500s..", "Lorem Ipsum has been the industry's standard the dummy text ever since the 1500s, when and verys unknown printer took a galley of type and very use scrambled it to make a type specimen book. verys unknown printer took a galley of type and very use scrambled it to make a type specimen book.,Why choose plugspace?", "What are the different plugspace?, Lorem Ipsum has been the industry's standard the dummy text ever since the 1500s, when and verys unknown printer took a galley of type and very use scrambled it to make a type specimen book."]
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FaqtblView.delegate = self
        FaqtblView.dataSource = self
        FaqtblView.registerNib(FaqTableCell.self)
        FaqtblView.contentInset.top = 10
        FaqtblView.contentInset.bottom = 10
    }
  
    
    //MARK:- Function
    
    
    
    //MARK:- Action
  
    @IBAction func clickOnBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOnBtnSubmit(_ sender: Any) {
    }
}


//MARK:- UITableView

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTableCell") as! FaqTableCell
        cell.lblTitle.text = "\(indexPath.row+1)." + " " + "\(titleArr[indexPath.row])"
        cell.lblDiscription.text = discriptionArr[indexPath.row]
        
        if openArr.contains(indexPath.row) {
            cell.btnPlus.setImage(UIImage(named: "ic_minus"), for: .normal)
            cell.viewDivider.isHidden = false
            cell.viewDiscription.isHidden = false
        } else {
            cell.btnPlus.setImage(UIImage(named: "ic_plus"), for: .normal)
            cell.viewDivider.isHidden = true
            cell.viewDiscription.isHidden = true
        }
        
//        cell.btnPlus.tag = indexPath.row
//        cell.btnPlus.addTarget(self, action: #selector(btnClicnk(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if openArr.contains(indexPath.row) {
            openArr.remove(object: indexPath.row)
        } else {
            openArr.append(indexPath.row)
        }
        FaqtblView.reloadData()
    }
    
//    @objc func btnClicnk(_ sender: UIButton) {
//        if openArr.contains(sender.tag) {
//            openArr.remove(object: sender.tag)
//        } else {
//            openArr.append(sender.tag)
//        }
//        FaqtblView.reloadData()
//
//    }
    
}
