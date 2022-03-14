//
//  MainViewController.swift
//  GroupTesting
//
//  Created by Christian Grinling on 08/08/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase

class ChangePeoplesCourses: UIViewController {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Input Course Then Input UID"
        label.textColor = .white
        return label
    }()
    
    let uidtextfield: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 19
        textfield.layer.masksToBounds = true
        textfield.placeholder = "Course"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let coursetextfield: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 19
        textfield.layer.masksToBounds = true
        textfield.placeholder = "UID"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let Unitextfield: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 19
        textfield.layer.masksToBounds = true
        textfield.placeholder = "University"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let submitbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(submitInfo(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.21, green: 0.46, blue: 0.53, alpha: 1.00)
        setupViews()
        getPendingAttentionPeople()
    }
    
    @objc func submitInfo(_ sender: Any) {
        changeCourse()
    }
    
    func getPendingAttentionPeople() {
        let userRef = Firestore.firestore().collection("users").whereField("Course", isEqualTo: "Pending Addition")
        userRef.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                guard let uid = data["uid"] else {return}
                guard let University = data["University"] else {return}
                guard let username = data["username"] else {return}
                print(username,University,uid)
            }
        }
    }
    
    func changeCourse() {

        guard let UID = coursetextfield.text else {return}
        guard let Course = uidtextfield.text else {return}
        guard let University = Unitextfield.text else {return}
        let batch = Firestore.firestore().batch()
    
        let userref = Firestore.firestore().collection("users").document(UID)
        batch.updateData(["Course": Course], forDocument: userref)
        
        let UserCoursesRef = Firestore.firestore().collection("User-Courses").document("Pending Addition")
        batch.updateData([UID: FieldValue.delete()], forDocument: UserCoursesRef)
        
        let UserCoursesRef2 = Firestore.firestore().collection("User-Courses").document(Course)
        batch.setData([UID: true], forDocument: UserCoursesRef2, merge: true)
        
        let UniversitiesRef = Firestore.firestore().collection("Universities").document(University).collection("Pending Addition").document(UID)
        batch.deleteDocument(UniversitiesRef)
        
        let UniversitiesRef2 = Firestore.firestore().collection("Universities").document(University).collection(Course).document(UID)
        batch.setData([UID: true], forDocument: UniversitiesRef2, merge: true)
        
        batch.commit { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            else {
                print("Success")
            }
        }
    }
    
    
    func setupViews() {
        
        view.addSubview(label)
        view.addSubview(uidtextfield)
        view.addSubview(coursetextfield)
        view.addSubview(Unitextfield)
        view.addSubview(submitbutton)
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            uidtextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            uidtextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            uidtextfield.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            uidtextfield.heightAnchor.constraint(equalToConstant: 38),
            
            Unitextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            Unitextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            Unitextfield.topAnchor.constraint(equalTo: uidtextfield.bottomAnchor, constant: 30),
            Unitextfield.heightAnchor.constraint(equalToConstant: 38),
            
            //password textfield constraints
            coursetextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            coursetextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            coursetextfield.topAnchor.constraint(equalTo: Unitextfield.bottomAnchor, constant: 30),
            coursetextfield.heightAnchor.constraint(equalToConstant: 38),
            
            submitbutton.topAnchor.constraint(equalTo: coursetextfield.bottomAnchor, constant: 30),
            submitbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitbutton.widthAnchor.constraint(equalToConstant: 110),
            submitbutton.heightAnchor.constraint(equalToConstant: 40),
        ])

        
    }

}
