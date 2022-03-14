//
//  SearchFriendsList.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 22/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class SearchFriendsList: UITableViewController, UISearchResultsUpdating {
    
    var filteredUsers: [usersClass]?
    var users = [usersClass]()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
  func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredUsers = users.filter { user in
                return user.username!.lowercased().contains(searchText.lowercased())} }
        else {
            filteredUsers = users }
        DispatchQueue.main.async {
            self.tableView.reloadData() }
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80
       }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")! as! UsersCell
        let users = filteredUsers
        if let user = users?[indexPath.row] {
        cell.textLabel!.text = user.username
        cell.profilePicture.image = nil
            
        let options = ImageLoadingOptions (
            placeholder: UIImage(named: "placeholder"),
            transition: .fadeIn(duration: 0.33)
        )
            
        if let url = user.profilepicurl {
            Nuke.loadImage(with: url, options: options,into: cell.profilePicture)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let searchprofile = SearchProfile()
        searchprofile.uid = user.uid
        navigationController?.pushViewController(searchprofile, animated: true)
    }

    func getusers() {
        guard let Uid = uid else {return}
        let FriendsRef = Firestore.firestore().collection("Friends").document(Uid).collection("Accepted")
        FriendsRef.getDocuments { (document, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }

            for document in document!.documents {
                let id = document.documentID
                let docRef = Firestore.firestore().collection("users").document(id)
                docRef.getDocument { (snapshot, error) in
                    
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    let data = snapshot?.data()
                    let username = data?["username"] as? String ?? ""
                    let uid = data?["uid"] as? String ?? ""
                    let profilepic = data?["ProfilePicUrl"] as? String ?? ""
                    let user = usersClass()
                    user.username = username
                    user.uid = uid
                    user.profilepicurl = URL(string: profilepic)
                    self.users.append(user)
                    }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
