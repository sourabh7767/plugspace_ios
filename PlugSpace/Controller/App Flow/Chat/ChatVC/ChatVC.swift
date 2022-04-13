//
//  ChatVC.swift
//  PlugSpace
//
//  Created by MAC on 23/11/21.
//

import UIKit
import KMPlaceholderTextView
import Firebase
import FirebaseStorage
import FirebaseDatabase
import IQKeyboardManagerSwift
import Alamofire

struct MessageArr {
    var text: String
    var readOrNot: Int
    var type: CellType
 
    init(text: String, readOrNot:Int,type: CellType) {
        self.text = text
        self.type = type
        self.readOrNot = readOrNot
    }
}

struct MESSAGELIST {
    var key: String
    var message_status: String
    var message: String
    var name: String
    var user_id: String
    var time: Int64
    var device_token :String
    var device_type :String
    
    init?(key: String, dict: [String:Any]) {
        self.key = key
        self.message_status = dict["message_status"] as? String ?? ""
        self.message = dict["message"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.user_id = dict["user_id"] as? String ?? ""
        self.time = dict["time"] as? Int64 ?? 0
        self.device_token = dict["device_token"] as? String ?? ""
        self.device_type = dict["device_type"] as? String ?? ""
    }
}

class ChatVC: BaseVC {

    //MARK:- Outlets
    
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet weak var tblChat:UITableView!
    @IBOutlet private weak var messageTxtBottom: NSLayoutConstraint!
    @IBOutlet weak var txtMessage:KMPlaceholderTextView!
    @IBOutlet private weak var lctTxtMessageHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblOnlineStatus:UILabel!
    
    //MARK:- Properties
    
    private var dbRef : DatabaseReference!
    
    private var checkDf = DateFormatter()
    private var dateFormatter = DateFormatter()
    
    private var currentUserType = ""
    private var userID = ""
    private var receiverID = ""
    private var conversationID = ""
    private var receiverCount = String()

    private var isFirstMessage = false
    
    private var receiverToken = ""
    private var receiverType = ""
    
    //MARK:- Other Properties
    
    var conversationData : ChatListModel!
    private var messagesArr = [MESSAGELIST]()
    let userid = SignUpModel(dict: AppPrefsManager.shared.getUserData() as? [String : Any] ?? [String:Any]())
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setData()
        
        dbRef = Database.database().reference()
        userID = userid.userId
        receiverID = conversationData.user_id
        
        checkDf.dateFormat = "yyyy-MM-dd"
        
        if Int(userID)! < Int(receiverID)! {
            conversationID = "\(userID)_\(receiverID)"
        } else {
            conversationID = "\(receiverID)_\(userID)"
        }
        
        getChatData()
        
        txtMessage.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        tblChat.register(UINib(nibName: "SenderChatTVCell", bundle: nil), forCellReuseIdentifier: "SenderChatTVCell")
        tblChat.register(UINib(nibName: "ReceiverTVC", bundle: nil), forCellReuseIdentifier: "ReceiverTVC")
        tblChat.register(UINib(nibName: "ChatDateTVC", bundle: nil), forCellReuseIdentifier: "ChatDateTVC")
        tblChat.delegate = self
        tblChat.dataSource = self
        
        dbRef.child(StringConstant.chatting).child(self.conversationID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                self.getOnline()
            } else {
                self.isFirstMessage = true
                self.lblOnlineStatus.text = "Offline"
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(exitChatUser), name: NSNotification.Name(rawValue: "ExitApp"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotificationObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotificationObservers()
        
        //MARK:- Exit User
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitApp"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpUI()
    }
    
    //MARK:- Method
    
    @objc private func exitChatUser() {
//        dbRef.child(StringConstant.chatting).child(conversationID).observeSingleEvent(of: .value) { [self] (snapshot) in
//            if snapshot.exists() {
//                self.dbRef.child(StringConstant.activeUser).updateChildValues([userID : "0"])
//            }
//        }
        dbRef.child(StringConstant.activeUser).updateChildValues([userID : "0"])
    }
    
    private func setData() {
        imgProfile.sd_setImage(with: URL(string: conversationData.profile), placeholderImage: UIImage(named: "home_1"), options: .retryFailed)
        lblName.text = conversationData.name
    }
    
    private func setUpUI() {
        
        mainView.setBorder(0.3, AppColor.FontBlack)
        cornerView.Set_Corner([.topLeft, .topRight], 34)
        shadowView.cornerRadius = 34
        shadowView.layer.shadowColor = #colorLiteral(red: 0.9935132861, green: 0.4429062009, blue: 0.1601006389, alpha: 1)
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.masksToBounds =  false
        imgProfile.setRound()
    }
    
    private func registerNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewDidValueChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getOnline() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.dbRef.child(StringConstant.chatList).child(self.userID).child(self.receiverID).updateChildValues(["read_count": "0"])
            print("Done count 0")
        }
        
