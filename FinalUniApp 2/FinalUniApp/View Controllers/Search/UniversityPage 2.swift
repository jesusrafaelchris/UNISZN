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

class UniversityPage: UIViewController {
    
    var UnfilteredUniversity = ["University of Cambridge", "University of Oxford", "University of St Andrews", "London School of Economics and Politics", "Imperial College London", "Loughborough University", "Durham University", "Lancaster University", "University of Bath  ", "UCL", "University of Warwick", "University of Exeter", "University of Birmingham", "University of Bristol", "University of Edinburgh", "University of Leeds", "University of Manchester", "University of Southampton", "University of Glasgow", "University of Nottingham", "King's College London, University of London", "University of York", "Newcastle University", "Royal Holloway, University of London", "University of East Anglia UEA", "University of Aberdeen", "Queen's University Belfast", "University of Sheffield", "Heriot-Watt University", "Cardiff University", "University of Dundee", "Swansea University", "University of Liverpool", "University of Surrey", "University of Strathclyde", "Queen Mary University of London", "SOAS University of London", "University of Leicester", "University of Reading", "University of Sussex", "University of Essex", "Harper Adams University", "Aston University, Birmingham", "University for the Creative Arts", "University of Stirling", "Nottingham Trent University", "University of Kent", "Oxford Brookes University", "Arts University Bournemouth", "University of Lincoln"]
    
   lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    

   lazy var UnderTableView: UIView = {
        let UnderTableView = UIView()
        UnderTableView.translatesAutoresizingMaskIntoConstraints = false
        return UnderTableView
     }()
    
    lazy var searchBar: UISearchBar = {
      let searchBar = UISearchBar()
      searchBar.translatesAutoresizingMaskIntoConstraints = false
      searchBar.placeholder = "Search For Universities"
      return searchBar
    }()
    
    lazy var containerview: UIView = {
        let containerview = UIView()
        containerview.backgroundColor = .purple
        containerview.translatesAutoresizingMaskIntoConstraints = false
        return containerview
    }()
    
    lazy var UniTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.text = "Popular Universities"
        title.font = UIFont.systemFont(ofSize: 38, weight: UIFont.Weight.bold)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.textAlignment = .center
        return title
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(unicollectioncell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white//UIColor(red: 1.00, green: 0.95, blue: 0.60, alpha: 1.00)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20,
                                           left: 0,
                                           bottom: 10,
                                           right: 0)
        layout.scrollDirection = .vertical
        return layout
    }
    
     var username:String = ""
     var filteredUniversity = [String]()
     var popularUnis = [UNI]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(UniCell.self, forCellReuseIdentifier: "UniCell")
        tableview.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(UnderTableView)
        UnderTableView.addSubview(containerview)
        UnderTableView.addSubview(collectionView)
        UnderTableView.addSubview(tableview)
        containerview.addSubview(UniTitle)
        setupView()
        self.definesPresentationContext = true
        getPopularUnis()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableview.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
        
    //tableview1 constraints
        collectionView.leftAnchor.constraint(equalTo: UnderTableView.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: UnderTableView.topAnchor, constant: 80).isActive = true
        collectionView.rightAnchor.constraint(equalTo: UnderTableView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: UnderTableView.bottomAnchor).isActive = true
        
    //containerview constraints
        containerview.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        containerview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerview.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        
    //UniTitle constraints
        UniTitle.topAnchor.constraint(equalTo: containerview.topAnchor, constant: 20).isActive = true
        UniTitle.centerXAnchor.constraint(equalTo: containerview.centerXAnchor).isActive = true
        UniTitle.rightAnchor.constraint(equalTo: containerview.rightAnchor, constant: -5).isActive = true
        UniTitle.leftAnchor.constraint(equalTo: containerview.leftAnchor, constant: 5).isActive = true
        
    }
    
    func getPopularUnis() {
        let docRef = Firestore.firestore().collection("User-Universities")
        docRef.getDocuments { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else {
                for document in snapshot!.documents {
                    let count = document.data().count
                    let name = document.documentID
                    let uni = UNI()
                    uni.count = count
                    uni.name = name
                    self.popularUnis.append(uni)
                    self.popularUnis.sort { (uni1, uni2) -> Bool in
                        return uni1.count! > uni2.count!
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}


extension UniversityPage: UISearchBarDelegate {
    
    
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
           filteredUniversity = UnfilteredUniversity.filter { uni in
           return uni.lowercased().contains(searchText.lowercased())
               }} else {
               filteredUniversity = UnfilteredUniversity
               }
           DispatchQueue.main.async {
               self.tableview.reloadData()
               }
        }
}

extension UniversityPage: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let UnfilteredUniversity = filteredUniversity
        return UnfilteredUniversity.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UniCell")! as! UniCell
        let UnfilteredUniversity = filteredUniversity
        let user = UnfilteredUniversity[indexPath.row]
        cell.textLabel!.text = user
        return cell


    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let university = cell?.textLabel?.text
        let listofusersfromuni = ListOfUsersFromUniversity()
        listofusersfromuni.University = university!
        navigationController?.pushViewController(listofusersfromuni, animated: true)
    }

}

class UNI {
    var name: String?
    var count: Int?
}
