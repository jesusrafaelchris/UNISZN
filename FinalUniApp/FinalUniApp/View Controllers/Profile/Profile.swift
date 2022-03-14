//
//  Profile.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class Profile: UIViewController{

    var picturesArray = [String]()
    var listener: ListenerRegistration?
    var listener2: ListenerRegistration?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
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
    
    lazy var countryFlag: UILabel = {
        let countryFlag = UILabel()
        countryFlag.translatesAutoresizingMaskIntoConstraints = false
        countryFlag.font = UIFont(name: "AppleColorEmoji", size: 40)
        countryFlag.adjustsFontSizeToFitWidth = true
        countryFlag.minimumScaleFactor = 0.5
        countryFlag.textAlignment = .center
        return countryFlag
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
        FriendsText.textAlignment = .center
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
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ProfileImagecell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var RefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .systemGray
        refreshControl.addTarget(self, action: #selector(refreshUserData(_:)), for: .valueChanged)
        return refreshControl
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
    
    @objc func refreshUserData(_ sender: Any) {
        picturesArray.removeAll()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        getUserInfo()
        getFriendsCount()
        RefreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(LogOut))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit Profile", style: .done, target: self, action: #selector(EditProfile))
        view.backgroundColor = .white
        scrollView.refreshControl = RefreshControl
        setupView()
        getUserInfo()
        getFriendsCount()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserData(_:)), name: NSNotification.Name(rawValue: "loadprofile"), object: nil)
        collectionView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
        listener2?.remove()
    }

    @objc func EditProfile() {
        let editprofilepage = EditProfilePage()
        editprofilepage.modalPresentationStyle = .fullScreen
        editprofilepage.profilepage = self
        present(editprofilepage, animated: true , completion: nil)
    }

    @objc func LogOut() {
    do { try Auth.auth().signOut() }
    catch let signOutError as NSError {
    print ("Error signing out: %@", signOutError)}
            let startview = StartView()
            let nav = UINavigationController(rootViewController: startview)
            tabBarController?.selectedIndex = 0 
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
    }
    
    @objc func showFriendsList() {
        let friendslist = FriendsList()
        navigationController?.pushViewController(friendslist, animated: true)
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

    //imageView constraints
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2).isActive = true

    //scrollview constraints
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
        usernameField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        
    //constrain countryFlag
        countryFlag.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        countryFlag.leftAnchor.constraint(equalTo: usernameField.rightAnchor, constant: 3).isActive = true
        countryFlag.centerYAnchor.constraint(equalTo: usernameField.centerYAnchor).isActive = true
        countryFlag.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -3).isActive = true
 
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
        
    //FriendsImageView constraints
        FriendsImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        FriendsImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    
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
        
    }
    
    func getUserInfo() {
        print("gettinguserInfo")
        if let userID = Auth.auth().currentUser?.uid {
        let ref = Firestore.firestore().collection("users").document(userID)
            listener = ref.addSnapshotListener({ (snapshot, error) in
               if let error = error {
                   print(error.localizedDescription)
               }
               else {
                   if let snapshot = snapshot {
                   let data = snapshot.data()
                   guard let dictionary = data as [String:AnyObject]? else {return}
                    let user = User(dictionary: dictionary)
                    self.usernameField.text = user.username
                    guard let profilepicurl = user.ProfilePicUrl else {return}
                    guard let url = URL(string: profilepicurl) else {return}
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
                        //print("no emoji")
                    }
                    self.viewDidLayoutSubviews()
                    
        }}})}
    }
    
    func getFriendsCount() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let friendsRef = Firestore.firestore().collection("Friends").document(uid).collection("Accepted")
        listener2 = friendsRef.addSnapshotListener({ (document, error) in
            guard let friends = document?.count else {return}
            self.FriendsText.text = "\(friends)"
        })
    }
}

extension Profile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProfileImagecell
        let url = picturesArray[indexPath.row]
        if let image = URL(string: url) {
            Nuke.loadImage(with: image, into: cell.imageView)
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

