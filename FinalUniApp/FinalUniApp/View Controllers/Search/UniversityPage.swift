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
import AnimatedGradientView

class UniversityPage: UIViewController {
    
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
        collectionView.layer.cornerRadius = 15
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.layer.masksToBounds = true
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
    
    lazy var gradient: AnimatedGradientView = {
      let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.direction = .up
        animatedGradient.animationDuration = 2
        animatedGradient.animationValues = [
          (colors: ["#3416E9", "#228FDD"], .down, .axial),
          (colors: ["#061EC5"], .right, .axial),
          (colors: ["#0007DD"], .down, .axial),
          (colors: ["#1B61E4"], .left, .axial)
        ]
        return animatedGradient
    }()
    
     var username:String = ""
     var filteredUniversity = [String]()
     var popularUnis = [UNI]()
     var UnfilteredUniversity = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(UniCell.self, forCellReuseIdentifier: "UniCell")
        getTotalUnis()
        tableview.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        setupView()
        self.definesPresentationContext = true
        getPopularUnis()
        collectionView.showsVerticalScrollIndicator = false
        tableview.keyboardDismissMode = .onDrag
    }
    
    func getTotalUnis() {
        let ref = Firestore.firestore().collection("SupportedUniversities").document("Total")
        ref.getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else {return}
            self.UnfilteredUniversity.append(contentsOf: data.keys)
                DispatchQueue.main.async {
                    self.filteredUniversity = self.UnfilteredUniversity
                    self.tableview.reloadData()
                    
                }
            }
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    func setupView() {
        
        view.addSubview(searchBar)
        view.addSubview(UnderTableView)
        UnderTableView.addSubview(containerview)
        UnderTableView.addSubview(collectionView)
        UnderTableView.addSubview(tableview)
        containerview.addSubview(gradient)
        gradient.addSubview(UniTitle)
        
    //searchbar constraints
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
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
        guard let university = cell?.textLabel?.text else {return}
        let listofusersfromuni = ListOfUsersFromUniversity()
        listofusersfromuni.University = university
        navigationController?.pushViewController(listofusersfromuni, animated: true)
    }

}

class UNI {
    var name: String?
    var count: Int?
}
