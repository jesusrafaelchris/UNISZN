//
//  FriendsListToMessage.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 10/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import Nuke

class FriendsListToMessage: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    
     lazy var messageview = MessagesMainView()
    
     let searchController = UISearchController(searchResultsController: nil)
    
     var users = [usersClass](){didSet{updateSearchResults(for: searchController)
     self.tableView.reloadData()}}
     var filteredUsers = [usersClass]()
     let docRef = Firestore.firestore().collection("Friends")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getusers()
        filteredUsers = users
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
        tableView.tableHeaderView = searchController.searchBar
        tableView.delegate = self
        tableView.dataSource = self
        definesPresentationContext = true
        hidesBottomBarWhenPushed = true
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.keyboardDismissMode = .onDrag
        searchController.searchBar.delegate = self
        
    }
    
    func getusers() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let FriendsRef = Firestore.firestore().collection("Friends").document(uid).collection("Accepted")
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
                    guard let data = snapshot?.data() else {return}
                    let username = data["username"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let profilepic = data["ProfilePicUrl"] as? String ?? ""
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

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredUsers = users.filter { user in
                return user.username!.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredUsers = users
        }
    DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        searchController.isActive = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
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
        
        if let url = user.profilepicurl {
             Nuke.loadImage(with: url, into: cell.profilePicture)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        searchController.isActive = false

        if let Username = user.username, let uid = user.uid {

        self.dismiss(animated: true) {
            
        DispatchQueue.main.async {
            self.messageview.showchatcontrollerForUser(Username, uid)
                        
                }
            }
        }
    }
}

