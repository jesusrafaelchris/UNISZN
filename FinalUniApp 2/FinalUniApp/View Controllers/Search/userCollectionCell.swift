//
//  userCollectionCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 23/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class userCollectionCell: UICollectionViewCell {
    
    lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        return profileImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    func setupView() {
        self.addSubview(profileImage)
        
    //profileImage constraints
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        profileImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
