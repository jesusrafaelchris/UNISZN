//
//  RequestCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 24/07/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    lazy var profilePicture: UIImageView = {
       let profilePicture = UIImageView()
       profilePicture.translatesAutoresizingMaskIntoConstraints = false
       profilePicture.layer.cornerRadius = 30
       profilePicture.layer.masksToBounds = true
       profilePicture.contentMode = .scaleAspectFill
       profilePicture.image = UIImage(named: "placeholder")
       return profilePicture
    }()
    
    lazy var username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var acceptButton: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.09, green: 0.64, blue: 0.68, alpha: 1.00)
        label.text = "Accept"
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteButton: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.text = "Delete"
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       
       
       override func layoutSubviews() {
           super.layoutSubviews()
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
           super.init(style: .default, reuseIdentifier: "RequestCell")
           setupview()
           
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    func setupview() {
        
        addSubview(profilePicture)
        addSubview(username)
        addSubview(acceptButton)
        addSubview(deleteButton)
           
    //profilePicture constraints
       profilePicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
       profilePicture.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       profilePicture.widthAnchor.constraint(equalToConstant: 60).isActive = true
       profilePicture.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    //username constraints
       username.leftAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: 8).isActive = true
       username.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       username.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
       username.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
        
    //acceptButton constraints
       acceptButton.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -4).isActive = true
       acceptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       acceptButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
       acceptButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    //deleteButton constraints
       deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       deleteButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
       deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
       deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        
        
       }

}
