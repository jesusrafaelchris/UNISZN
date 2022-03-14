//
//  Course.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//
import UIKit
import Firebase


class Course: UITableViewController,UISearchResultsUpdating {
  
    var filteredCourse: [String]?
    weak var delegate: ModalDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var uni: String?
    var UnfilteredCourse = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getCourses()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.tableView.register(CourseCell.self, forCellReuseIdentifier: "CourseCell")
        tableView.tableHeaderView = searchController.searchBar
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
                self.filteredCourse = self.UnfilteredCourse
                self.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
        filteredCourse = UnfilteredCourse.filter { uni in
        return uni.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredCourse = UnfilteredCourse
        }
    DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let UnfilteredCourse = filteredCourse else {
            return 0
        }
        return UnfilteredCourse.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")! as! CourseCell
        if let UnfilteredCourse = filteredCourse {
            let Uni = UnfilteredCourse[indexPath.row]
            cell.textLabel!.text = Uni
        }
        return cell
}
    var docRef = Firestore.firestore()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showSpinner(onView: self.view)
        searchController.isActive = false
        let cell = tableView.cellForRow(at: indexPath)!
        let choice = cell.textLabel!.text ?? ""
        
        let batch = Firestore.firestore().batch()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let UserDocument = docRef.collection("users").document(userID)
        let UserUnisDocument = docRef.collection("User-Courses").document(choice)
        
        let Userid: [String:Any] = [userID: true]
        let courseChoice: [String:Any] = ["Course":choice]
        
        batch.setData(courseChoice, forDocument: UserDocument, merge: true)
        batch.setData(Userid, forDocument: UserUnisDocument, merge: true)
        
        Messaging.messaging().subscribe(toTopic: choice.stringByRemovingWhitespaces) { error in
          print("Subscribed to course topic")
        }
        
        if let delegate = self.delegate {
            delegate.changeValuecourse(value: choice)
        }
        
        batch.commit { (error) in
           if error != nil {
            print(error!.localizedDescription)
           }
            
           else {
            self.removeSpinner()
            self.dismiss(animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}
