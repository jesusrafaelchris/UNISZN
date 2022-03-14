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
import SkeletonView
import Kingfisher

class UsersPage: UIViewController {
    
   lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

   lazy var UnderTableView: UIView = {
        let UnderTableView = UIView()
        UnderTableView.backgroundColor = .lightGray
        UnderTableView.translatesAutoresizingMaskIntoConstraints = false
        return UnderTableView
     }()
    
    lazy var searchBar: UISearchBar = {
      let searchBar = UISearchBar()
      searchBar.translatesAutoresizingMaskIntoConstraints = false
      searchBar.placeholder = "Search For Users"
      return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(userCollectionCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: 4,
                                           bottom: 10,
                                           right: 4)
        layout.scrollDirection = .vertical
        return layout
    }
    
    lazy var UserTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.text = "Newest Users"
        title.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        return title
    }()
    
    lazy var containerview: UIView = {
        let containerview = UIView()
        //containerview.backgroundColor = UIColor(red: 0.09, green: 0.64, blue: 0.68, alpha: 1.00) //UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
        containerview.translatesAutoresizingMaskIntoConstraints = false
        return containerview
    }()
    
     var username:String = ""
     var users = [String]()
     var profilePictures = [String]()
     var randomProfilePictures = [String]()
     var filteredUsers = [String]()
     let docRef = Firestore.firestore().collection("users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
        tableview.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(UnderTableView)
        UnderTableView.addSubview(containerview)
        containerview.addSubview(UserTitle)
        UnderTableView.addSubview(collectionView)
        UnderTableView.addSubview(tableview)
        setupView()
        self.collectionView.reloadData()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getUsers() {
        docRef.getDocuments { (snapshot, error) in
        if let error = error {
            print(error.localizedDescription)
        }
        else {
            if let snapshot = snapshot {
            for document in snapshot.documents {
            let data = document.data()
            let username = data["username"] as? String ?? ""
                self.users.append(username)
            DispatchQueue.main.async {
            self.tableview.reloadData()
        }}}}}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableview.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        users.removeAll()
        profilePictures.removeAll()
        getUsers()
        getProfilePictures()
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
        
    //containerview constraints
        containerview.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        containerview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerview.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        
    //collectionview constraints
        collectionView.leftAnchor.constraint(equalTo: UnderTableView.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: UnderTableView.topAnchor, constant: 80).isActive = true
        collectionView.rightAnchor.constraint(equalTo: UnderTableView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: UnderTableView.bottomAnchor).isActive = true
        
    //UserTitle constraints
        UserTitle.topAnchor.constraint(equalTo: containerview.topAnchor, constant: 20).isActive = true
        //UserTitle.bottomAnchor.constraint(equalTo: UnderTableView.bottomAnchor, constant: 10).isActive = true
        UserTitle.centerXAnchor.constraint(equalTo: containerview.centerXAnchor).isActive = true
        
    }
}

extension UsersPage: UISearchBarDelegate {
    
    
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
           filteredUsers = users.filter { uni in
           return uni.lowercased().contains(searchText.lowercased())
               }} else {
               filteredUsers = users
               }
           DispatchQueue.main.async {
               self.tableview.reloadData()
               }
        }
    
    
    
}

extension UsersPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let users = filteredUsers
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell")! as! UsersCell
        let users = filteredUsers
            let user = users[indexPath.row]
            cell.textLabel!.text = user
        
        service.getprofilepicfromusername(user) { (url) in
            cell.profilePicture.kf.setImage(with: url)
            }
            
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cell = tableView.cellForRow(at: indexPath)
        let username = cell?.textLabel!.text 
        let searchprofile = SearchProfile()
        searchprofile.username = username
        navigationController?.pushViewController(searchprofile, animated: true)
    }
    
    
}
