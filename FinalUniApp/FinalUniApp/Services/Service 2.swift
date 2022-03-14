//
//  Service.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 05/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class service {
    

    static func loadCourse(completion: @escaping (_ field:String) -> ()) {
    if Auth.auth().currentUser != nil {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection("users").document(userID)
        docRef.getDocument { (snapshot, error) in
            if let error = error {
           print(error.localizedDescription)
       } else {
           if let snapshot = snapshot {
           guard let data = snapshot.data() else {return}
            let course = data["Course"] as? String ?? ""
            completion(course)
            }
        }
    }
        }
    }
    
    static func loadPictures(completion: @escaping (_ picture1:String, _ picture2: String,  _ picture3: String ) -> ()) {
    if Auth.auth().currentUser != nil {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection("users").document(userID)
        docRef.getDocument { (snapshot, error) in
            if let error = error {
           print(error.localizedDescription)
       } else {
           if let snapshot = snapshot {
           guard let data = snapshot.data() else {return}
            let picture1 = data["Picture1"] as? String ?? ""
            let picture2 = data["Picture2"] as? String ?? ""
            let picture3 = data["Picture3"] as? String ?? ""
            completion(picture1, picture2, picture3)
            }
        }
    }
        }
    }
    
    
    static func loadUniversityAndCourse(completion: @escaping (_ uni:String, _ course: String) -> ()) {
    if Auth.auth().currentUser != nil {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection("users").document(userID)
        docRef.getDocument { (snapshot, error) in
            if let error = error {
           print(error.localizedDescription)
       } else {
           if let snapshot = snapshot {
            guard let data = snapshot.data() else {return}
            let uni = data["University"] as? String ?? ""
            let course = data["Course"] as? String ?? ""
            completion(uni, course)
            }
        }
    }
        }
    }
    
    
    static func loadUsername(completion: @escaping (_ field:String) -> ()) {
    if Auth.auth().currentUser != nil {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection("users").document(userID)
        let quoteListener = docRef.addSnapshotListener { (DocumentSnapshot, error) in
            let data = DocumentSnapshot?.data()
            let username = data?["username"] as? String ?? ""
            completion(username)
            }
        }
    }
    
    static func loadProfilePic(userID: String, completion: @escaping (_ field: URL) -> ()) {
    if Auth.auth().currentUser != nil {
        let docRef = Firestore.firestore().collection("users").document(userID)
        let quoteListener = docRef.addSnapshotListener { (DocumentSnapshot, error) in
            let data = DocumentSnapshot?.data()
            let Link = data?["ProfilePicUrl"] as? String ?? ""
            guard let url = URL(string: Link) else {
                return
            }
            completion(url)
            }
        }
    }
    
    static func getUsernameFromUID(_ UID:String, completion: @escaping (_ field:String) -> ()) {
        let docRef = Firestore.firestore().collection("users").document(UID)
        let quoteListener = docRef.addSnapshotListener { (DocumentSnapshot, error) in
            let data = DocumentSnapshot?.data()
            let username = data?["username"] as? String ?? ""
            completion(username)
            
        }
    }
    
    static func getUIDFromUsername(_ username:String, completion: @escaping (_ field:String) -> ()) {
        let docRef = Firestore.firestore().collection("users")
        docRef.whereField("username", isEqualTo: username)
                   .getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                        for document in querySnapshot!.documents {
                        let data = document.data()
                        let uid = data["uid"] as? String ?? ""
                        completion(uid)
            
        }
    }
    
        }
    }
    
    static func getprofilepicfromusername(_ username:String, completion: @escaping (_ url:URL) -> ()) {
        let docRef = Firestore.firestore().collection("users")
        docRef.whereField("username", isEqualTo: username)
                   .getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                        for document in querySnapshot!.documents {
                        let data = document.data()
                        let pic = data["ProfilePicUrl"] as! String
                        guard let url = URL(string: pic) else {return }
                        completion(url)
            
        }
    }
    
        }
    }
    
}
