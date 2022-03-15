//
//  FriendsLogic.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 22/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase

extension SearchProfile {
    
    func areTheyFriends(completion: @escaping(_ result: String) -> () ) {
        
        guard let UID = uid else {return}
        guard let userID = Auth.auth().currentUser?.uid else {return}
            
        let FriendsRef = self.Friends.document(UID).collection("Accepted").document(userID)
        self.quoteListener = FriendsRef.addSnapshotListener { (snapshot, error) in
            
        if let document = snapshot {
            
            if !document.exists {
                
                    self.checkIfRequested { (result) in
                        if result == true {
                            completion("Requested")
                        }
                        else {
                            self.CheckIfYouBlockedThem { (result) in
                            if result == true {
                                    completion("Blocked")
                                }
                            else {
                            completion("Not Requested")
                                }
                            }
                        }
                    }
            
                                }
                
                    else {
                        completion("Friends")
                    }
            
                }
            }
        }
    
    func checkIfRequested(completion: @escaping(_ result: Bool) -> () ) {
        
        guard let UID = uid else {return}
        guard let userID = Auth.auth().currentUser?.uid else {return}
            
        let FriendsRef = self.Friends.document(UID).collection("Requested").document(userID)
        self.quoteListener2 = FriendsRef.addSnapshotListener { (snapshot, error) in
            
        if let document = snapshot {
            
            if !document.exists {
                completion(false)
            }
            
            else {
                completion(true)
                    }
                }
            }
        }

    @objc func AddFriend() {
        if AddFriendButton.titleLabel?.text == "Friends" {
            
            handleRemoveFriend()
        }
        
        else if AddFriendButton.titleLabel?.text == "Requested" {
            handleCancelRequest()
        }
           
        else if AddFriendButton.titleLabel?.text == "Blocked" {
            handleUnblockUser()
        }
        
        else {
            handleRequestFriend()
        }
    }
    
    
    func handleUnblockUser() {
        print("unblock")
        guard let UID = self.uid else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let blockedref = Firestore.firestore().collection("Blocked").document(uid).collection("BlockedUsers").document(UID)
        blockedref.delete { (error) in
            self.Alert("This user has been unblocked", "")
        }

    }
    
    func handleCancelRequest() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        guard let UID = uid else {return}
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let FriendsRef = self.Friends.document(UID).collection("Requested").document(userID)
            FriendsRef.delete { (err) in
                if err != nil {
                    print(err!.localizedDescription)
                }
                else {
                    print("Cancelled Friend request")
                }
            }
        }
    
    
    func handleRequestFriend() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        guard let UID = uid else {return}
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let batch = Firestore.firestore().batch()
            
            let FriendsRef = self.Friends.document(UID).collection("Requested").document(userID)

            
            batch.setData([ "Requested": userID ], forDocument: FriendsRef, merge: true)

            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Requested Friend")
                    self.getFriendsCount()
                    }
                }
            }
    
    func CheckIfYouBlockedThem(completion: @escaping(_ result: Bool) -> () ) {
    guard let UID = self.uid else {return}
    guard let uid = Auth.auth().currentUser?.uid else {return}
        let blockedref = Firestore.firestore().collection("Blocked").document(uid).collection("BlockedUsers").document(UID)
        quoteListener3 = blockedref.addSnapshotListener({ (snapshot, error) in
            if let document = snapshot {
                
                if !document.exists {
                    completion(false)
                }
                
                else {
                    completion(true)
                }
            }
        })
    }
        
    
    func handleRemoveFriend() {
        guard let UID = uid else {return}
        guard let userID = Auth.auth().currentUser?.uid else {return}
            
            let batch = Firestore.firestore().batch()
            
            let FriendsRef = self.Friends.document(UID).collection("Accepted").document(userID)
            
            batch.deleteDocument(FriendsRef)
            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Removed Friend")
                    self.getFriendsCount()
                    }
                }
            }

    
func handleFriends() {
    
    areTheyFriends { (result) in
    if result == "Friends" {
        print("Friends")
        self.AddFriendButton.setTitle("Friends", for: .normal)
        self.AddFriendButton.backgroundColor = .blue
        self.AddFriendButton.setTitleColor(.white, for: .normal)
    }
    else if result == "Not Requested" {
        print("Not requested")
        self.AddFriendButton.setTitle("Add friend", for: .normal)
        self.AddFriendButton.backgroundColor = UIColor(red: 0.09, green: 0.64, blue: 0.68, alpha: 1.00)
        self.AddFriendButton.setTitleColor(.white, for: .normal)
    }
        
    else if result == "Requested" {
        print("Requested")
        self.AddFriendButton.setTitle("Requested", for: .normal)
        self.AddFriendButton.backgroundColor = .lightGray
        self.AddFriendButton.setTitleColor(.white, for: .normal)
            }
    else if result == "Blocked" {
        print("Blocked")
        self.AddFriendButton.setTitle("Blocked", for: .normal)
        self.AddFriendButton.backgroundColor = .red
        self.AddFriendButton.setTitleColor(.white, for: .normal)
            }
        }
    }
}
