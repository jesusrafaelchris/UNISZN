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

class CoursePage: UIViewController {
    
   lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

   lazy var UnderTableView: UIView = {
        let UnderTableView = UIView()
        UnderTableView.backgroundColor = .green
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
    
     var username:String = ""
     var filteredCourse = [String]()
     var popularcourses = [UNI]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(CourseCell.self, forCellReuseIdentifier: "CourseCell")
        tableview.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(UnderTableView)
        UnderTableView.addSubview(containerview)
        UnderTableView.addSubview(collectionView)
        UnderTableView.addSubview(tableview)
        containerview.addSubview(UniTitle)
        setupView()
        getPopularCourses()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableview.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        tableview.reloadData()
    }

    func setupView() {
        
    //searchbar constraints
        searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
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
                for document in snapshot!.documents {
                    let count = document.data().count
                    let name = document.documentID
                    let uni = UNI()
                    uni.count = count
                    uni.name = name
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
    
    var UnfilteredCourse = [
    "Business Administration",
    "Economics",
    "Finance and Management",
    "International Business",
    "Marketing",
    "Banking and Finance",
    "Accounting",
    "International Management",
    "Business Analytics",
    "Entrepreneurship",
    "Biology",
    "Marine Biology",
    "Mathematics",
    "Computer Science",
    "Chemistry",
    "Physics & Astronomy",
    "Earth Science",
    "Biochemistry",
    "Chemical Engineering",
    "Aeronautics",
    "Bioengineering",
    "Civil and Environmental Engineering",
    "Electronic Engineering",
    "Mechanical Engineering",
    "Surgery",
    "Dentistry",
    "Molecular Medicine",
    "Veterinary Surgery",
    "Nursing",
    "Psychotherapy",
    "Biomedicine",
    "Pharmacy",
    "Medical Biotechnology",
    "Bachelor of Law",
    "Criminology and Law",
    "Master of Laws",
    "Civil Law",
    "International Human Rights Law",
    "Criminal Justice",
    "Psychology",
    "Political Science",
    "History",
    "Linguistics",
    "Anthropology",
    "English",
    "Politics",
    "Geography",
    "Sports and Exercise Sciences",
    "Sports Science and Physiology",
    "Sport & Exercise Nutrition",
    "Journalism",
    "Film & TV Studies",
    "Screenwriting",
    "Digital Media",
    "Fine Art Painting",
    "Graphic Design",
    "Fashion Design",
    "Architecture",
    "French",
    "Spanish",
    "German",
    "Latin",
    "Italian",
    "Japanese",
    "Chinese"]
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
           listofusersfromcourse.Course = course!
           navigationController?.pushViewController(listofusersfromcourse, animated: true)
       }
     

}
    


