//
//  ProfileImagecell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 30/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class ProfileImagecell: UICollectionViewCell, UIScrollViewDelegate {
    
    lazy var imageView: UIImageView = {
        let Picture1 = UIImageView()
        Picture1.image = UIImage(named: "addPhoto")
        Picture1.contentMode = .scaleAspectFill
        Picture1.layer.masksToBounds = true
        Picture1.translatesAutoresizingMaskIntoConstraints = false
        Picture1.isUserInteractionEnabled = true
        return Picture1
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
