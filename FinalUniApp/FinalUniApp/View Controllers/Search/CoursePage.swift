//
//  Course.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//
import UIKit
import FirebaseFirestore
import Firebase
import AnimatedGradientView

class CoursePage: UIViewController {
    
   lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

   lazy var UnderTableView: UIView = {
        let UnderTableView = UIView()
        UnderTableView.backgroundColor = .white
        UnderTableView.translatesAutoresizingMaskIntoConstraints = false
        return UnderTableView
     }()
    
    lazy var searchBar: UISearchBar = {
      let searchBar = UISearchBar()
      searchBar.translatesAutoresizingMaskIntoConstraints = false
      searchBar.placeholder = "Search For Courses"
      return searchBar
    }()
    
    lazy var containerview: UIView = {
        let containerview = UIView()
        containerview.backgroundColor = .systemBlue
        containerview.translatesAutoresizingMaskIntoConstraints = false
        return containerview
    }()
    
    lazy var UniTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.text = "Popular Courses"
        title.font = UIFont.systemFont(ofSize: 38, weight: UIFont.Weight.bold)
        return title
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(unicollectioncell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 15
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.layer.masksToBounds = true
        return collectionView
    }()
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20,
                                           left: 0,
                                           bottom: 10,
                                           right: 0)
        layout.scrollDirection = .vertical
        return layout
    }
    
    lazy var gradient: AnimatedGradientView = {
      let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.direction = .up
        animatedGradient.animationDuration = 2
        animatedGradient.animationValues = [
          (colors: ["#00688B", "#00B2EE"], .down, .axial),
          (colors: ["#38B0DE"], .right, .axial),
          (colors: ["#33A1DE"], .down, .axial),
          (colors: ["#0198E1"], .left, .axial)
        ]
        return animatedGradient
    }()
    
     var username:String = ""
     var filteredCourse = [String]()
     var popularcourses = [UNI]()
     var UnfilteredCourse = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getCourses()
        self.tableview.register(CourseCell.self, forCellReuseIdentifier: "CourseCell")
        tableview.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(UnderTableView)
        UnderTableView.addSubview(containerview)
        containerview.addSubview(gradient)
        UnderTableView.addSubview(collectionView)
        UnderTableView.addSubview(tableview)
        gradient.addSubview(UniTitle)
        setupView()
        getPopularCourses()
        collectionView.showsVerticalScrollIndicator = false
        tableview.keyboardDismissMode = .onDrag
    }
    
    func getCourses() {
        let ref = Firestore.firestore().collection("SupportedCourses")
        ref.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                self.UnfilteredCourse.append(contentsOf: data.keys)
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    func setupView() {
        
    //searchbar constraints
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    //tableview constraints
        tableview.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    //underview constraints
        UnderTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        UnderTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        UnderTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        UnderTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
     
    //collectionView constraints
       collectionView.leftAnchor.constraint(equalTo: UnderTableView.leftAnchor).isActive = true
       collectionView.topAnchor.constraint(equalTo: UnderTableView.topAnchor, constant: 80).isActive = true
       collectionView.rightAnchor.constraint(equalTo: UnderTableView.rightAnchor).isActive = true
       collectionView.bottomAnchor.constraint(equalTo: UnderTableView.bottomAnchor).isActive = true
       
   //containerview constraints
       containerview.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
       containerview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
       containerview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
       containerview.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
       
   //UniTitle constraints
       UniTitle.topAnchor.constraint(equalTo: containerview.topAnchor, constant: 20).isActive = true
       UniTitle.centerXAnchor.constraint(equalTo: containerview.centerXAnchor).isActive = true
        
    }
    
    func getPopularCourses() {
        let docRef = Firestore.firestore().collection("User-Courses")
        docRef.getDocuments { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else {
                guard let documents = snapshot?.documents else {return}
                for document in documents {
                    let course = document.documentID
                    self.fetchuser(course) { (count) in
                    let uni = UNI()
                    uni.count = count
                    uni.name = course
                    if count == 0 {}
                    else {
                    self.popularcourses.append(uni)
                    self.popularcourses.sort { (uni1, uni2) -> Bool in
                        return uni1.count! > uni2.count!
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }


    func fetchuser(_ course: String?, completion: @escaping (_ count: Int) -> Void) {
        guard let Course = course else {return}
        service.loadUniversityAndCourse { (uni, ignorecourse) in
        guard let University = uni else {return}
            
        let userRef = Firestore.firestore().collection("users").whereField("University", isEqualTo: University).whereField("Course", isEqualTo: Course)
            
        userRef.getDocuments { (snapshot, err) in
            guard let documents = snapshot?.documents else {return}
            let count = documents.count
            completion(count)
            }
        }
    }

}

extension CoursePage: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableview.isHidden = false
        searchBar.showsCancelButton = true
        updateSearchResults()
      }
       
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
      }
       
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        tableview.isHidden = true
        searchBar.text = nil
        searchBar.endEditing(true)
      }

       func updateSearchResults() {
           if let searchText = searchBar.text, !searchBar.text!.isEmpty {
           filteredCourse = UnfilteredCourse.filter { uni in
           return uni.lowercased().contains(searchText.lowercased())
               }} else {
               filteredCourse = UnfilteredCourse
               }
           DispatchQueue.main.async {
               self.tableview.reloadData()
               }
        }

}

extension CoursePage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let UnfilteredCourse = filteredCourse
        return UnfilteredCourse.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")! as! CourseCell
        let UnfilteredCourse = filteredCourse
            let user = UnfilteredCourse[indexPath.row]
            cell.textLabel!.text = user
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let cell = tableView.cellForRow(at: indexPath)
           let course = cell?.textLabel?.text
           let listofusersfromcourse = ListOfUsersFromCourse()
           guard let Course = course else {return}
           listofusersfromcourse.Course = Course
           navigationController?.pushViewController(listofusersfromcourse, animated: true)
       }
     

}
    


