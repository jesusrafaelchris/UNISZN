//
//  University.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class University: UITableViewController, UISearchResultsUpdating {
    
    
    var filteredUniversity: [String]?
    weak var delegate: ModalDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var uni: String?
    var UnfilteredUniversity = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTotalUnis()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.tableView.register(UniCell.self, forCellReuseIdentifier: "UniCell")
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func getTotalUnis() {
        let ref = Firestore.firestore().collection("SupportedUniversities").document("Total")
        ref.getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else {return}
            self.UnfilteredUniversity.append(contentsOf: data.keys)
                DispatchQueue.main.async {
                    self.filteredUniversity = self.UnfilteredUniversity
                    self.tableView.reloadData()
                    
                }
            }
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredUniversity = UnfilteredUniversity.filter { uni in
                return uni.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredUniversity = UnfilteredUniversity
        }
    DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let UnfilteredUniversity = filteredUniversity else {
            return 0
        }
        return UnfilteredUniversity.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniCell")! as! UniCell
        if let UnfilteredUniversity = filteredUniversity {
            let Uni = UnfilteredUniversity[indexPath.row]
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
        let UserUnisDocument = docRef.collection("User-Universities").document(choice)
        
        let Userid: [String:Any] = [userID: true]
        let uniChoice: [String:Any] = ["University":choice]
        
        batch.setData(uniChoice, forDocument: UserDocument, merge: true)
        batch.setData(Userid, forDocument: UserUnisDocument, merge: true)
        Messaging.messaging().subscribe(toTopic: choice.stringByRemovingWhitespaces) { error in
          print("Subscribed to Uni topic")
        }
        
        if let delegate = self.delegate {
            delegate.changeValueuniversity(value: choice)
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


extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
}
