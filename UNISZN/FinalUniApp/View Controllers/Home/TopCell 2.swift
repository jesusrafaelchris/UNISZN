//
//  TopCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 14/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class TopCell: UITableViewCell {
    
    var profilebuttonAction : ( () -> () )?
    
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textColor = .black
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        usernameLabel.minimumScaleFactor = 0.5
        usernameLabel.adjustsFontSizeToFitWidth = true
        return usernameLabel
    }()
    
    lazy var countryFlag: UILabel = {
        let countryFlag = UILabel()
        countryFlag.translatesAutoresizingMaskIntoConstraints = false
        countryFlag.font = UIFont(name: "AppleColorEmoji", size: 40)
        return countryFlag
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile(gesture:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.cancelsTouchesInView = false
        self.usernameLabel.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
    
    @objc func goToProfile(gesture: UITapGestureRecognizer){
        print("click")
        profilebuttonAction!()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        setupview() 
    }

   func setupview() {
    
    self.addSubview(usernameLabel)
    self.addSubview(countryFlag)
    
    // usernameLabel
    usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    usernameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
    usernameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
    
    //countryflag
    countryFlag.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    countryFlag.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 10).isActive = true
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default ,reuseIdentifier: "TopCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
}
