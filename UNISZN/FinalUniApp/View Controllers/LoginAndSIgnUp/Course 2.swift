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
    var delegate: ModalDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var uni: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredCourse = UnfilteredCourse
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.tableView.register(CourseCell.self, forCellReuseIdentifier: "CourseCell")
        tableView.tableHeaderView = searchController.searchBar
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        let cell = tableView.cellForRow(at: indexPath)!
        let choice = cell.textLabel!.text ?? ""
        print(choice)
        saveData(choice: choice)
        if let delegate = self.delegate {
            delegate.changeValuecourse(value: choice)
        }
        dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func saveData(choice: String) {
        let docRef = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let UserDocument = docRef.collection("users").document(userID)
        let UserUnisDocument = docRef.collection("User-Courses").document(choice)
        let Userid: [String:Any] = [userID: true]
        let courseChoice: [String:Any] = ["Course":choice]
        UserDocument.setData(courseChoice,merge: true)
        UserUnisDocument.setData(Userid, merge:true)
        Messaging.messaging().subscribe(toTopic: choice) { error in
          print("Subscribed to course topic")
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
