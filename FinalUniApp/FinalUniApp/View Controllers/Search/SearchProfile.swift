//
//  SearchProfile.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 21/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class SearchProfile: UIViewController {

    var uid: String?
    var quoteListener: ListenerRegistration?
    var quoteListener2: ListenerRegistration?
    var quoteListener3: ListenerRegistration?
    var listener: ListenerRegistration?
    var result: Bool = false
    var picturesArray = [String]()
    let Friends = Firestore.firestore().collection("Friends")
    var pressed = false

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.layer.masksToBounds = true
        return imageView
    }()

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()

    lazy var usernameField: UILabel = {
        let usernameField = UILabel()
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        usernameField.adjustsFontSizeToFitWidth = true
        usernameField.minimumScaleFactor = 0.5
        usernameField.textAlignment = .center
        return usernameField
    }()

    lazy var courseImageView: UIImageView = {
        let courseImageView = UIImageView()
        courseImageView.image = UIImage(named: "course")
        courseImageView.contentMode = .scaleAspectFill
        courseImageView.translatesAutoresizingMaskIntoConstraints = false
        return courseImageView
    }()

    lazy var CourseText: UILabel = {
        let CourseText = UILabel()
        CourseText.translatesAutoresizingMaskIntoConstraints = false
        CourseText.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        CourseText.adjustsFontSizeToFitWidth = true
        CourseText.minimumScaleFactor = 0.5
        CourseText.textAlignment = .center
        CourseText.lineBreakMode = .byWordWrapping
        CourseText.numberOfLines = 0
        return CourseText
    }()

    lazy var UniImageView: UIImageView = {
        let UniImageView = UIImageView()
        UniImageView.image = UIImage(named: "uni")
        UniImageView.contentMode = .scaleAspectFill
        UniImageView.translatesAutoresizingMaskIntoConstraints = false
        return UniImageView
    }()

    lazy var UniversityText: UILabel = {
        let UniversityText = UILabel()
        UniversityText.translatesAutoresizingMaskIntoConstraints = false
        UniversityText.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        UniversityText.adjustsFontSizeToFitWidth = true
        UniversityText.minimumScaleFactor = 0.5
        UniversityText.textAlignment = .center
        UniversityText.lineBreakMode = .byWordWrapping
        UniversityText.numberOfLines = 0
        return UniversityText
    }()

    lazy var FriendsImageView: UIImageView = {
        let FriendsImageView = UIImageView()
        FriendsImageView.image = UIImage(systemName: "person.2.fill")
        FriendsImageView.contentMode = .scaleAspectFit
        FriendsImageView.isUserInteractionEnabled = true
        FriendsImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFriendsList)))
        FriendsImageView.translatesAutoresizingMaskIntoConstraints = false
        FriendsImageView.tintColor = .black
        return FriendsImageView
    }()

    lazy var FriendsText: UILabel = {
        let FriendsText = UILabel()
        FriendsText.translatesAutoresizingMaskIntoConstraints = false
        FriendsText.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        FriendsText.adjustsFontSizeToFitWidth = true
        FriendsText.minimumScaleFactor = 0.5
        //FriendsText.text = "0"
        return FriendsText
    }()

    lazy var StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = view.frame.width/9
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var BioText: UILabel = {
        let BioText = UILabel()
        BioText.translatesAutoresizingMaskIntoConstraints = false
        BioText.sizeToFit()
        BioText.layoutIfNeeded()
        BioText.numberOfLines = 0
        BioText.font = UIFont.systemFont(ofSize: 14)
        return BioText
    }()
    
    lazy var countryFlag: UILabel = {
        let countryFlag = UILabel()
        countryFlag.translatesAutoresizingMaskIntoConstraints = false
        countryFlag.font = UIFont(name: "AppleColorEmoji", size: 40)
        countryFlag.adjustsFontSizeToFitWidth = true
        countryFlag.minimumScaleFactor = 0.5
        countryFlag.textAlignment = .center
        return countryFlag
    }()

    lazy var AddFriendButton: UIButton = {
        let AddFriendButton = UIButton()
        AddFriendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        AddFriendButton.setTitleColor(.white, for: .normal)
        AddFriendButton.backgroundColor = .clear
        AddFriendButton.layer.cornerRadius = 15
        AddFriendButton.layer.masksToBounds = true
        AddFriendButton.translatesAutoresizingMaskIntoConstraints = false
        AddFriendButton.addTarget(self, action: #selector(AddFriend), for: .touchUpInside)
        AddFriendButton.isUserInteractionEnabled = true
        return AddFriendButton
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ProfileImagecell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
        layout.scrollDirection = .vertical
        return layout
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        quoteListener?.remove()
        quoteListener2?.remove()
        quoteListener3?.remove()
        listener?.remove()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setupnavigationbar()
    }
    
    var button = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        CheckIfBlocked()
        setupView()
        getFriendsCount()
        getUserInfo()
        handleFriends()
        self.definesPresentationContext = true
        if uid == Auth.auth().currentUser?.uid {
            self.AddFriendButton.isHidden = true
        }
        let requests = UIImage(systemName: "ellipsis.circle.fill")
        let blackrequests = requests?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button = UIBarButtonItem(image: blackrequests, style: .done, target: self, action: #selector(BringUpActionSheet))
        self.navigationItem.rightBarButtonItem = button
    }

    @objc func showFriendsList() {
        let friendslist = SearchFriendsList()
        friendslist.uid = uid
        self.navigationController?.pushViewController(friendslist, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size

    }

    func setupView() {

       view.addSubview(scrollView)
       scrollView.addSubview(imageView)
       scrollView.addSubview(containerView)
       containerView.addSubview(usernameField)
       StackView.addArrangedSubview(UniImageView)
       StackView.addArrangedSubview(courseImageView)
       StackView.addArrangedSubview(FriendsImageView)
       containerView.addSubview(StackView)
       containerView.addSubview(UniversityText)
       containerView.addSubview(CourseText)
       containerView.addSubview(FriendsText)
       containerView.addSubview(BioText)
       containerView.addSubview(countryFlag)
       containerView.addSubview(collectionView)
       containerView.addSubview(AddFriendButton)

   //imageView constraints
       imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
       imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
       imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
       imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2).isActive = true

   //scrollview constraints
       scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
       scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       
   //containerview constraints
       //containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
       containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant:  -15).isActive = true
       containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
       containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
       containerView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20).isActive = true
      

   //constrain UsernameField
       usernameField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
       //usernameField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
       usernameField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
       usernameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
       usernameField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.45).isActive = true
       
   //constrain countryFlag

        countryFlag.leftAnchor.constraint(equalTo: usernameField.rightAnchor, constant: 3).isActive = true
        countryFlag.centerYAnchor.constraint(equalTo: usernameField.centerYAnchor).isActive = true
        countryFlag.rightAnchor.constraint(equalTo: AddFriendButton.leftAnchor, constant: -3).isActive = true
        countryFlag.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true

   //courseImageView constraints
       courseImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
       courseImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
       
   //CourseText constraints
       CourseText.topAnchor.constraint(equalTo: StackView.bottomAnchor, constant: 10).isActive = true
       CourseText.centerXAnchor.constraint(equalTo: courseImageView.centerXAnchor).isActive = true
       CourseText.widthAnchor.constraint(equalTo: StackView.widthAnchor, multiplier: 1/3).isActive = true

   //UniImageView constraints
       UniImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
       UniImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
       
   //UniversityText constraints
       UniversityText.topAnchor.constraint(equalTo: StackView.bottomAnchor, constant: 10).isActive = true
       UniversityText.centerXAnchor.constraint(equalTo: UniImageView.centerXAnchor).isActive = true
       UniversityText.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 3).isActive = true
       UniversityText.widthAnchor.constraint(equalTo: StackView.widthAnchor, multiplier: 1/3).isActive = true
       
   //FriendsText constraints
       FriendsText.topAnchor.constraint(equalTo: StackView.bottomAnchor, constant: 10).isActive = true
       FriendsText.centerXAnchor.constraint(equalTo: FriendsImageView.centerXAnchor).isActive = true

   //stackviewconstraints
       StackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
       StackView.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10).isActive = true
       
   //BioText constraints
       BioText.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
       BioText.topAnchor.constraint(equalTo: CourseText.bottomAnchor, constant: 30).isActive = true
       BioText.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -40).isActive = true
       
   //collectionView constraints
       collectionView.topAnchor.constraint(equalTo: BioText.bottomAnchor, constant: 20).isActive = true
       collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
       collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
       collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1/3).isActive = true
       //collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30).isActive = true
       
    //FriendsImageView constraints
        FriendsImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        FriendsImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true

    //FriendsText constraints
        FriendsText.topAnchor.constraint(equalTo: StackView.bottomAnchor, constant: 10).isActive = true
        FriendsText.centerXAnchor.constraint(equalTo: FriendsImageView.centerXAnchor).isActive = true
        
    //friedsbutton constraints
        self.AddFriendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.AddFriendButton.centerYAnchor.constraint(equalTo: self.usernameField.centerYAnchor).isActive = true
        self.AddFriendButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -5).isActive = true

    }

    func getUserInfo() {
        guard let UID = uid else {return}
        let ref = Firestore.firestore().collection("users").document(UID)
          ref.getDocument { (snapshot, error) in
          if let error = error {
              print(error.localizedDescription)
          }
          else {
              if let snapshot = snapshot {
              let data = snapshot.data()
              guard let dictionary = data as [String:AnyObject]? else {return}
              let user = User(dictionary: dictionary)
              if let Firstname = user.FirstName, let Surname = user.Surname {
              self.usernameField.text = "\(String(describing: Firstname)) \(String(describing: Surname))"
              }
               guard let url = URL(string: user.ProfilePicUrl!) else{return}
               Nuke.loadImage(with: url, into: self.imageView)
               self.UniversityText.text = user.University
               self.CourseText.text = user.Course
               self.BioText.text = user.BioText
               guard let picture1 = user.Picture1 else {return}
               guard let picture2 = user.Picture2 else {return}
               guard let picture3 = user.Picture3 else {return}
               self.picturesArray.append(contentsOf: [picture1,picture2,picture3])
               DispatchQueue.main.async {
                self.collectionView.reloadData()
               }
               if self.countryFlag.text != nil || user.countryFlag != nil {
                   self.countryFlag.text = user.countryFlag
               }
               else {
                  // print("no emoji")
                
                }
   }}}
}
    
    func setupnavigationbar() {
        let backBarButtton = UIBarButtonItem(title: "Back", style: .plain , target: nil, action: nil)
        self.navigationController?.navigationItem.backBarButtonItem = backBarButtton
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func getFriendsCount() {
        guard let UID = uid else {return}
        let friendsRef = Firestore.firestore().collection("Friends").document(UID).collection("Accepted")
        listener = friendsRef.addSnapshotListener({ (document, error) in
        guard let friends = document?.count else {return}
        self.FriendsText.text = "\(friends)"
        })
    }
}


