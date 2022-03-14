//
//  BottomCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 14/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class BottomCell: UITableViewCell {
    
    lazy var UniversityLabel: UILabel = {
        let UniversityLabel = UILabel()
        UniversityLabel.translatesAutoresizingMaskIntoConstraints = false
        UniversityLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        UniversityLabel.textColor = .black
        UniversityLabel.minimumScaleFactor = 0.5
        UniversityLabel.adjustsFontSizeToFitWidth = true
        return UniversityLabel
    }()
    
    lazy var CourseLabel: UILabel = {
        let CourseLabel = UILabel()
        CourseLabel.translatesAutoresizingMaskIntoConstraints = false
        CourseLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        CourseLabel.textColor = .black
        CourseLabel.minimumScaleFactor = 0.5
        CourseLabel.adjustsFontSizeToFitWidth = true
        return CourseLabel
    }()
    
    lazy var courseImageView: UIImageView = {
        let courseImageView = UIImageView()
        courseImageView.image = UIImage(named: "course")
        courseImageView.contentMode = .scaleAspectFill
        courseImageView.translatesAutoresizingMaskIntoConstraints = false
        //courseImageView.layer.masksToBounds = true
        return courseImageView
    }()
    
    lazy var UniImageView: UIImageView = {
        let UniImageView = UIImageView()
        UniImageView.image = UIImage(named: "uni")
        UniImageView.contentMode = .scaleAspectFill
        UniImageView.translatesAutoresizingMaskIntoConstraints = false
        //UniImageView.layer.masksToBounds = true
        return UniImageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //.backgroundColor = UIColor(red: 54/255, green: 117/255, blue: 136/255, alpha: 1.0)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        setupView()
    }

    func setupView() {
        self.addSubview(CourseLabel)
        self.addSubview(UniversityLabel)
        self.addSubview(courseImageView)
        self.addSubview(UniImageView)
       
    //UniversityLabel constraints
        UniversityLabel.leftAnchor.constraint(equalTo: UniImageView.rightAnchor, constant: 16).isActive = true
        UniversityLabel.centerYAnchor.constraint(equalTo: UniImageView.centerYAnchor).isActive = true
        UniversityLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        
    //CourseLabel constraints
        CourseLabel.leftAnchor.constraint(equalTo: courseImageView.rightAnchor, constant: 16).isActive = true
        CourseLabel.topAnchor.constraint(equalTo: UniversityLabel.bottomAnchor).isActive = true
        CourseLabel.centerYAnchor.constraint(equalTo: courseImageView.centerYAnchor).isActive = true
        UniversityLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        
     //UniImageView constraints
        UniImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        UniImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 3).isActive = true
        UniImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        UniImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
     //courseImageView constraints
        courseImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        courseImageView.topAnchor.constraint(equalTo: UniImageView.bottomAnchor, constant: 5).isActive = true
        courseImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        courseImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    
    }
}
