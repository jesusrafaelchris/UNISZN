//
//  FriendRequests.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 24/07/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class FriendRequests: UITableViewController {
    
    var requests = [UserInfo]()
    
    lazy var RefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshfriendRequests(_:)), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(RequestCell.self, forCellReuseIdentifier: "RequestCell")
        self.navigationItem.title = "Friend Requests"
        tableView.delegate = self
        tableView.dataSource = self
        getFriendRequests()
        tableView.refreshControl = RefreshControl
    }
    
    @objc func refreshfriendRequests(_ sender: Any) {
        self.requests.removeAll()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        getFriendRequests()
        RefreshControl.endRefreshing()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getFriendRequests() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection("Friends").document(uid).collection("Requested")
        ref.getDocuments { (snapshot, error) in
        if error != nil {
            print(error!.localizedDescription)
        }
                
        else {
            for document in snapshot!.documents {
               let userID = document.documentID
                let userRef = Firestore.firestore().collection("users").document(userID)
                userRef.getDocument { (snapshot, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                        
                else {
                    let data = snapshot?.data()
                        if let dictionary = data as [String:AnyObject]? {
                        let user = UserInfo(dictionary: dictionary)
                            self.requests.append(user)
                            }
                        }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc func AcceptRequest(sender: TapGesture) {
        self.showSpinner(onView: self.view)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let uid = sender.uid
        print("Accepted", uid)
        let batch = Firestore.firestore().batch()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let RequestedRef = Firestore.firestore().collection("Friends").document(userID).collection("Requested").document(uid)

        batch.deleteDocument(RequestedRef)
        
        let AcceptedRef = Firestore.firestore().collection("Friends").document(userID).collection("Accepted").document(uid)
        
        let data = ["Friend": uid ]
        batch.setData(data, forDocument: AcceptedRef)
        
        let tapLocation = sender.location(in: self.tableView)
        if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
            if let cell = self.tableView.cellForRow(at: tapIndexPath) as? RequestCell {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                cell.acceptButton.isHidden = true
                cell.deleteButton.backgroundColor = .blue
                cell.deleteButton.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
                cell.deleteButton.text = "Accepted"
                cell.deleteButton.isUserInteractionEnabled = false
            }
        }
        
        
        batch.commit() { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Friend Request Accepted.")
                    DispatchQueue.main.async {
                    self.removeSpinner()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func DeleteRequest(sender: TapGesture) {
        
        let uid = sender.uid
        print("Deleted", uid)
        let batch = Firestore.firestore().batch()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let RequestedRef = Firestore.firestore().collection("Friends").document(userID).collection("Requested").document(uid)

        batch.deleteDocument(RequestedRef)
        
        let tapLocation = sender.location(in: self.tableView)
        if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
            if let cell = self.tableView.cellForRow(at: tapIndexPath) as? RequestCell {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                cell.acceptButton.isHidden = true
                cell.deleteButton.backgroundColor = .purple
                cell.deleteButton.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
                cell.deleteButton.text = "Deleted"
                cell.deleteButton.isUserInteractionEnabled = false

            }
        }
        
        batch.commit() { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Friend Request cancelled.")
                    DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func RequestToProfile(sender: TapGesture) {
        let searchprofile = SearchProfile()
        searchprofile.uid = sender.uid
        navigationController?.pushViewController(searchprofile, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        cell.selectionStyle = .none
        
        let user = requests[indexPath.row]
        
        if let username = user.username, let UID = user.uid {
         cell.username.text = username
         let tapGestureRecognizer3 = TapGesture(target: self, action: #selector(RequestToProfile(sender:)))
         tapGestureRecognizer3.numberOfTapsRequired = 1
         tapGestureRecognizer3.cancelsTouchesInView = false
         tapGestureRecognizer3.uid = UID
         cell.username.addGestureRecognizer(tapGestureRecognizer3)
        
        
        let options = ImageLoadingOptions (
            placeholder: UIImage(named: "placeholder"),
            transition: .fadeIn(duration: 0.33)
        )
        
        if let url = user.ProfilePicUrl {
            if let Url = URL(string: url) {
                Nuke.loadImage(with: Url, options: options, into: cell.profilePicture)
            }
        }

        let tapGestureRecognizer = TapGesture(target: self, action: #selector(AcceptRequest(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.uid = UID
        cell.acceptButton.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = TapGesture(target: self, action: #selector(DeleteRequest(sender:)))
        tapGestureRecognizer2.numberOfTapsRequired = 1
        tapGestureRecognizer2.cancelsTouchesInView = false
        tapGestureRecognizer2.uid = UID
        cell.deleteButton.addGestureRecognizer(tapGestureRecognizer2)
            
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if requests.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.EmptyMessage(message: "You don't have any Friend Requests yet \nGo add some friends!", viewController: self)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    

}