extension SearchProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProfileImagecell
        let image = picturesArray[indexPath.row]
        if let url = URL(string: image) {
            Nuke.loadImage(with: url, into: cell.imageView)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)

        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = picturesArray[indexPath.row]
        let zoom = zoomedPhoto()
        zoom.image = image
        zoom.modalTransitionStyle = .crossDissolve
        navigationController?.present(zoom, animated: true, completion: nil)
        
    }
    
}

extension SearchProfile {
    
    @objc func BringUpActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let ReportAction = UIAlertAction(title: "Report User", style: .default) { (action) in
            self.reportuser()
        }
        let BlockAction = UIAlertAction(title: "Block User", style: .destructive) { (action) in
            self.blockuser()
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancelled")
        }
            
        optionMenu.addAction(ReportAction)
        optionMenu.addAction(BlockAction)
        optionMenu.addAction(cancelAction)
            

        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @objc func blockuser() {
        self.showSpinner(onView: self.view)
        guard let UID = self.uid else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let batch = Firestore.firestore().batch()
        let blockedref = Firestore.firestore().collection("Blocked").document(uid).collection("BlockedUsers").document(UID)
        
        let data = [UID : true]
        batch.setData(data, forDocument: blockedref)
        
        let friendsRef1 = Firestore.firestore().collection("Friends").document(uid).collection("Accepted").document(UID)
        
        let friendsRef2 = Firestore.firestore().collection("Friends").document(UID).collection("Accepted").document(uid)
        
        let latestmessageRef1 = Firestore.firestore().collection("Latest-Messages").document(uid).collection("Latest").document(UID)
        
        let latestmessageRef2 = Firestore.firestore().collection("Latest-Messages").document(UID).collection("Latest").document(uid)
        
        batch.deleteDocument(friendsRef1)
        batch.deleteDocument(friendsRef2)
        batch.deleteDocument(latestmessageRef1)
        batch.deleteDocument(latestmessageRef2)
        
        batch.commit { (error) in
            self.removeSpinner()
            self.Alert("Thank You", "This user has been blocked.")       }
    }
    
    
    func CheckIfBlocked() {
    guard let UID = self.uid else {return}
    guard let uid = Auth.auth().currentUser?.uid else {return}
        let blockedref = Firestore.firestore().collection("Blocked").document(UID).collection("BlockedUsers").document(uid)
        blockedref.getDocument { (snapshot, error) in
            guard let document = snapshot else {return}
            if document.exists {
                print("Blocked")
                self.navigationController?.navigationBar.tintColor = .systemBlue
                self.imageView.isHidden = true
                self.UniversityText.isHidden = true
                self.CourseText.isHidden = true
                self.FriendsText.isHidden = true
                self.BioText.isHidden = true
                self.countryFlag.isHidden = true
                self.collectionView.isHidden = true
                self.AddFriendButton.isHidden = true
                }
            else {
                
            }
        }
    }
    
    
        @objc func reportuser() {
            guard let UID = self.uid else {return}
            let ref = Firestore.firestore().collection("reportedUsers").document(UID)
            guard let uid = Auth.auth().currentUser?.uid else {return}
            ref.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                    let data = document.data()
                    let count = data?["Count"] as! Int
                    let userID = data?["Reported"] as? String
                    if uid == userID {
                        self.Alert("Thank You", "You have already Reported this User")
                    }
                    else {
                        self.showSubmitTextFieldAlert(title: "Please provide a reason for reporting this user", message: "", placeholder: "Reason") { (reason) in
                            guard let Reason = reason else {return}
                            let Count = count + 1
                            ref.setData([uid: Reason, "Count": Count], merge: true) { [weak self] (error) in
                            self?.Alert("Thank You", "This user has been reported.")
                            }
                        }
                    }
                }
                else {
                    self.showSubmitTextFieldAlert(title: "Please provide a reason for reporting this user", message: "", placeholder: "Reason") { (reason) in
                        guard let Reason = reason else {return}
                        ref.setData([uid: Reason, "Count": 1], merge: true) { [weak self] (error) in
                        self?.Alert("Thank You", "This user has been reported.")
                        }
                    }
                }
            }
        }
    }
        func showSubmitTextFieldAlert(title: String,
                                      message: String,
                                      placeholder: String,
                                      completion: @escaping (_ userInput: String?) -> Void) {

            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)

            alertController.addTextField { (textField) in
                textField.placeholder = placeholder
                textField.clearButtonMode = .whileEditing
            }

            let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
                let userInput = alertController.textFields?.first?.text
                completion(userInput)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                completion(nil)
            }

            alertController.addAction(submitAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true)
        }
        
        func Alert(_ error:String, _ Message:String){
            let alertController = UIAlertController(title: "\(error)", message: "\(Message)", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    
    
    
    
    
    
    
}
