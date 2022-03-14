//
//  temporary code nameusername.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import Foundation
/*//
//  UsernameUniCourse.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 04/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class UsernameUniCourse: UIViewController {

    
    let docRef: CollectionReference = Firestore.firestore().collection("users")
    var quoteListener: ListenerRegistration!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var University: UITextField!
    
    @IBOutlet weak var Course: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DisplayCourse()
        DisplayUni()
    }
    

    @IBAction func Confirm(_ sender: Any) {
         if  ((username.text?.isEmpty) ?? true)  {
            Alert("Username")}
         else {
            ConfirmUsernameAndUID()
        self.performSegue(withIdentifier: "UsernametoProfilePic", sender: self)
        }
        
    }
    
    func ConfirmUsernameAndUID(){
     
        if Auth.auth().currentUser != nil {
        guard let userID = Auth.auth().currentUser?.uid else { return }
            let UID:[String:Any] = ["uid": userID]
            let Username:[String:Any] = ["username": self.username.text!]
            docRef.document(userID).setData(Username, merge: true)
            docRef.document(userID).setData(UID, merge: true)
            
    }
    }


    @IBAction func ShowUnis(_ sender: Any) {
        self.performSegue(withIdentifier: "Unis", sender: self)
    }
    
    
    
    @IBAction func ShowCourses(_ sender: Any) {
        
            self.performSegue(withIdentifier: "Courses", sender: self)
        
    }
    
    
    func DisplayUni(){
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let listener = docRef.document(userID)
            quoteListener = listener.addSnapshotListener { (DocumentSnapshot, error) in
                let Data = DocumentSnapshot?.data()
                let University = Data?["University"] as? String? ?? ""
                self.University.text = University
        }
    }
    
    func DisplayCourse(){
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let listener = docRef.document(userID)
            quoteListener = listener.addSnapshotListener { (DocumentSnapshot, error) in
                let Data = DocumentSnapshot?.data()
                let Course = Data?["Course"] as? String? ?? ""
                self.Course.text = Course
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        quoteListener.remove()
    }
    
    func Alert(_ field:String){
           let alertController = UIAlertController(title: "\(field) Needed", message: "Please type in \(field)", preferredStyle: .alert)
                      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                      alertController.addAction(defaultAction)
                      self.present(alertController, animated: true, completion: nil)
       }
}


*/
