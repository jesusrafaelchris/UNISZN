//
//  ListOfUsersFromUniversity.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 07/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import Nuke
import InstantSearch

class ListOfUsersFromUniversity: UIViewController, UsersDelegate {
    
    func toSearchProfile(_ uid: String) {
        let searchprofile = SearchProfile()
        searchprofile.uid = uid
        navigationController?.pushViewController(searchprofile, animated: true)
    }
    
   lazy var University: String = ""
   lazy var university = IndexName(stringLiteral: "\(University)Total")
    
   lazy var searcher: SingleIndexSearcher = .init(appID: "9GZM5PWO6S",
                                              apiKey: "af219294d286f62e5cdbef9dfd6a5a19",
                                              indexName: university)
    
    let filterState: FilterState = .init()
    
    let queryInputInteractor: QueryInputInteractor = .init()
    lazy var textFieldController: TextFieldController = {
      return .init(searchBar: searchBar)
    }()
    
    let statsInteractor: StatsInteractor = .init()
    let statsController: LabelStatsController = .init(label: UILabel())
    
    let hitsInteractor: HitsInteractor<JSON> = .init()
    let hitsTableViewController: hitsViewController = .init(style: .plain)

    lazy var searchBar: UISearchBar = {
      let searchBar = UISearchBar()
      searchBar.translatesAutoresizingMaskIntoConstraints = false
      searchBar.placeholder = "Search For Users"
      return searchBar
    }()
    
    lazy var algoliaImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "algolia")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
        setup()
        self.navigationController?.navigationBar.isHidden = false
        self.definesPresentationContext = true
        searchBar.delegate = self
        setupView()
        hitsTableViewController.tableView.keyboardDismissMode = .onDrag
        hitsTableViewController.delegate = self
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .systemBlue
    }
          
    func setup() {
      
      searcher.connectFilterState(filterState)
      
      queryInputInteractor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
      queryInputInteractor.connectController(textFieldController)
      
      statsInteractor.connectSearcher(searcher)
      statsInteractor.connectController(statsController)
      
      hitsInteractor.connectSearcher(searcher)
      hitsInteractor.connectController(hitsTableViewController)
      hitsInteractor.connectFilterState(filterState)

      searchBar.delegate = self

      searcher.search()
    }
    
    func setupView() {
        
        guard let tableView = hitsTableViewController.tableView else {return}
        view.addSubview(searchBar)
        searchBar.addSubview(algoliaImage)
        view.addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBar.searchBarStyle = .minimal
        
        algoliaImage.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -15).isActive = true
        algoliaImage.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        algoliaImage.heightAnchor.constraint(equalTo: searchBar.heightAnchor, multiplier: 0.8).isActive = true
        algoliaImage.widthAnchor.constraint(equalTo: searchBar.widthAnchor, multiplier: 0.2).isActive = true
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


extension ListOfUsersFromUniversity: UISearchBarDelegate {

   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.showsCancelButton = false
       searchBar.text = nil
       searchBar.endEditing(true)
       algoliaImage.isHidden = false
     }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
      }
       
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        algoliaImage.isHidden = true
      }
    
    class hitsViewController: UITableViewController, HitsController {
      
      var hitsSource: HitsInteractor<JSON>?
      weak var delegate: UsersDelegate?
        
      override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
      }
      
      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 80
      }
      
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hitsSource?.numberOfHits() ?? 0
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hit = hitsSource?.hit(atIndex: indexPath.row) else { return .init() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell
        cell.textLabel?.text = [String: Any](hit)?["username"] as? String
          if let urldata = [String: Any](hit)?["ProfilePicUrl"] as? String{
              if let url = URL(string: urldata) {
                  Nuke.loadImage(with: url, into: cell.profilePicture)
              }
          }

        return cell
      }
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard let hit = hitsSource?.hit(atIndex: indexPath.row) else { return }
         tableView.deselectRow(at: indexPath, animated: true)
          guard let uid = [String: Any](hit)?["uid"] as? String else { return  }
          if let delegate = self.delegate {
              delegate.toSearchProfile(uid)
          }
      }
      
    }
       
}
