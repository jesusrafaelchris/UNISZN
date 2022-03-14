//
//  MessageCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
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
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 74, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 74, y: detailTextLabel!.frame.origin.y + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
        
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
        
    //timeLabel constraints
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        
    //detailtext constrainnts
//        self.detailTextLabel?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
//        self.textLabel?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
    }
    
}
