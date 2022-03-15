//
//  HomePage.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView


class HomePage: UITableViewController {
    
    var sameUniSameCourse = [UserInfo]()
    var sameUni = [UserInfo]()
    var sameUniRelatedCourses = [UserInfo]()
    var closeunisSameCourse = [UserInfo]()
    var nearbyUnis = [UserInfo]()
    var Test = [UserInfo]()
    let Friends = Firestore.firestore().collection("Friends")
    var masterArray = [UserInfo]()
    var stage = 0
    
    lazy var RefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshUserData(_:)), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TopCell.self, forCellReuseIdentifier: "TopCell")
        self.tableView.register(MiddleCell.self, forCellReuseIdentifier: "MiddleCell")
        self.tableView.register(BottomCell.self, forCellReuseIdentifier: "BottomCell")
        tableView.delegate = self
        tableView.dataSource = self
        SameUniSameCourse()
        tableView.refreshControl = RefreshControl
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        navigationItem.title = "UNISZN"
        SameUniRelatedCourses()
        sameUniversity()
        nearbyUnisSameCourse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoggedIn()
    }
    
    @objc func refreshUserData(_ sender: Any) {
        sameUniSameCourse.removeAll()
        sameUniRelatedCourses.removeAll()
        sameUni.removeAll()
        closeunisSameCourse.removeAll()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        SameUniSameCourse()
        SameUniRelatedCourses()
        sameUniversity()
        nearbyUnisSameCourse()
        tableView.reloadData()
        RefreshControl.endRefreshing()
    }
    
     override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
        }
        
    func isLoggedIn() {
        if Firebase.Auth.auth().currentUser == nil {
            let startview = StartView()
            let nav = UINavigationController(rootViewController: startview)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row {
    
            case 0: return 60
    
            case 1: return view.frame.size.height * 0.6
    
            case 2: return 85
    
            default: return 50
            }
        }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return sameUniSameCourse.count
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let Info = sameUniSameCourse[indexPath.section]
        
            switch indexPath.row {
            case 0:
               let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell") as! TopCell
               cell.selectionStyle = UITableViewCell.SelectionStyle.none
              // cell.usernameLabel.text = "\(Info.FirstName!) \(Info.Surname!)"
                cell.usernameLabel.text = Info.username
               cell.countryFlag.text = Info.CountryFlag
            
                return cell
    
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCell") as! MiddleCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                let url = URL(string:Info.ProfilePicUrl!)
                cell.profileImage.kf.setImage(with: url)
    
                return cell
    
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BottomCell") as! BottomCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.UniversityLabel.text = Info.University
                cell.CourseLabel.text = Info.Course
                return cell
    
            default:
                fatalError("Error: unexpected indexPath.")
            }
    
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TopCell else {return}
        if indexPath.row == 0 {
            let username = cell.usernameLabel.text
            let profile = SearchProfile()
            profile.username = username
            navigationController?.pushViewController(profile, animated: true)
        }
        else { }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if stage == 0 {
            masterArray.append(contentsOf:(sameUniSameCourse))
            stage = 1
            print("0")
          }
          else {
            let lastElement = masterArray.count - 1
            if indexPath.row == lastElement {
              if stage == 1 {
                masterArray.append(contentsOf:(sameUniRelatedCourses))
                stage = 2
                print("1")
              }
              else if stage == 2 {
                masterArray.append(contentsOf:(sameUni))
                stage = 3
                print("2")
                }
              else if stage == 3 {
                masterArray.append(contentsOf:(closeunisSameCourse))
                stage = 4
                print("3")
                }
            }
         }
    }
    

    func sameUniversity(){
        service.loadUniversityAndCourse { (uni, course) in

    // get the list of users in the users-universities that match their course

            let UniRef = Firestore.firestore().collection("User-Universities").document(uni)
            UniRef.getDocument { (snapshot, error) in
        if let error = error{
            print(error.localizedDescription)
        }
        else {
            //append their data to an array
            guard let data = snapshot?.data() else {return}
            let stringArray = Array(data.keys)
            for user in stringArray {
                let usersRef = Firestore.firestore().collection("users").document(user)
            usersRef.getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                let data = snapshot?.data()
                if let dictionary = data as [String:AnyObject]? {
                let Info = UserInfo(dictionary: dictionary)
                    if self.sameUniSameCourse.contains(where: { $0.uid == Info.uid }) {
                    }
                    else if self.sameUniRelatedCourses.contains(where: { $0.uid == Info.uid }) {
                    }
                    else {
                        self.sameUni.append(Info)
                        self.sameUni.sort { (time1, time2) -> Bool in
                            return time1.Created!.seconds/1000 > time2.Created!.seconds/1000
                        }
                    }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
            }}}}}}
        
    }
}
    

    
    func SameUniSameCourse() {
        service.loadUniversityAndCourse { (uni, course) in
            let usersRef = Firestore.firestore().collection("users").whereField("University", isEqualTo: uni).whereField("Course", isEqualTo: course)
            usersRef.getDocuments { (snapshot, error) in
                
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    if let dictionary = data as [String:AnyObject]? {
                    let Info = UserInfo(dictionary: dictionary)
                    //timestamp sorting

                    self.sameUniSameCourse.append(Info)
                        self.sameUniSameCourse.sort { (time1, time2) -> Bool in
                             //print(time1.Created?.seconds, time1.username, time2.Created?.seconds, time2.username)
                            return time1.Created!.seconds/1000 > time2.Created!.seconds/1000
                        }
                    }
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
        }}}
        
}

    
    func SameUniRelatedCourses() {
        service.loadUniversityAndCourse { (uni, course) in
        let related = RelatedCourses()
        let relatedCourseArray = related.getRelatedCourses(userCourse: course)//.prefix(4)
        
        for Course in relatedCourseArray {
            if Course == course {}
            else {
            let UniRef = Firestore.firestore().collection("User-Courses").document(Course)
                UniRef.getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else {
                //append their data to an array
                guard let data = snapshot?.data() else {return}
                let stringArray = Array(data.keys)
                for user in stringArray {
                    let usersRef = Firestore.firestore().collection("users").document(user)
                    usersRef.getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    let data = snapshot?.data()
                    if let dictionary = data as [String:AnyObject]? {
                    let Info = UserInfo(dictionary: dictionary)
                        if Info.University != uni{
                            
                        }
                        else {
                           self.sameUniRelatedCourses.append(Info)
                            self.sameUniRelatedCourses.sort { (time1, time2) -> Bool in
                                return time2.Created!.seconds/1000 > time1.Created!.seconds/1000
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        }
                }}}}}}
            
            }
        }
    }

    func nearbyUnisSameCourse() {
        service.loadUniversityAndCourse { (Uni, course) in
        let nearbyUnis = ClosestUnis()
        let closeUniArray = nearbyUnis.getClosestUnis(University: Uni)
        for uni in closeUniArray {
            let UniRef = Firestore.firestore().collection("User-Universities").document(uni)
                UniRef.getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else {
                //append their data to an array
                guard let data = snapshot?.data() else {return}
                let stringArray = Array(data.keys)
                for user in stringArray {
                    let usersRef = Firestore.firestore().collection("users").document(user)
                    usersRef.getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    let data = snapshot?.data()
                    if let dictionary = data as [String:AnyObject]? {
                    let Info = UserInfo(dictionary: dictionary)
                        if Info.Course != course {
                            self.nearbyUnis.append(Info)
                            self.nearbyUnis.sort { (time1, time2) -> Bool in
                                return time1.Created!.seconds/1000 > time2.Created!.seconds/1000
                            }
                        }
                        else {
                           self.closeunisSameCourse.append(Info)
                            self.closeunisSameCourse.sort { (time1, time2) -> Bool in
                                return time1.Created!.seconds/1000 > time2.Created!.seconds/1000
                                }
                            }
                        }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        }
                }}}}}}
                
            }
            
        }
}
    
