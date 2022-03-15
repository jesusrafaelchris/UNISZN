//
//  MiddleCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 14/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class MiddleCell: UITableViewCell {
    
    lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        return profileImage
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
     
    override func layoutSubviews() {
        self.addSubview(profileImage)
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        profileImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