        dbRef.child(StringConstant.activeUser).child(receiverID).observe(.value) { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? String {
                    if dict  == "1" {
                        self.lblOnlineStatus.text = "Active Now"
                    } else {
                        self.lblOnlineStatus.text = "Offline"
                    }
                }
            } else {
                self.lblOnlineStatus.text = "Offline"
            }
        }
        //MARK:- Not Done
        dbRef.child(StringConstant.chatList).child(receiverID).child(self.userID).observe(.value) { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? [String:Any] {
                   
                    self.receiverCount = dict["read_count"] as? String ?? "0"
                }
            }
        }
        
        dbRef.child(StringConstant.activeUser).updateChildValues([userID : "1"])
        
        //MARK:- Not Done
//        dbRef.child(StringConstant.chatting).child(conversationID).updateChildValues(["message_status" : "2"])
    }
    
    private func dayDifference(from interval : TimeInterval) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDateInToday(date) {
            return "Today"
        } else {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let msgTime = Date(timeIntervalSince1970: interval)
            return dateFormatter.string(from: msgTime)
        }
    }
    
    private func scrollToBottom() {
        if self.messagesArr.count != 0 {
            self.tblChat.scrollToBottom(animate: false)
        }
    }
    
    private func NoChatDataFound() {
        removeNewNoDataViewFrom(containerView: tblChat)
        if messagesArr.count == 0 {
            setNoDataFoundView(containerView: tblChat, text:"No Chatting Found!")
        }
    }
    
    private func setOnlineOfflineReadCount(message: String) {
        let token = Messaging.messaging().fcmToken
        // Create sender User and receiver user List with last msg, count, name, profile, etc.
        if messagesArr.count == 0 {
            
            let currentUserDict = ["device_token": receiverToken, "device_type": receiverType, "message": message, "profile": conversationData.profile, "read_count": "0", "user_id": receiverID, "time": ServerValue.timestamp(), "name": conversationData.name] as [String : Any]
            dbRef.child(StringConstant.chatList).child(userID).child(receiverID).setValue(currentUserDict)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                let receiverUserDict = ["device_token": token ?? "", "device_type": "iOS", "message": message, "profile": userid.profile, "read_count": "1", "user_id": self.userID, "time": ServerValue.timestamp(), "name": userid.name] as [String : Any]
                self.dbRef.child(StringConstant.chatList).child(self.receiverID).child(self.userID).setValue(receiverUserDict)
            }
            
        } else if lblOnlineStatus.text == "Active Now" {
            // Both user online to set read count "0" & update last message value in user list
            dbRef.child(StringConstant.chatList).child(receiverID).child(userID).updateChildValues(["read_count" : "0"])
            
            let currentUserDict = ["message": message, "profile": conversationData.profile, "read_count": "0", "time": ServerValue.timestamp(), "user_id": receiverID, "name": conversationData.name] as [String : Any]
            dbRef.child(StringConstant.chatList).child(userID).child(receiverID).updateChildValues(currentUserDict)
            
            let receiverUserDict = ["message": message, "profile": userid.profile, "read_count": self.receiverCount, "time": ServerValue.timestamp(), "user_id": self.userID, "name": userid.name] as [String : Any]
            
            dbRef.child(StringConstant.chatList).child(receiverID).child(userID).updateChildValues(receiverUserDict)
            
        } else {
            // One of user offline to set read count & update last message value in user list
            receiverCount = String((Int(receiverCount) ?? 0) + 1)
            dbRef.child(StringConstant.chatList).child(receiverID).child(userID).updateChildValues(["read_count": receiverCount])
            
            let currentUserDict = ["message": message, "profile": conversationData.profile, "read_count": "0", "time": ServerValue.timestamp(), "user_id": receiverID, "name": conversationData.name] as [String : Any]
            
            dbRef.child(StringConstant.chatList).child(self.userID).child(receiverID).updateChildValues(currentUserDict)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                let receiverUserDict = ["message": message, "profile": userid.profile, "read_count": self.receiverCount, "time": ServerValue.timestamp(), "user_id": self.userID, "name": userid.name] as [String : Any]
                self.dbRef.child(StringConstant.chatList).child(self.receiverID).child(self.userID).updateChildValues(receiverUserDict)
            }
        }
    }
    
    private func getChatData() {
        
        IndicatorManager.showLoader()
        
        dbRef.child(StringConstant.chatting).child(conversationID).observe(.value) { (snapshot) in
            
            IndicatorManager.hideLoader()
            self.messagesArr.removeAll()
            if snapshot.exists() {
                for i in snapshot.children  {
                    let list = i as! DataSnapshot
                    if let data = list.value as? [String:Any], let userData = MESSAGELIST(key: list.key, dict: data) {
                        if self.messagesArr.count == 0 {
                            self.messagesArr.append(MESSAGELIST(key: "time", dict: ["time": userData.time])!)
                           
                        } else {
                            let lastIndex = self.messagesArr.count - 1
                            let prevData = self.messagesArr[lastIndex]
                            let prev_msgTime = Date(timeIntervalSince1970: TimeInterval(prevData.time/1000))
                            let prevDate = self.checkDf.string(from: prev_msgTime)
                            
                            let cr_msgTime = Date(timeIntervalSince1970: TimeInterval(userData.time/1000))
                            let crDate = self.checkDf.string(from: cr_msgTime)
                            
                            if prevDate != crDate {
                                self.messagesArr.append(MESSAGELIST(key: "time", dict: ["time": userData.time])!)
                            }
                            
                        }
                        if userData.user_id == self.receiverID && userData.message_status != "2" {
                            self.dbRef.child(StringConstant.chatting).child(self.conversationID).child(list.key).updateChildValues(["message_status" : "2"])
                        }
                        self.messagesArr.append(userData)
                    }
                }
            }
            self.NoChatDataFound()
            self.tblChat.reloadData()
            self.scrollToBottom()
        }
    }
    
