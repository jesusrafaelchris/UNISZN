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
    var delegate: ModalDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var uni: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredUniversity = UnfilteredUniversity
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.tableView.register(UniCell.self, forCellReuseIdentifier: "UniCell")
        tableView.tableHeaderView = searchController.searchBar
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        let cell = tableView.cellForRow(at: indexPath)!
        let choice = cell.textLabel!.text ?? ""
        print(choice)
        saveData(choice: choice)
        if let delegate = self.delegate {
            delegate.changeValueuniversity(value: choice)
        }
        dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func saveData(choice: String) {
        let docRef = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let UserDocument = docRef.collection("users").document(userID)
        let UserUnisDocument = docRef.collection("User-Universities").document(choice)
        let Userid: [String:Any] = [userID: true]
        let uniChoice: [String:Any] = ["University":choice]
        UserDocument.setData(uniChoice,merge: true)
        UserUnisDocument.setData(Userid, merge:true)
        Messaging.messaging().subscribe(toTopic: choice.stringByRemovingWhitespaces) { error in
          print("Subscribed to Uni topic")
        }
        
    }
    
    
var UnfilteredUniversity = ["University of Cambridge", "University of Oxford", "University of St Andrews", "London School of Economics and Politics", "Imperial College London", "Loughborough University", "Durham University", "Lancaster University", "University of Bath", "UCL", "University of Warwick", "University of Exeter", "University of Birmingham", "University of Bristol", "University of Edinburgh", "University of Leeds", "University of Manchester", "University of Southampton", "University of Glasgow", "University of Nottingham", "King's College London, University of London", "University of York", "Newcastle University", "Royal Holloway, University of London", "University of East Anglia UEA", "University of Aberdeen", "Queen's University Belfast", "University of Sheffield", "Heriot-Watt University", "Cardiff University", "University of Dundee", "Swansea University", "University of Liverpool", "University of Surrey", "University of Strathclyde", "Queen Mary University of London", "SOAS University of London", "University of Leicester", "University of Reading", "University of Sussex", "University of Essex", "Harper Adams University", "Aston University, Birmingham", "University for the Creative Arts", "University of Stirling", "Nottingham Trent University", "University of Kent", "Oxford Brookes University", "Arts University Bournemouth", "University of Lincoln"]

}


extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
}
