//
//  ListOfUsersFromUniversity.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 07/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import Kingfisher

class ListOfUsersFromCourse: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    var Course: String = ""
    var users = [String](){didSet{updateSearchResults(for: searchController)
    self.tableView.reloadData()}}
    var filteredUsers = [String]()
    let searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    super.viewDidLoad()
    filteredUsers = users
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    self.tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
    tableView.tableHeaderView = searchController.searchBar
    self.navigationController?.navigationBar.isHidden = false
    getusers(course: Course)
    tableView.reloadData()
    definesPresentationContext = true
    searchController.hidesNavigationBarDuringPresentation = false
    }
          
    func getusers(course: String) {
        let docRef = Firestore.firestore().collection("User-Courses").document(course)
        docRef.getDocument{ (document, error) in
        if let document = document {
            guard let data = document.data() else {return}
            let keydict = data.keys
            let stringArray = Array(keydict)
            for user in stringArray {
                service.getUsernameFromUID(user) { (username) in
                self.users.append(username)}
                DispatchQueue.main.async {
                self.tableView.reloadData()
                }}} else {
                print("Document does not exist")
              }}
    }
 
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredUsers = users.filter { uni in
                return uni.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredUsers = users
        }
    DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let users = filteredUsers
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")! as! UsersCell
        let users = filteredUsers
        let Uni = users[indexPath.row]
        cell.textLabel!.text = Uni
        service.getprofilepicfromusername(Uni) { (url) in
        cell.profilePicture.kf.setImage(with: url)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let username = cell.textLabel!.text ?? ""
        let searchprofile = SearchProfile()
        searchprofile.username = username
        navigationController?.pushViewController(searchprofile, animated: true)
        }
}