//    private func addData() {
//
//        massageArr.append(MessageArr(text: "Today", readOrNot: 1, type: .time))
//        massageArr.append(MessageArr(text: "Hi, how are you? 🥰 I saw on the app that we've crossed paths several times this week 😁", readOrNot: 0, type: .Receiver))
//
//        massageArr.append(MessageArr(text: "Haha truly! Nice to meet you! What about a cup of coffee today evening? ☕", readOrNot: 1, type: .Sender))
////        massageArr.append(MessageArr(text: "05:32 PM", type: .Sender))
//        massageArr.append(MessageArr(text: "Sure! Let's do it 🥰", readOrNot: 1, type: .Receiver))
////        massageArr.append(MessageArr(text: "640000", type: .Receiver))
//        massageArr.append(MessageArr(text: "Great I will write later the exact time and place. See you soon! 😍", readOrNot: 0, type: .Sender))
////        massageArr.append(MessageArr(text: "2000000", type: .Sender))
//        massageArr.append(MessageArr(text: "Contrary to popular Lorem Ipsum is not simply random", readOrNot: 1, type: .Receiver))
////        massageArr.append(MessageArr(text: "8000000", type: .Receiver))
//        massageArr.append(MessageArr(text: "Great I will write later the exact time and place. See you soon! :heart_eyes:", readOrNot: 0, type: .Sender))
////        massageArr.append(MessageArr(text: "20004534", type: .Sender))
//        massageArr.append(MessageArr(text: "Sounds Good!", readOrNot: 1, type: .Sender))
////        massageArr.append(MessageArr(text: "5856856", type: .Sender))
//    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.messageTxtBottom.constant = hasTopNotch ? (keyboardHeight - 28) : keyboardHeight
            }) { (completed) in
//                self.scrollToBottom()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        messageTxtBottom.constant = hasTopNotch ? 0 : 8
    }
    
    @objc func textViewDidValueChange(notification: Notification) {
        txtMessage.layoutIfNeeded()
        if txtMessage.contentSize.height <= 100 {
            lctTxtMessageHeight.constant = max(txtMessage.contentSize.height, 60)
        }
    }
    
    func getOppositeUserNotificationCount(completion: @escaping(_ count: Int) -> Void) {
        let parameterRequest = ParameterRequest()
        
        parameterRequest.addParameter(key: ParameterRequest.userId, value: conversationData.user_id)
    
        APIClient.shared.sendNotification(parameter: parameterRequest.parameters) { (response, resMsg, resCode, err) in

            guard err == nil else {
                self.alertWith(message: err!, type: .alert)
                return
            }

            if resCode == 1 {
                if let data = response as? [String: Any] {
                    if let status = data["notiCount"] as? Int {
                        completion(status + 1)
                    } else {
                        completion(1)
                    }
                }
            }
        }
    }
    
    func sendPush(message: String, type: Int, badge: Int) {
        /// Android Dict for Push Notification
        let androidDict =
            [
                "isChat": 1,
                "to": "\(receiverToken)",
                "sound": "default",
                "data": [
                    "title": "You have new message by \(userid.name)",
                    "type": type,
                    "body": "\(message)",
                    "notiCount": badge,
                    "senderId": userID,
                ],
            ] as [String: Any]

        /// iOS Dict for Push Notification
        let iOSDict =
            [
                "isChat": 1,
                "to": "\(receiverToken)",
                "priority": "high",
                "notification": [
                    "title": "You have new message by \(userid.name)",
                    "type": type,
                    "text": "\(message)",
                    "sound": "default",
                    "badge": badge,
                    "senderId": userID,
                    "profile": userid.profile,
                    "username": userid.name,
                    "device_token": userid.token,
                    "device_type": "iOS",
                ],
            ] as [String: Any]

        let json = receiverType == "iOS" ? iOSDict : androidDict

        print(json)

        let jsonData = try! JSONSerialization.data(
            withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)

        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("key=\(firebaseServerKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard err == nil else {
                print(err ?? "Error")
                return
            }

            if data != nil {
                let resMsg = String(data: data!, encoding: String.Encoding.utf8)
                print(resMsg ?? "No Str")
            }
        }.resume()
    }
    //MARK:- IBAction
    
    @IBAction private func sendBtn_Action(_ sender : UIButton) {
        self.view.endEditing(true)
        let token = Messaging.messaging().fcmToken
            
        if txtMessage.text!.count > 0 {
            let message = txtMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if let uniqKey = self.dbRef.childByAutoId().key {
                let disc = ["message_status" : "1" ,"message": message,"name": userid.name, "user_id": userID, "time": ServerValue.timestamp(), "device_type": "iOS","device_token": token ?? ""] as [String : Any]
                dbRef.child(StringConstant.chatting).child(conversationID).child(uniqKey).setValue(disc)
                
                if lblOnlineStatus.text == "Offline" {
//                    self.getOppositeUserNotificationCount { (badgeCount) in
                        self.sendPush(message: message, type: 1, badge: 1)
//                    }
                }
            }
            
            if isFirstMessage {
                isFirstMessage = false
                getOnline()
            }
            
            //For ReadCountOnline
            
            setOnlineOfflineReadCount(message: message)
//            getChatData()
            scrollToBottom()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.lctTxtMessageHeight.constant = 50
                self.txtMessage.text = ""
            }
        }
    }
    
    @IBAction private func backBtn_Action(_ sender : UIButton) {
        dbRef.child(StringConstant.activeUser).child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                self.dbRef.child(StringConstant.activeUser).updateChildValues([ self.userID : "0"])
            }
        }
            backVC()
    }
}

extension ChatVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return  messagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chat = messagesArr[indexPath.row]
       
        if chat.key == "time" {
            let cell = tableView.dequeCell(ChatDateTVC.self, indexPath: indexPath)
            cell.lblTime.text = dayDifference(from: TimeInterval(chat.time/1000))
            return cell
            
        } else if chat.user_id == userID {
                
                let cell = tableView.dequeCell(SenderChatTVCell.self, indexPath: indexPath)
                cell.setData(msg: chat.message, readOrNot: chat.message_status, time:chat.time)
                
                return cell
                
        } else {
                
                let cell = tableView.dequeCell(ReceiverTVC.self, indexPath: indexPath)
                cell.setData(msg: chat.message, msgtime: chat.time)
                
                return cell
            }
    }
}
