//
//  MessageCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class MessageCell: UITableViewCell {
    
    var listener: ListenerRegistration?
    var listener2: ListenerRegistration?
    
    var message: messageInfo? {
        didSet {
            
            SetupNameAndProfilePicture()
            
            guard let chatPartneruid = message?.chatPartner() else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
             
            let docRef = Firestore.firestore().collection("Latest-Messages").document(uid).collection("Latest").document(chatPartneruid)
            
            listener = docRef.addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let Snapshot = snapshot {
                    if !Snapshot.exists {
                        self.detailTextLabel?.text = "Delivered"
                        self.timeLabel.text = ""
                        self.isUserInteractionEnabled = false
                    }

                else {
                    let data = snapshot?.data()
                        self.detailTextLabel?.text = data?["Text"] as? String

                        if let seconds = data?["TimeStamp"] as? Double {
                        let timeStampDate = Date(timeIntervalSinceReferenceDate: seconds)
                        self.timeLabel.text = timeStampDate.timeAgoDisplay()
                        }
                        
                        if self.message?.chatPartner() == self.message?.FromID {
                            self.profilePicture.layer.borderWidth = 4
                            self.profilePicture.layer.borderColor = UIColor(red: 0.09, green: 0.64, blue: 0.68, alpha: 1.00).cgColor
                        }
                        else {
                            self.profilePicture.layer.borderWidth = 0
                        }
                    }
                }
            })
        }
    }

    deinit {
        listener?.remove()
        listener2?.remove()
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profilePicture.image = UIImage(named: "placeholder")
        self.textLabel?.text = "Loading"
        self.detailTextLabel?.text = "Loading"
        self.timeLabel.text = "Loading"
    }
    
    func SetupNameAndProfilePicture() {
        if let chatpartner = message?.chatPartner() {
            let ref = Firestore.firestore().collection("users").document(chatpartner)
            listener2 = ref.addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    let data = snapshot?.data()
                    self.textLabel?.text = data?["username"] as? String

                let options = ImageLoadingOptions(
                    placeholder: UIImage(named: "placeholder"),
                    transition: .fadeIn(duration: 0.33)
                )
                if let url = data?["ProfilePicUrl"] as? String {
                    if let Url = URL(string: url) {
                        Nuke.loadImage(with: Url, options: options, into: self.profilePicture)
                        }
                    }
                }
            })
        }
    }
    
    lazy var profilePicture: UIImageView = {
        let profilePicture = UIImageView()
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.layer.cornerRadius = 30
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        return profilePicture
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.textAlignment = .right
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 74, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.semibold)
        
        detailTextLabel?.frame = CGRect(x: 74, y: detailTextLabel!.frame.origin.y + 2, width: (self.frame.width * 0.4), height: (detailTextLabel?.frame.height)!)
        
        self.detailTextLabel?.minimumScaleFactor = 0.5
        self.textLabel?.minimumScaleFactor = 0.5
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "UsersCell")
        addSubview(profilePicture)
        addSubview(timeLabel)
        setupview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupview() {
        
    //profilePicture constraints
        profilePicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profilePicture.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //guard let textlabel = detailTextLabel else {return}
        
    //timeLabel constraints
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
