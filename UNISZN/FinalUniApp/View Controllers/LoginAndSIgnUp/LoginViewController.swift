//
//  LoginViewController.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 03/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var email: UITextField!
    

    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(gesture:)))
        self.email.isUserInteractionEnabled = true
        self.password.isUserInteractionEnabled = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
}
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer){
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    @IBAction func Login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] (user, error) in
           
            guard let StrongSelf = self else {
                return
            }
            guard let result = user, error == nil else {
                self?.Alert("Error")
                return
            }
            
            let user = result.user
            print("logged in \(user)")
            StrongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    func Alert(_ field:String){
    let alertController = UIAlertController(title: "\(field)", message: "Please try again later", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
       }
}

