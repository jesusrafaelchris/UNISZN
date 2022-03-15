//
//  UsersPage.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 06/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import AnimatedGradientView
import Nuke
import InstantSearch

protocol UsersDelegate: AnyObject {
    func toSearchProfile(_ uid: String)
}

class UsersPage: UIViewController, UsersDelegate {
    
    func toSearchProfile(_ uid: String) {
        let searchprofile = SearchProfile()
        searchprofile.uid = uid
        navigationController?.pushViewController(searchprofile, animated: true)
    }
    
    var listener: ListenerRegistration?

    
    let searcher: SingleIndexSearcher = .init(appID: "9GZM5PWO6S",
                                              apiKey: "af219294d286f62e5cdbef9dfd6a5a19",
                                              indexName: "users")
    
    let filterState: FilterState = .init()
    
    let queryInputInteractor: QueryInputInteractor = .init()
    lazy var textFieldController: TextFieldController = {
      return .init(searchBar: searchBar)
    }()
    
    let statsInteractor: StatsInteractor = .init()
    let statsController: LabelStatsController = .init(label: UILabel())
    
    let hitsInteractor: HitsInteractor<JSON> = .init()
    let hitsTableViewController: HitsViewController = .init(style: .plain)

    

   lazy var UnderTableView: UIView = {
        let UnderTableView = UIView()
        UnderTableView.backgroundColor = .white
        UnderTableView.translatesAutoresizingMaskIntoConstraints = false
        return UnderTableView
     }()
    
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
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(userCollectionCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.layer.cornerRadius = 15
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.layer.masksToBounds = true
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
        containerview.translatesAutoresizingMaskIntoConstraints = false
        return containerview
    }()
    
    lazy var gradient: AnimatedGradientView = {
      let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.direction = .up
        animatedGradient.animationDuration = 2
        animatedGradient.animationValues = [(colors: ["#367588", "#16A4AE"], .up, .axial),
        (colors: ["#16A4AE"], .right, .axial),
        (colors: ["#367588"], .down, .axial),
        (colors: ["#16A4AE"], .left, .axial)]
        return animatedGradient
    }()
    
     var username: String = ""
     var users = [usersClass]()
     var profilePictures = [ProfilePicturestruct]()
     var filteredUsers = [usersClass]()
     let docRef = Firestore.firestore().collection("users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupView()
        collectionView.delegate = self
        collectionView.dataSource = self
        hitsTableViewController.tableView.keyboardDismissMode = .onDrag
        setup()
        getProfilePictures()
        hitsTableViewController.delegate = self
        collectionView.showsVerticalScrollIndicator = false
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
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    

    func setupView() {
        
        guard let tableView = hitsTableViewController.tableView else {return}
        view.addSubview(searchBar)
        searchBar.addSubview(algoliaImage)
        view.addSubview(UnderTableView)
        UnderTableView.addSubview(containerview)
        containerview.addSubview(gradient)
        gradient.addSubview(UserTitle)
        UnderTableView.addSubview(collectionView)
        UnderTableView.addSubview(tableView)
        
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

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.showsCancelButton = false
      hitsTableViewController.tableView.isHidden = true
      searchBar.text = nil
      searchBar.endEditing(true)
      algoliaImage.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hitsTableViewController.tableView.isHidden = false
        searchBar.showsCancelButton = true
      }
       
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        algoliaImage.isHidden = true
      }
       
}

  class HitsViewController: UITableViewController, HitsController {
    
    var hitsSource: HitsInteractor<JSON>?
    weak var delegate: UsersDelegate?
      
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
      tableView.isHidden = true
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


class usersClass {
    var username: String?
    var uid: String?
    var profilepicurl: URL?
}
