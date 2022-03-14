//
//  EditProfilePage.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 20/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class EditProfilePage: UIViewController, UITextViewDelegate {
    
    var imagePicked: String?
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = false
        let navigationItem = UINavigationItem()
        navigationItem.title = "Edit Profile"
        let rightButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(UploadEditedData))
        let LeftButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(DismissEditProfile))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = LeftButton
        navigationBar.items = [navigationItem]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        return picker
    }()
    
    lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let standardProfilePic = UIImage(named: "image")
        profileImage.image = standardProfilePic
        //profileImage.layer.cornerRadius = 60
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        return profileImage
    }()
    
    private var changeProfileImage: UIButton = {
        let changeProfileImage = UIButton()
        changeProfileImage.setTitle("Change Profile Picture", for: .normal)
        changeProfileImage.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        changeProfileImage.setTitleColor(.white, for: .normal)
        changeProfileImage.backgroundColor = .systemBlue
        changeProfileImage.layer.cornerRadius = 15
        changeProfileImage.layer.masksToBounds = true
        changeProfileImage.translatesAutoresizingMaskIntoConstraints = false
        changeProfileImage.addTarget(self, action: #selector(ChangeProfileImage), for: .touchUpInside)
        changeProfileImage.isUserInteractionEnabled = true
        changeProfileImage.titleLabel?.adjustsFontSizeToFitWidth = true
        changeProfileImage.titleLabel?.minimumScaleFactor = 0.5
        return changeProfileImage
    }()
    
    private var seperatorLine: UIView = {
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorLineView
    }()
    
    private var FirstNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        nameLabel.text = "First Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        return nameLabel
    }()
    
    private var SurnameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        nameLabel.text = "Last Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        return nameLabel
    }()
    
    private var UsernameLabel: UILabel = {
       let nameLabel = UILabel()
       nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
       nameLabel.text = "Username"
       nameLabel.translatesAutoresizingMaskIntoConstraints = false
       nameLabel.adjustsFontSizeToFitWidth = true
       nameLabel.minimumScaleFactor = 0.5
       return nameLabel
       }()
    
    private var FirstNameTextfield: UITextField = {
        let FirstNameTextfield = UITextField()
        FirstNameTextfield.placeholder = "First Name"
        FirstNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        return FirstNameTextfield
    }()
    
    private var surnameTextfield: UITextField = {
        let surnameTextfield = UITextField()
        surnameTextfield.placeholder = "Last Name"
        surnameTextfield.translatesAutoresizingMaskIntoConstraints = false
        return surnameTextfield
    }()
    
    private var usernameTextfield: UITextField = {
        let usernameTextfield = UITextField()
        usernameTextfield.placeholder = "Username"
        usernameTextfield.translatesAutoresizingMaskIntoConstraints = false
        return usernameTextfield
    }()
    
    private var BioLabel: UILabel = {
        let BioLabel = UILabel()
        BioLabel.translatesAutoresizingMaskIntoConstraints = false
        BioLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        BioLabel.text = "Bio"
        return BioLabel
    }()
    
    private var BioText: UITextView = {
        let Biotext = UITextView()
        Biotext.translatesAutoresizingMaskIntoConstraints = false
        Biotext.layer.borderWidth = 1
        Biotext.layer.borderColor = UIColor.lightGray.cgColor
        Biotext.layer.cornerRadius = 4
        Biotext.layer.masksToBounds = true
        Biotext.isEditable = true
        Biotext.font = UIFont.systemFont(ofSize: 15)
        return Biotext
    }()
    
    private var CharacterCount: UILabel = {
        let CharacterCount = UILabel()
        CharacterCount.translatesAutoresizingMaskIntoConstraints = false
        return CharacterCount
    }()
    
    private var emailLabel: UILabel = {
       let emailLabel = UILabel()
       emailLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
       emailLabel.text = "Email Address"
       emailLabel.translatesAutoresizingMaskIntoConstraints = false
       emailLabel.adjustsFontSizeToFitWidth = true
       emailLabel.minimumScaleFactor = 0.5
       return emailLabel
       }()
    
    private var emailTextfield: UITextField = {
        let emailTextfield = UITextField()
        emailTextfield.placeholder = "Email"
        emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        return emailTextfield
    }()
    
    private var Choose3Images: UILabel = {
       let Choose3Images = UILabel()
       Choose3Images.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
       Choose3Images.text = "Choose 3 Images To Show to Everyone"
       Choose3Images.translatesAutoresizingMaskIntoConstraints = false
       Choose3Images.adjustsFontSizeToFitWidth = true
       Choose3Images.minimumScaleFactor = 0.5
       return Choose3Images
       }()
    
    lazy var threePicStackView: UIStackView = {
        let threePicStackView = UIStackView()
        threePicStackView.axis = NSLayoutConstraint.Axis.horizontal
        threePicStackView.distribution = UIStackView.Distribution.equalSpacing
        threePicStackView.alignment = UIStackView.Alignment.center
        threePicStackView.spacing = 10
        threePicStackView.translatesAutoresizingMaskIntoConstraints = false
        return threePicStackView
    }()
    
    lazy var Picture1: UIImageView = {
        let Picture1 = UIImageView()
        Picture1.image = UIImage(named: "addPhoto")
        Picture1.contentMode = .scaleAspectFill
        Picture1.layer.masksToBounds = true
        Picture1.translatesAutoresizingMaskIntoConstraints = false
        Picture1.isUserInteractionEnabled = true
        Picture1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SelectImage1)))
        return Picture1
    }()
    
    lazy var Picture2: UIImageView = {
        let Picture2 = UIImageView()
        Picture2.image = UIImage(named: "addPhoto")
        Picture2.contentMode = .scaleAspectFill
        Picture2.layer.masksToBounds = true
        Picture2.translatesAutoresizingMaskIntoConstraints = false
        Picture2.isUserInteractionEnabled = true
        Picture2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SelectImage2)))
        return Picture2
    }()
    
    lazy var Picture3: UIImageView = {
        let Picture3 = UIImageView()
        Picture3.image = UIImage(named: "addPhoto")
        Picture3.contentMode = .scaleAspectFill
        Picture3.layer.masksToBounds = true
        Picture3.translatesAutoresizingMaskIntoConstraints = false
        Picture3.isUserInteractionEnabled = true
        Picture3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SelectImage3)))
        return Picture3
    }()
    
    private var seperatorLine2: UIView = {
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorLineView
    }()
    
    private var seperatorLine3: UIView = {
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorLineView
    }()
    
    private var seperatorLine4: UIView = {
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorLineView
    }()
    
    private var seperatorLine5: UIView = {
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorLineView
    }()
    
    private var seperatorLine6: UIView = {
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorLineView
    }()
    
    private var emojiLabel: UILabel = {
       let emojiLabel = UILabel()
       emojiLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
       emojiLabel.text = "Where are you From?"
       emojiLabel.translatesAutoresizingMaskIntoConstraints = false
       emojiLabel.adjustsFontSizeToFitWidth = true
       emojiLabel.minimumScaleFactor = 0.5
       return emojiLabel
       }()
    
    private var emojiTextfield: UITextField = {
        let emojiTextfield = UITextField()
        emojiTextfield.translatesAutoresizingMaskIntoConstraints = false
        emojiTextfield.font = UIFont(name: "AppleColorEmoji", size: 40)
        //let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: emojiTextfield.frame.height))
        //emojiTextfield.leftView = paddingView
        emojiTextfield.textAlignment = .center
        var myMutableStringTitle = NSMutableAttributedString()
        myMutableStringTitle = NSMutableAttributedString(string:"(Flag emoji)", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)]) // Font
        emojiTextfield.attributedPlaceholder = myMutableStringTitle
        //emojiTextfield.leftViewMode = UITextField.ViewMode.always
        return emojiTextfield
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Edit Profile"
        BioText.delegate = self
        setupView()
        getUserInfo()
        scrollView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    let CharacterLimit = 300
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        CharacterCount.text = "\(BioText.text.count) / \(CharacterLimit)"
        let currentText = BioText.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)

        return updatedText.count <= CharacterLimit
    }
    
    override func viewDidLayoutSubviews() {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    func getUserInfo() {
        if let userID = Auth.auth().currentUser?.uid {
        let ref = Firestore.firestore().collection("users").document(userID)
            ref.getDocument { (snapshot, error) in
               if let error = error {
                   print(error.localizedDescription)
               }
               else {
                   if let snapshot = snapshot {
                   let data = snapshot.data()
                   guard let dictionary = data as [String:AnyObject]? else {return}
                   let user = User(dictionary: dictionary)
                   guard let profilepicurl = user.ProfilePicUrl else {return}
                   guard let url = URL(string: profilepicurl) else {return}
                   Nuke.loadImage(with: url, into: self.profileImage)
                   self.FirstNameTextfield.text = user.FirstName
                   self.FirstNameTextfield.text = user.FirstName
                   self.surnameTextfield.text = user.Surname
                   self.usernameTextfield.text = user.username
                   self.emailTextfield.text = Auth.auth().currentUser?.email
                   self.BioText.text = user.BioText
                   self.emojiTextfield.text = user.countryFlag
                   
                   guard let picture1url: String = data?["Picture1"] as? String else {return}
                   guard let url1 = URL(string: picture1url) else {return}
                   Nuke.loadImage(with: url1, into: self.Picture1)
                    
                   guard let picture2url: String = data?["Picture2"] as? String else {return}
                   guard let url2 = URL(string: picture2url) else {return}
                   Nuke.loadImage(with: url2, into: self.Picture2)
                
                   guard let picture3url: String = data?["Picture3"] as? String else {return}
                   guard let url3 = URL(string: picture3url) else {return}
                   Nuke.loadImage(with: url3, into: self.Picture3)

        }}}}
    }
    
    @objc func UploadEditedData() {
        updateUserInfo()
    }

    @objc func DismissEditProfile() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func AlertofError(_ error:String, _ Message:String){
        let alertController = UIAlertController(title: "\(error)", message: "\(Message)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkIfUsernameTaken(username: String, completion: @escaping (_ result:Bool) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docRef = Firestore.firestore().collection("users")
        docRef.whereField("username", isEqualTo: username).getDocuments { (snapshot, err) in
            service.getUsernameFromUID(uid) { (Username) in
                
                if snapshot!.isEmpty || username == Username {
                    completion(false)
                }
                
                else {
                    completion(true)
                    }
                }
            }
        }

    
    func updateUserInfo() {
        self.showSpinner(onView: self.view)
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
            let batch = Firestore.firestore().batch()
            let ref = Firestore.firestore().collection("users").document(userID)
            guard let emoji = emojiTextfield.text else {return}
            let emojidata = ["countryFlag": emoji]
        
        if emoji.containsEmoji == true && emoji.count <= 2 && emoji.count > 0 {
                batch.setData(emojidata, forDocument: ref, merge: true)
            }
                
            else { AlertofError("Uh oh", "Choose up to 2 flag emojis")
                self.removeSpinner()
                return }
        
            guard let username = self.usernameTextfield.text else {return}
            guard let FirstName = self.FirstNameTextfield.text else {return}
            guard let Surname = self.surnameTextfield.text else {return}
            guard let Bio = self.BioText.text else {return}
            
        checkIfUsernameTaken(username: username) { (result) in
            print(result)
            
            if username.isEmpty {
                self.Alert("Username")
                self.removeSpinner()
                return
            }
            
            else if FirstName.isEmpty{
                self.Alert("First name")
                self.removeSpinner()
                return
            }
            
            else if Surname.isEmpty {
                self.Alert("Surname")
                self.removeSpinner()
                return
            }
            
            else if result == true {
                self.AlertofError("Please try again", "This username has been taken")
                self.removeSpinner()
                return
            }
                
            else {
                    let data =
                       ["username": username,
                        "FirstName": FirstName,
                        "Surname": Surname,
                        "BioText": Bio ]
                
                    batch.setData(data, forDocument: ref, merge: true)

                    guard let email = self.emailTextfield.text else {return}
                    Auth.auth().currentUser?.updateEmail(to: email) { error in
                    if let error = error {
                        print(error)
                     } else {return}
                    }
                    

                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        guard let username = self.usernameTextfield.text else {return}
                        changeRequest.displayName = username
                        changeRequest.commitChanges { error in
                         if let error = error {
                            self.removeSpinner()
                            print(error.localizedDescription)
                         } else {
                           print("Added Display Name")
                         }
                       }
                     }
                
                batch.commit() { err in
                    if let err = err {
                        self.removeSpinner()
                        self.AlertofError("Yikes we got an error", err.localizedDescription)
                    } else {
                        print("Batch write succeeded.")
                
                        if self.profilepressed == false {
                            print("not changedp")
                            self.count += 1
                        }
                        else if self.profilepressed == true {
                            print("changedp")
                            self.uploadData(destination: "ProfilePicUrl", image: self.profileImage)
                        }
                        
                        if self.pressed1 == false {
                            print("not changed1")
                            self.count += 1
                        }
                        else if self.pressed1 == true {
                            print("changed1")
                            self.uploadData(destination: "Picture1", image: self.Picture1)
                        }
                        
                        if self.pressed2 == false {
                            print("not changed2")
                            self.count += 1
                        }
                        else if self.pressed2 == true {
                            print("changed2")
                            self.uploadData(destination: "Picture2", image: self.Picture2)
                        }
                        
                        if self.pressed3 == false {
                            print("not changed3")
                            self.count += 1
                        }
                            
                        else if self.pressed3 == true {
                            print("changed3")
                            self.uploadData(destination: "Picture3", image: self.Picture3)
                        }
                            if self.count == 4 {
                                self.removeSpinner()
                                self.dismiss(animated: true) {
                                self.profilepage?.getUserInfo()
                            }
                        }
                    }
                }
                
                
            }
        }
        

    }
    
    func Alert(_ field:String){
       let alertController = UIAlertController(title: "\(field) Needed", message: "Please type in \(field)", preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       self.present(alertController, animated: true, completion: nil)
    }
    
    var profilepressed = false
    var pressed1 = false
    var pressed2 = false
    var pressed3 = false
    
    var count = 0
    
    func uploadData(destination : String, image: UIImageView) {
        guard let uploadData = image.image,
            let data = uploadData.jpegData(compressionQuality: 0.6 )
            else {
            self.removeSpinner()
            showError()
            return }
        
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("ProfilePictures").child(imageName)
            storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                self.removeSpinner()
                self.showError()
                return
                }
                storageRef.downloadURL { (url, error) in
                if error != nil {
                    self.removeSpinner()
                    self.showError()
                    return
                    }
                    guard let urlString = url?.absoluteString else {return}
                    
                        guard let userID = Auth.auth().currentUser?.uid else { return }
                        let docRef = Firestore.firestore().collection("users").document(userID)
                        docRef.updateData([destination: urlString]) { (error) in
                        if let error = error {
                            self.removeSpinner()
                            print(error.localizedDescription)
                        }
                        else {
                            self.count += 1
                            print("uploaded images", self.count)
                            if self.count == 4 {
                                self.removeSpinner()
                                self.dismiss(animated: true) {
                                self.profilepage?.getUserInfo()
                            }
                        }
                    }
                }
            }
        }
    }
    
    weak var profilepage: Profile?

    func setupView() {
        self.view.addSubview(scrollView)
        view.addSubview(navigationBar)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(changeProfileImage)
        scrollView.addSubview(seperatorLine)
        scrollView.addSubview(seperatorLine2)
        scrollView.addSubview(seperatorLine3)
        scrollView.addSubview(seperatorLine4)
        scrollView.addSubview(seperatorLine5)
        scrollView.addSubview(seperatorLine6)
        scrollView.addSubview(FirstNameLabel)
        scrollView.addSubview(SurnameLabel)
        scrollView.addSubview(UsernameLabel)
        scrollView.addSubview(FirstNameTextfield)
        scrollView.addSubview(surnameTextfield)
        scrollView.addSubview(usernameTextfield)
        scrollView.addSubview(BioLabel)
        scrollView.addSubview(BioText)
        scrollView.addSubview(CharacterCount)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailTextfield)
        scrollView.addSubview(Choose3Images)
        scrollView.addSubview(emojiLabel)
        scrollView.addSubview(emojiTextfield)
        threePicStackView.addArrangedSubview(Picture1)
        threePicStackView.addArrangedSubview(Picture2)
        threePicStackView.addArrangedSubview(Picture3)
        scrollView.addSubview(threePicStackView)
        
        
   //Constrain scroll view
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.navigationBar.topAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    //navigationBar constraints
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    
        
    //profileImage constraints
        profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 90).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
    
    //changeprofileImage constraints
        changeProfileImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 50).isActive = true
        changeProfileImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
        changeProfileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        changeProfileImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    //seperatorline constraints
        seperatorLine.topAnchor.constraint(equalTo: changeProfileImage.bottomAnchor, constant: 20).isActive = true
        seperatorLine.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        seperatorLine.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    //FirstNameLabel constraints
        FirstNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30).isActive = true
        FirstNameLabel.topAnchor.constraint(equalTo: seperatorLine.bottomAnchor, constant: 40).isActive = true
        FirstNameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        
    //Surnamelabel constraints
        SurnameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30).isActive = true
        SurnameLabel.topAnchor.constraint(equalTo: FirstNameLabel.bottomAnchor, constant: 40).isActive = true
        SurnameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        
    //UsernameLabel constraints
        UsernameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30).isActive = true
        UsernameLabel.topAnchor.constraint(equalTo: SurnameLabel.bottomAnchor, constant: 40).isActive = true
        UsernameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
    
    //FirstNameTextfield constraints
        FirstNameTextfield.leftAnchor.constraint(equalTo: FirstNameLabel.rightAnchor, constant: 20).isActive = true
        FirstNameTextfield.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        FirstNameTextfield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        FirstNameTextfield.centerYAnchor.constraint(equalTo: FirstNameLabel.centerYAnchor).isActive = true
        
    //surnameTextfield constraints
        surnameTextfield.leftAnchor.constraint(equalTo: SurnameLabel.rightAnchor, constant: 20).isActive = true
        surnameTextfield.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        surnameTextfield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        surnameTextfield.centerYAnchor.constraint(equalTo: SurnameLabel.centerYAnchor).isActive = true
        
    //usernameTextfield constraints
        usernameTextfield.leftAnchor.constraint(equalTo: UsernameLabel.rightAnchor, constant: 20).isActive = true
        usernameTextfield.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        usernameTextfield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usernameTextfield.centerYAnchor.constraint(equalTo: UsernameLabel.centerYAnchor).isActive = true
        
    //emojilabel constraints
        emojiLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30).isActive = true
        emojiLabel.topAnchor.constraint(equalTo: UsernameLabel.bottomAnchor,constant: 40).isActive = true
        emojiLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
        
    //emojitextfield constraints
        emojiTextfield.leftAnchor.constraint(equalTo: emojiLabel.rightAnchor, constant: 20).isActive = true
        emojiTextfield.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        emojiTextfield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emojiTextfield.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor).isActive = true
        
    //seperatorline6 constraints
        seperatorLine6.topAnchor.constraint(equalTo: emojiTextfield.bottomAnchor, constant: 5).isActive = true
        seperatorLine6.widthAnchor.constraint(equalTo: emojiTextfield.widthAnchor).isActive = true
        seperatorLine6.leftAnchor.constraint(equalTo: emojiTextfield.leftAnchor).isActive = true
        seperatorLine6.rightAnchor.constraint(equalTo: emojiTextfield.rightAnchor).isActive = true
        seperatorLine6.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    //BioLabel constraints
        BioLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30).isActive = true
        BioLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 40).isActive = true
        
    //biotext constraints
        BioText.leftAnchor.constraint(equalTo: BioLabel.rightAnchor, constant: 20).isActive = true
        BioText.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        BioText.heightAnchor.constraint(equalToConstant: 150).isActive = true
        BioText.topAnchor.constraint(equalTo: emojiTextfield.bottomAnchor, constant: 30).isActive = true
    
    //CharacterCount constraints
        CharacterCount.rightAnchor.constraint(equalTo: BioText.rightAnchor, constant: -10).isActive = true
        CharacterCount.bottomAnchor.constraint(equalTo: BioText.bottomAnchor).isActive = true
        
    //EmailLabel constraints
        emailLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30).isActive = true
        emailLabel.topAnchor.constraint(equalTo: BioText.bottomAnchor, constant: 40).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3).isActive = true
    
    //EmailTextfield constraints
        emailTextfield.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 20).isActive = true
        emailTextfield.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        emailTextfield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailTextfield.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor).isActive = true

    //Choose3Images constraints
        Choose3Images.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 40).isActive = true
        Choose3Images.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        Choose3Images.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        
    //threePicStackView constraints
        threePicStackView.topAnchor.constraint(equalTo: Choose3Images.bottomAnchor, constant: 20).isActive = true
        threePicStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        //threePicStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
        
        let mult = CGFloat(0.25)
        
    //image1 constraints
        Picture1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: mult).isActive = true
        Picture1.heightAnchor.constraint(equalTo: Picture1.widthAnchor, multiplier: 16/9).isActive = true
           
    //image2 constraints
        Picture2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: mult).isActive = true
        Picture2.heightAnchor.constraint(equalTo: Picture1.widthAnchor, multiplier: 16/9).isActive = true
           
    //image3 constraints
        Picture3.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: mult).isActive = true
        Picture3.heightAnchor.constraint(equalTo: Picture1.widthAnchor, multiplier: 16/9).isActive = true
        
    //seperatorline2 constraints
        seperatorLine2.topAnchor.constraint(equalTo: FirstNameTextfield.bottomAnchor, constant: 5).isActive = true
        seperatorLine2.leftAnchor.constraint(equalTo: FirstNameTextfield.leftAnchor).isActive = true
        seperatorLine2.rightAnchor.constraint(equalTo: FirstNameTextfield.rightAnchor).isActive = true
        seperatorLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    //seperatorline3 constraints
       seperatorLine3.topAnchor.constraint(equalTo: surnameTextfield.bottomAnchor, constant: 5).isActive = true
       seperatorLine3.leftAnchor.constraint(equalTo: surnameTextfield.leftAnchor).isActive = true
       seperatorLine3.rightAnchor.constraint(equalTo: surnameTextfield.rightAnchor).isActive = true
       seperatorLine3.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    //seperatorline4 constraints
       seperatorLine4.topAnchor.constraint(equalTo: usernameTextfield.bottomAnchor, constant: 5).isActive = true
       seperatorLine4.leftAnchor.constraint(equalTo: usernameTextfield.leftAnchor).isActive = true
       seperatorLine4.rightAnchor.constraint(equalTo: usernameTextfield.rightAnchor).isActive = true
       seperatorLine4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    
    //seperatorline5 constraints
       seperatorLine5.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 20).isActive = true
       seperatorLine5.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
       seperatorLine5.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 60).isActive = true
       seperatorLine5.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -60).isActive = true
       seperatorLine5.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    }
}

extension String {

    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F1E6...0x1F1FF, // Flags
                 0x1F3f4: //england scotland wales
                return true
            default:
                continue
            }
        }
        return false
    }

}


var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

extension UIImage {

    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }

}
