//
//  UsernameUniCourse.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 04/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import AnimatedGradientView

class NameAndUsername: UIViewController {

    let docRef = Firestore.firestore().collection("users")
    
     private let LogoImage: UIImageView = {
          let Image = UIImage(named: "logo")
          let image = UIImageView(image: Image)
          image.contentMode = .scaleAspectFill
          image.translatesAutoresizingMaskIntoConstraints = false
          return image
      }()
      
      private let Signuplabel: UILabel = {
          let Signuplabel = UILabel()
          Signuplabel.text = "Name"
          Signuplabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
          Signuplabel.textColor = .white
          Signuplabel.translatesAutoresizingMaskIntoConstraints = false
          return Signuplabel
      }()
      
      private let FirstNameField: UITextField = {
          let FirstNameField = UITextField()
          FirstNameField.backgroundColor = .white
          FirstNameField.placeholder = "First Name"
          FirstNameField.layer.cornerRadius = 19
          FirstNameField.layer.masksToBounds = true
          let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: FirstNameField.frame.height))
          FirstNameField.leftView = paddingView
          FirstNameField.leftViewMode = UITextField.ViewMode.always
          FirstNameField.autocapitalizationType = .none
          FirstNameField.translatesAutoresizingMaskIntoConstraints = false
          return FirstNameField
      }()
      
      private let SurnameField: UITextField = {
          let SurnameField = UITextField()
          SurnameField.backgroundColor = .white
          SurnameField.placeholder = "Last Name"
          SurnameField.layer.cornerRadius = 19
          SurnameField.layer.masksToBounds = true
          let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: SurnameField.frame.height))
          SurnameField.leftView = paddingView
          SurnameField.leftViewMode = UITextField.ViewMode.always
          SurnameField.autocapitalizationType = .none
          SurnameField.translatesAutoresizingMaskIntoConstraints = false
           return SurnameField
       }()
      
      private let UsernameField: UITextField = {
         let UsernameField = UITextField()
         UsernameField.backgroundColor = .white
         UsernameField.placeholder = "Username"
         UsernameField.layer.cornerRadius = 19
         UsernameField.layer.masksToBounds = true
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: UsernameField.frame.height))
         UsernameField.leftView = paddingView
         UsernameField.leftViewMode = UITextField.ViewMode.always
         UsernameField.autocapitalizationType = .none
         UsernameField.translatesAutoresizingMaskIntoConstraints = false
          return UsernameField
          }()
      
      private let nextButton: UIButton = {
          let nextButton = UIButton()
          nextButton.setTitle("NEXT", for: .normal)
          nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
          nextButton.setTitleColor(.systemBlue, for: .normal)
          nextButton.backgroundColor = .white
          nextButton.layer.cornerRadius = 20
          nextButton.layer.masksToBounds = true
          nextButton.translatesAutoresizingMaskIntoConstraints = false
          return nextButton
      }()
    
      override func viewDidLoad() {
          super.viewDidLoad()
          self.view.backgroundColor = UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
          self.navigationController?.isNavigationBarHidden = false
          self.UsernameField.delegate = self
          setupnavigationbar()
          addsubviews()
          setupgestures()
          setupView()
        
      }
    
    lazy var gradient: AnimatedGradientView = {
      let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.direction = .up
        animatedGradient.animationDuration = 2
        animatedGradient.animationValues = [(colors: ["#367588", "#16A4AE"], .up, .axial),
        (colors: ["#16A4AE"], .right, .axial),
        (colors: ["#367588"], .down, .axial),
        (colors: ["#16A4AE"], .left, .axial)]
        return animatedGradient
    }()
      
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
      }
      
      @objc func dismissKeyboard(gesture: UITapGestureRecognizer){
          FirstNameField.resignFirstResponder()
          SurnameField.resignFirstResponder()
          UsernameField.resignFirstResponder()
      }
      
      @objc func nextPage() {
          ConfirmNames()
          //let uniAndCourse = UniAndCourse()
          //self.navigationController?.pushViewController(uniAndCourse, animated: true)

      }
      
      func setupnavigationbar() {
          self.navigationController?.navigationBar.tintColor = .white
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
      }
      
      func setupgestures() {
          let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(gesture:)))
          self.FirstNameField.isUserInteractionEnabled = true
          self.SurnameField.isUserInteractionEnabled = true
          self.UsernameField.isUserInteractionEnabled = true
          tapGestureRecognizer.numberOfTapsRequired = 1
          self.view.addGestureRecognizer(tapGestureRecognizer)
          nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
          
      }
      
      func addsubviews() {
          view.addSubview(gradient)
          gradient.addSubview(LogoImage)
          gradient.addSubview(Signuplabel)
          gradient.addSubview(FirstNameField)
          gradient.addSubview(SurnameField)
          gradient.addSubview(UsernameField)
          gradient.addSubview(nextButton)
      }
      
      
