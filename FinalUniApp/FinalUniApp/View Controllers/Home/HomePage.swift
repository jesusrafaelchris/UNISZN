//
//  HomePage.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class HomePage: UICollectionViewController {
    
    var listener: ListenerRegistration?
    var listener2: ListenerRegistration?
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.color = UIColor.darkGray
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: collectionView.bounds.width, height: CGFloat(44))
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    var button = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggedIn()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.title = "UNISZN"
        self.navigationController?.navigationBar.isHidden = false
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        requests()
        collectionView.backgroundColor = UIColor(red: 0.85, green: 0.86, blue: 0.87, alpha: 1.00)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PostCollectionViewCell
        
        cell.backgroundColor = .red
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.borderWidth = 7
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true

        return cell
    }
    
    func requests() {
        let requests = UIImage(systemName: "person.2.square.stack")
        let blackrequests = requests?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button = UIBarButtonItem(image: blackrequests, style: .done, target: self, action: #selector(Friendrequests))
        self.navigationItem.rightBarButtonItem = button
        loadunreadMessagesForUser { (result, count) in
            if result {
                if let tabItems = self.tabBarController?.tabBar.items {
                    let tabItem = tabItems[3]
                    tabItem.badgeValue = " "
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFriendRequests { [weak self] (count) in
            print(count)
            if count == 0 {
                self?.button.setBadge(text: nil)
            }
            else {
               self?.button.setBadge(text: "\(count)")
            }
        }
    }
    
    func getTime() -> TimeInterval {
           let timestamp = NSDate.timeIntervalSinceReferenceDate
           return timestamp
       }
       
       var Count = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
        listener2?.remove()
    }
       
       func loadunreadMessagesForUser(completion: @escaping (_ newmessages: Bool, _ count: Int) -> Void){
          guard let uid = Auth.auth().currentUser?.uid else {return}
           let ref = Firestore.firestore().collection("Latest-Messages").document(uid).collection("Latest").order(by: "TimeStamp", descending: true)
           listener = ref.addSnapshotListener { (snapshot, error) in
            var countreal = self.Count
            guard let documents = snapshot?.documents else {return}
                   for document in documents {
                       let data = document.data()
                       let timestamp = data["TimeStamp"] as! TimeInterval
                       let fromID = data["FromID"] as? String
                       if fromID != uid {
                       let currentTime = self.getTime()
                           if currentTime > timestamp {
                               countreal += 1
                               completion(true, countreal)
                               }
                           else {
                               completion(false, countreal)
                               }
                           }
                       }
                   }
               }
    
    @objc func Friendrequests() {
        let requestpage = FriendRequests()
        navigationController?.pushViewController(requestpage, animated: true)
    }
    
        
    func isLoggedIn() {
        if Firebase.Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
           //load the pictures
        }
    }

    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print("logout error", logoutError)
        }
        
        let startview = StartView()
        let nav = UINavigationController(rootViewController: startview)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }

    
    @objc func reportuser(sender: TapGesture) {
        let ref = Firestore.firestore().collection("reportedUsers").document(sender.uid)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ref.getDocument { (document, error) in
        if let document = document {
            if document.exists {
                let data = document.data()
                let count = data?["Count"] as! Int
                let userID = data?["Reported"] as? String
                if uid == userID {
                    self.Alert("Thank You", "You have already Reported this User")
                }
                else {
                    self.showSubmitTextFieldAlert(title: "Please provide a reason for reporting this user", message: "", placeholder: "Reason") { (reason) in
                        guard let Reason = reason else {return}
                        let Count = count + 1
                        ref.setData([uid: Reason, "Count": Count], merge: true) { [weak self] (error) in
                        self?.Alert("Thank You", "This user has been reported.")
                        }
                    }
                }
            }
            else {
                self.showSubmitTextFieldAlert(title: "Please provide a reason for reporting this user", message: "", placeholder: "Reason") { (reason) in
                    guard let Reason = reason else {return}
                    ref.setData([uid: Reason, "Count": 1], merge: true) { [weak self] (error) in
                    self?.Alert("Thank You", "This user has been reported.")
                    }
                }
            }
        }
    }
}
    func showSubmitTextFieldAlert(title: String,
                                  message: String,
                                  placeholder: String,
                                  completion: @escaping (_ userInput: String?) -> Void) {

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.clearButtonMode = .whileEditing
        }

        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            let userInput = alertController.textFields?.first?.text
            completion(userInput)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            completion(nil)
        }

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    func Alert(_ error:String, _ Message:String){
        let alertController = UIAlertController(title: "\(error)", message: "\(Message)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func goToProfile(sender: TapGesture) {
        let uid = sender.uid
        let profile = SearchProfile()
        profile.uid = uid
        navigationController?.pushViewController(profile, animated: true)
    }
    
    
    
    
    func getFriendRequests(completion: @escaping (_ count: Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection("Friends").document(uid).collection("Requested")
        listener2 = ref.addSnapshotListener({ (snapshot, error) in
        if error != nil {
            print(error!.localizedDescription)
        }
                
        else {
            guard let count = snapshot?.documents.count else {return}
            completion(count)
            }
        })
    }
}

class TapGesture: UITapGestureRecognizer {
    var uid = String()
    var username = String()
}

private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }

    func setBadge(text: String?, offset: CGPoint = .zero, color: UIColor = .red, filled: Bool = true, fontSize: CGFloat = 11.0) {
        badgeLayer?.removeFromSuperlayer()

        guard let text = text, !text.isEmpty else {
            return
        }
        addBadge(text: text, offset: offset, color: color, filled: filled)
    }

    private func addBadge(text: String, offset: CGPoint = .zero, color: UIColor = .red, filled: Bool = true, fontSize: CGFloat = 11) {
        guard let view = self.value(forKey: "view") as? UIView else {
            return
        }

        var font = UIFont.systemFont(ofSize: fontSize)

        if #available(iOS 9.0, *) {
            font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        }

        let badgeSize = text.size(withAttributes: [.font: font])

        // initialize Badge
        let badge = CAShapeLayer()

        let height = badgeSize.height
        var width = badgeSize.width + 2 // padding

        // make sure we have at least a circle
        if width < height {
            width = height
        }

        // x position is offset from right-hand side
        let x = view.frame.width - width + offset.x

        let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))

        badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
        view.layer.addSublayer(badge)

        // initialiaze Badge's label
        let label = CATextLayer()
        label.string = text
        label.alignmentMode = .center
        label.font = font
        label.fontSize = font.pointSize

        label.frame = badgeFrame
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)

        // save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        // bring layer to front
        badge.zPosition = 1_000
    }

    private func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }

}

extension CAShapeLayer {
    func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
    }
}

extension HomePage: UICollectionViewDelegateFlowLayout {

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let itemWidth = collectionView.bounds.width
    let itemHeight = view.frame.height * 0.6
    
    let itemSize = CGSize(width: itemWidth, height: itemHeight)
    
    return itemSize

}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
}
    
}
