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

class FriendsListToMessage: UITableViewController, UISearchBarDelegate {
    
    var messageview: MessagesMainView? 
    //@IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var Searchbar: UISearchBar!
    
    let Searchbar:UISearchBar = UISearchBar()

     var users = [String](){
     didSet{
         self.tableView.reloadData()
     }
    }
     var messagecontroller: MessagesMainView?
     var filteredUsers = [String]()
     var searching = false
     let docRef = Firestore.firestore().collection("Friends")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Searchbar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        Searchbar.searchBarStyle = UISearchBar.Style.default
        Searchbar.placeholder = " Search Here....."
        Searchbar.sizeToFit()
        tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
        tableView.tableHeaderView = Searchbar
        tableView.delegate = self
        tableView.dataSource = self
        Searchbar.delegate = self
        Searchbar.showsCancelButton = false
        definesPresentationContext = true
        
        hidesBottomBarWhenPushed = true
        
    }
    
    
    func getusers() {
        guard let userID = Auth.auth().currentUser?.uid else { return  }
            let friendsRef = docRef.document(userID)
            friendsRef.getDocument{ (document, error) in
              if let document = document {
             guard let data = document.data() else{return}
                let keydict = data.keys
               let stringArray = Array(keydict)
               print(stringArray)
               for user in stringArray {
                   service.getUsernameFromUID(user) { (username) in
                       self.users.append(username)
                }
              }
              }
              else {
                print("Document does not exist")
              }
                DispatchQueue.main.async {
                self.tableView.reloadData()
                }
            }
        }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        Searchbar.showsCancelButton = true
          return true
        }
    
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        Searchbar.text = ""
        Searchbar.resignFirstResponder()
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        Searchbar.showsCancelButton = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Searchbar.showsCancelButton = false
        Searchbar.text = ""
        tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = users.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()

    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        Searchbar.becomeFirstResponder()
        Searchbar.text = nil
        tableView.reloadData()
        getusers()


    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredUsers.count
            } else {
            return users.count
            }
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")! as! UsersCell
        if searching {
            cell.textLabel?.text = filteredUsers[indexPath.row]
        } else {
            cell.textLabel?.text = users[indexPath.row]
        }
        service.getprofilepicfromusername(cell.textLabel!.text!) { (url) in
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
        let user = users[indexPath.row]
        service.getUIDFromUsername(user) { (uid) in
        
        self.dismiss(animated: true) {
            
        DispatchQueue.main.async {
            
            self.messageview?.showchatcontrollerForUser(username, uid)
    
                }
            }
        }
    }
}