func setupView() {
          
      let betweentextfieldsconstant = CGFloat(40)
      //Logo Image Constraints
      LogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      LogoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
      LogoImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
      LogoImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
      LogoImage.heightAnchor.constraint(equalTo: LogoImage.widthAnchor).isActive = true

     // LoginText constraints
      Signuplabel.topAnchor.constraint(equalTo: LogoImage.bottomAnchor, constant: -40).isActive = true
      Signuplabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
      Signuplabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
      Signuplabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
          
     //email textinput constraints
      FirstNameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
      FirstNameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
      FirstNameField.topAnchor.constraint(equalTo: Signuplabel.bottomAnchor, constant: 40).isActive = true
      FirstNameField.heightAnchor.constraint(equalToConstant: 38).isActive = true
     
     //password textfield constraints
      SurnameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
      SurnameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
      SurnameField.topAnchor.constraint(equalTo: FirstNameField.bottomAnchor, constant: betweentextfieldsconstant).isActive = true
      SurnameField.heightAnchor.constraint(equalToConstant: 38).isActive = true
          
     //retypepassword textfield constraints
      UsernameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
      UsernameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
      UsernameField.topAnchor.constraint(equalTo: SurnameField.bottomAnchor, constant: betweentextfieldsconstant).isActive = true
      UsernameField.heightAnchor.constraint(equalToConstant: 38).isActive = true
          
     //login button constraints
      nextButton.topAnchor.constraint(equalTo: UsernameField.bottomAnchor, constant: 50).isActive = true
      nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
      nextButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
      nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
          
      }


    func AlertofError(_ error:String, _ Message:String){
        let alertController = UIAlertController(title: "\(error)", message: "\(Message)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func Alert(_ field:String){
       let alertController = UIAlertController(title: "\(field) Needed", message: "Please type in \(field)", preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       self.present(alertController, animated: true, completion: nil)
    }
    
    func ConfirmNames() {
    guard let userame = UsernameField.text else {return}
    checkIfUsernameTaken(username: userame) { (result) in
        if self.FirstNameField.text?.isEmpty ?? true {
            self.Alert("First name")
        }
        if self.SurnameField.text?.isEmpty ?? true {
            self.Alert("Surname")
               }
        if self.UsernameField.text?.isEmpty ?? true {
            self.Alert("Username")
        }
        
        if result == false {
            self.AlertofError("Please try again", "This username has been taken")
        }
        
        else if Auth.auth().currentUser != nil {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let data: [String: Any] = ["FirstName": self.FirstNameField.text!, "Surname":self.SurnameField.text!, "username": self.UsernameField.text!, "uid": userID, "ProfilePicUrl": "https://firebasestorage.googleapis.com/v0/b/finaluniapp.appspot.com/o/ProfilePictures%2Fprofilepicset.jpg?alt=media&token=c0039310-c5f7-4b82-823a-e88d259e4117", "Created": FieldValue.serverTimestamp()]
            
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()

                changeRequest.displayName = self.UsernameField.text
                changeRequest.commitChanges { error in
                 if let error = error {
                    print(error.localizedDescription)
                 } else {
                   print("Added Display Name")
                 }
               }
             }
            
            InstanceID.instanceID().instanceID { (result, error) in
              if let error = error {
                print("Error fetching remote instance ID: \(error)")
              } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.docRef.document(userID).setData(["NotificationToken": result.token], merge: true)
              }
            } 
            
            self.docRef.document(userID).setData(data, merge: true)
            let uniAndCourse = UniAndCourse()
            self.navigationController?.pushViewController(uniAndCourse, animated: true)
        }
    }
}
    
    func checkIfUsernameTaken(username: String, completion: @escaping (_ result:Bool) -> ()){
        docRef.whereField("username", isEqualTo: username).getDocuments { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            if !snapshot!.isEmpty {
                    completion(false)
            }
                else {
                    completion(true)
                }
        }
    }
}


extension NameAndUsername: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextPage()
        return true
    }
}
