//
//  UsersPage.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 06/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import Kingfisher

class FriendsList: UITableViewController, UISearchResultsUpdating {
    
    var filteredUsers: [String]?
    var users = [String]()
    {didSet{updateSearchResults(for: searchController)
        self.tableView.reloadData()}}
    let searchController = UISearchController(searchResultsController: nil)
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getusers()
        tableView.reloadData()
        filteredUsers = users
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
        tableView.tableHeaderView = searchController.searchBar
        self.title = "Friends"
        self.definesPresentationContext = true
    }
    
  func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredUsers = users.filter { user in
                return user.lowercased().contains(searchText.lowercased())} }
        else {
            filteredUsers = users }
        DispatchQueue.main.async {
            self.tableView.reloadData() }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = filteredUsers else {
            return 0
        }
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")! as! UsersCell
        let users = filteredUsers
        let user = users?[indexPath.row]
        cell.textLabel!.text = user
        service.getprofilepicfromusername(user!) { (url) in
        cell.profilePicture.kf.setImage(with: url)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        tableView.deselectRow(at: indexPath, animated: true)
        let username = cell.textLabel!.text
        let searchprofile = SearchProfile()
        searchprofile.username = username
        navigationController?.pushViewController(searchprofile, animated: true)
    }

    func getusers() {
        let docRef = Firestore.firestore().collection("Friends")
        let friendsRef = docRef.document(uid!)
        friendsRef.getDocument{ (document, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        if let document = document {
           guard let data = document.data() else {return}
           let keydict = data.keys
           let stringArray = Array(keydict)
           for user in stringArray {
            service.getUsernameFromUID(user) { (username) in
                self.users.append(username)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                       }
            } } }
            else {print("Document does not exist")}
                DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
