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
import Nuke

class MessagesMainView: UITableViewController {
    
    lazy var RefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshUserData(_:)), for: .valueChanged)
        return refreshControl
    }()
 
    var messages = [messageInfo]()
    var messagesDictionary = [String:messageInfo]()
    var listener: ListenerRegistration?
    var listener2: ListenerRegistration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Messages"
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        let newMessage = UIImage(systemName: "square.and.pencil")
        let newMessageButton = UIBarButtonItem(image: newMessage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(gotofriends))
        navigationItem.rightBarButtonItem = newMessageButton
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.refreshControl = RefreshControl
        tableView.showsVerticalScrollIndicator = false

    }
    
    lazy var tabbar = TabBarController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLatestMessagesForUser()
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
        listener2?.remove()
    }
     @objc func refreshUserData(_ sender: Any) {
        messages.removeAll()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        loadLatestMessagesForUser()
        DispatchQueue.main.async {
        self.tableView.reloadData()
        }
        RefreshControl.endRefreshing()
    }
    
    @objc func gotofriends(_ sender: Any) {
    let friendsList = FriendsListToMessage()
        friendsList.messageview = self
        navigationController?.present(friendsList, animated: true)
}
    var count = 0
    
    func loadLatestMessagesForUser(){
       guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection("Latest-Messages").document(uid).collection("Latest").order(by: "TimeStamp", descending: true)
        listener = ref.addSnapshotListener { (snapshot, error) in
            self.messages.removeAll()
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                for document in snapshot!.documents {
                    let data = document.data()
                    if let dictionary = data as [String:AnyObject]? {
                    let message = messageInfo(dictionary: dictionary)
                        self.messages.append(message)
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        }
    }
    
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Deleted")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let message = self.messages[indexPath.row]
        guard let chatpartnerID = message.chatPartner() else {return}

        let latestref = Firestore.firestore().collection("Latest-Messages").document(uid).collection("Latest").document(chatpartnerID)
        latestref.delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                DispatchQueue.main.async {
                    self.messages.removeAll()
                    self.loadLatestMessagesForUser()
                }
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
     
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if messages.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.EmptyMessage(message: "You don't have any messages :(\nAdd Friends to able to chat with them.", viewController: self)
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell 
        let message = messages[indexPath.row]
        cell.message = message

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
                let user = UserInfo(dictionary: dictionary)
                tableView.deselectRow(at: indexPath, animated: true)
                guard let username = user.username else {return}
                guard let chatpartner = message.chatPartner() else {return}
                self.showchatcontrollerForUser(username, chatpartner )
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

extension UITableView {
    
    func EmptyMessage(message:String, viewController:UITableViewController) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        viewController.tableView.backgroundView = messageLabel;
            viewController.tableView.separatorStyle = .none;
    }
}
