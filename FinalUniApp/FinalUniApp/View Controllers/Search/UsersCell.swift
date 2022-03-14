//
//  UsersCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

     lazy var profilePicture: UIImageView = {
            let profilePicture = UIImageView()
            profilePicture.translatesAutoresizingMaskIntoConstraints = false
            profilePicture.layer.cornerRadius = 30
            profilePicture.layer.masksToBounds = true
            profilePicture.contentMode = .scaleAspectFill
            return profilePicture
        }()
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            textLabel?.frame = CGRect(x: 74, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)

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
            super.init(style: .default, reuseIdentifier: "UsersCell")
            addSubview(profilePicture)
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
        }
        
    }
