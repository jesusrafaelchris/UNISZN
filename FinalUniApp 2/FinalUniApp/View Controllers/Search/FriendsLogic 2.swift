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
    
    func areTheyFriends(completion: @escaping(_ result:Bool) -> () ) {
        
        service.getUIDFromUsername(username!) { (uid) in
        if Auth.auth().currentUser != nil {
        let userID = Auth.auth().currentUser?.uid
        let FriendsRef = self.Friends.document(userID!)
            
        self.quoteListener = FriendsRef.addSnapshotListener { (snapshot, error) in
        if let document = snapshot , document.exists {
        guard let data = snapshot?.data() else {return}
            
        var result = data["\(uid)"] as? Bool
            
          if result == true {
            completion(result!)
          }
          else {
              result = false
            completion(result!)
        }
        }
        else {
        //print("doesnt exist")
            completion(false)
    }}}}
        
    }

    @objc func AddFriend() {
        if AddFriendButton.titleLabel?.text == "Friends" {
            //print("Already Friends")
            handleRemoveFriend()
        }
        else {
            handleAddFriend()
        }
    }
    
    func handleAddFriend() {
            service.getUIDFromUsername(username!) { (uid) in
            print(uid) // person youre requesting
        if Auth.auth().currentUser != nil // || alreadyfriends = false
        {
            let userID = Auth.auth().currentUser?.uid // you
            
            let batch = Firestore.firestore().batch()
            let FriendsRef1 = self.Friends.document(uid)
            let FriendsRef2 = self.Friends.document(userID!)
            
            batch.setData([userID! as String: true], forDocument: FriendsRef1, merge: true)
            batch.setData([uid as String: true], forDocument: FriendsRef2, merge: true)
            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                    self.getFriendsCount()
                    }
                }
            }
        }
    }
    
    func handleRemoveFriend() {
            service.getUIDFromUsername(username!) { (uid) in
        if Auth.auth().currentUser != nil {
            
            let userID = Auth.auth().currentUser?.uid
            let batch = Firestore.firestore().batch()
            let FriendsRef1 = self.Friends.document(uid)
            let FriendsRef2 = self.Friends.document(userID!)
            
            batch.updateData([userID: FieldValue.delete()], forDocument: FriendsRef1)
            batch.updateData([uid: FieldValue.delete()], forDocument: FriendsRef2)
            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                    self.getFriendsCount()
                    }
                }
            }
        }
    }
    
    
func handleFriends() {
    areTheyFriends { (result) in
    if result == true {
        //print("TRUE")
        self.AddFriendButton.setTitle("Friends", for: .normal)
        self.AddFriendButton.backgroundColor = .blue
        self.AddFriendButton.setTitleColor(.white, for: .normal)
    }
    else if result == false {
        //print("FALSE")
        self.AddFriendButton.setTitle("Add friend", for: .normal)
        self.AddFriendButton.backgroundColor = .lightGray
        self.AddFriendButton.setTitleColor(.white, for: .normal)
        
        }
    }
    }
    
    
    
    
}
