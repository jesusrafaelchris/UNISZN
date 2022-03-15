//
//  ListOfUsersFromUniversity.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 07/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class ListOfUsersFromCourse: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var Course: String = ""
    var users = [usersClass](){didSet{updateSearchResults(for: searchController)
    self.tableView.reloadData()}}
    var filteredUsers = [usersClass]()
    let searchController = UISearchController(searchResultsController: nil)
    var uni: String?
    var choice: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
        getusers()
        filteredUsers = users
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
        tableView.tableHeaderView = searchController.searchBar
        self.navigationController?.navigationBar.isHidden = false
        tableView.reloadData()
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.keyboardDismissMode = .onDrag
    }
    
    func getusers() {
        service.loadUniversityAndCourse { (Uni, ignorecourse) in
            guard let University = Uni else {return}
            let userRef = Firestore.firestore().collection("users").whereField("University", isEqualTo: University).whereField("Course", isEqualTo: self.Course)
        userRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                guard let documents = snapshot?.documents else {return}
                for document in documents {
                let data = document.data()
                let username = data["username"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let profilepic = data["ProfilePicUrl"] as? String ?? ""
                let user = usersClass()
                user.username = username
                user.uid = uid
                user.profilepicurl = URL(string: profilepic)
                self.users.append(user)
                }
            }
        }
    }
}
 
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredUsers = users.filter { course in
                return course.username!.lowercased().contains(searchText.lowercased())
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
        let user = users[indexPath.row]
        cell.textLabel!.text = user.username
        cell.profilePicture.image = nil
        
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: "placeholder"),
            transition: .fadeIn(duration: 0.33)
        )
        
        if let url = user.profilepicurl {
            Nuke.loadImage(with: url, options: options,into: cell.profilePicture)
        }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let searchprofile = SearchProfile()
        searchprofile.uid = user.uid
        navigationController?.pushViewController(searchprofile, animated: true)
        }
}



