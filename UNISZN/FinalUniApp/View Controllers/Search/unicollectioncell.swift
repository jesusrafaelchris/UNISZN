//
//  unicollection cell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 29/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class unicollectioncell: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.5
        //text.textColor = .white
        return text
    }()
    
    lazy var countLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        //text.textColor = .white
        return text
    }()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.addSubview(textLabel)
        self.addSubview(countLabel)
        
    //textlabel constraints
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        
    //countlabel constraints
        countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        countLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10).isActive = true

    }
}
