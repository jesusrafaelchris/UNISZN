//
//  MessagesMainView.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 09/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth
import Kingfisher

class MessagesMainView: UITableViewController {
 
    var messages = [messageInfo]()
    var messagesDictionary = [String:messageInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Messages"
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.reloadData()
        let newMessage = UIImage(systemName: "square.and.pencil")
        let newMessageButton = UIBarButtonItem(image: newMessage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(gotofriends))
        navigationItem.rightBarButtonItem = newMessageButton
        loadmessagesForUser()
        tableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        messages.removeAll()
//        messagesDictionary.removeAll()
//    }
    
    @objc func gotofriends(_ sender: Any) {
    let friendsList = FriendsListToMessage()
        friendsList.messageview = self
        navigationController?.present(friendsList, animated: true)
}
    
    
    func loadmessagesForUser(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let ref = Firestore.firestore().collection("user-messages").document(uid).collection(uid)
        ref.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                for document in snapshot!.documents {
                let data = document.data()
                let messageID = data.keys
               
                let stringArray = Array(messageID)
                for message in stringArray {
                
                let messageRef = Firestore.firestore().collection("messages").document(message)
                messageRef.getDocument { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                         
                        let data = snapshot?.data()
                        if let dictionary = data as [String:AnyObject]? {
                        let message = messageInfo(dictionary: dictionary)
                        if let chatPartnerID = message.chatPartner() {
                        self.messagesDictionary[chatPartnerID] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort { (message1, message2) -> Bool in
                        return (message1.TimeStamp!.intValue) > message2.TimeStamp!.intValue
                        }}
                          
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                    }}}}}}}})}

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
     
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell 
        let message = messages[indexPath.row]
        let ToID = message.ToID
        if ToID != Auth.auth().currentUser?.uid {
            service.getUsernameFromUID(ToID!) { (username) in
                cell.textLabel?.text = username
            }
        }
        else {
            service.getUsernameFromUID(message.FromID!) { (username) in
            cell.textLabel?.text = username
        }
        }
        cell.detailTextLabel?.text = message.Text

        service.loadProfilePic(userID: message.chatPartner()!) { (url) in
            cell.profilePicture.kf.setImage(with: url)
        }
        
        if let seconds = message.TimeStamp?.doubleValue {
            let timeStampDate = NSDate(timeIntervalSinceReferenceDate: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE hh:mm a"
            cell.timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
        }
        
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        guard let chatPartnerID = message.chatPartner() else {
            return
        }
        let ref = Firestore.firestore().collection("users").document(chatPartnerID)
        ref.getDocument { (snapshot, error) in
        if let error = error {
            print(error.localizedDescription)
        } else {
            if let snapshot = snapshot {
            let data = snapshot.data()
                guard let dictionary = data as [String:AnyObject]? else {return}
                let user = User()
                user.setValuesForKeys(dictionary)
                tableView.deselectRow(at: indexPath, animated: true)
                self.showchatcontrollerForUser(user.username!, message.chatPartner()! )
                }
            }
        }
    }
     
    func showchatcontrollerForUser(_ username: String, _ id: String ) {
      let Message = MessageLog(collectionViewLayout: UICollectionViewFlowLayout())
      Message.username = username
      Message.id = id
        Message.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(Message, animated: true)
    }
}

