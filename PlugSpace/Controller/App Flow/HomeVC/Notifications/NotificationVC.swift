//
//  NotificationVC.swift
//  PlugSpace
//
//  Created by MAC on 17/11/21.
//

import UIKit

class NotificationVC: BaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var tableview: UITableView!
    
    //MARK:- Propties
    
    let viewModel = NotificationVM()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.contentInset.top = 100
        getDateToString()
        tableview.registerNib(NotificationTableCell.self)
        tableview.registerNib(NotificationDateTVC.self)
        tableview.contentInset.top = -10
        tableview.delegate = self
        tableview.dataSource = self
        NoNotificationData()
    }
    
    //MARK:- Function
    
    private func NoNotificationData() {
        removeNewNoDataViewFrom(containerView: tableview)
        if viewModel.notificationData.count == 0 {
            setNoDataFoundView(containerView: tableview, text:"No Notification Found!")
        }
        else {
            //            viewModel.notificationData.insert(NotificationDetailsModel(dict: ["cellType":"date"]), at: 0)
            //        }
        }
    }
    private func dayDifference(from interval : TimeInterval) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDateInToday(date) {
            return "Today"
        } else {
            viewModel.dateFormatter.dateFormat = "MMM dd, yyyy"
            let msgTime = Date(timeIntervalSince1970: interval)
            return viewModel.dateFormatter.string(from: msgTime)
        }
    }
    
    func getDateToString() {
        viewModel.checkDf.dateFormat = "yyyy-MM-dd"
        
        for (_,dict) in viewModel.notificationData.enumerated() {
            
            if viewModel.notification.count == 0 {
                viewModel.notification.append(NotificationDetailsModel(key: "time", dict: ["time": dict.time]))
                
            } else {
                let lastIndex = viewModel.notification.count - 1
                let prevData = viewModel.notification[lastIndex]
                let prev_msgTime = Date(timeIntervalSince1970: TimeInterval(prevData.time/1000))
                let prevDate = viewModel.checkDf.string(from: prev_msgTime)
                
                let cr_msgTime = Date(timeIntervalSince1970: TimeInterval(dict.time/1000))
                let crDate = viewModel.checkDf.string(from: cr_msgTime)
                
                if prevDate != crDate {
                    viewModel.notification.append(NotificationDetailsModel(key: "time", dict:["time": dict.time]))
                }
            }
            viewModel.notification.append(dict)
        }
        tableview.reloadData()
    }
    //MARK:- Action
    
    @IBAction func clickBtnBack(_ sender: Any) {
        backVC()
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.notification[indexPath.row].key == "time" {
            
            let cell = tableView.dequeCell(NotificationDateTVC.self, indexPath: indexPath)
            cell.setData(time: dayDifference(from: TimeInterval(viewModel.notification[indexPath.row].time/1000)))
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell") as! NotificationTableCell
            cell.setData(data: viewModel.notification[indexPath.row])
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.viewModel.userId = viewModel.notification[indexPath.row].otherId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
