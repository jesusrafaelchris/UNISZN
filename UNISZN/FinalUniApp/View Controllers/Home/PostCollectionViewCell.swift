//
//  PostCollectionViewCell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 20/09/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    private var showingBack = false
    
    lazy var frontImageView: UIImageView = {
        let Image = UIImageView()
        Image.translatesAutoresizingMaskIntoConstraints = false
        Image.layer.masksToBounds = true
        Image.contentMode = .scaleAspectFill
        Image.image = UIImage(named: "placeholder")
        return Image
    }()
    
    lazy var postImagecontainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let Image = UIImageView()
        Image.translatesAutoresizingMaskIntoConstraints = false
        Image.layer.masksToBounds = true
        Image.layer.cornerRadius = 25
        Image.contentMode = .scaleAspectFit
        return Image
    }()
    
    lazy var aboveNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reportuserbutton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "flag"), for: .normal)
        return button
    }()
    
    lazy var postBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var belowNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var LikeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var TopContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var BottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        postImagecontainer.addGestureRecognizer(singleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    func setupView() {
        
        //above image
        self.addSubview(TopContainerView)
        TopContainerView.addSubview(profileImageView)
        TopContainerView.addSubview(aboveNameLabel)
        TopContainerView.addSubview(reportuserbutton)
        TopContainerView.addSubview(timeLabel)
        
        //Image
        self.addSubview(postImagecontainer)
        postImagecontainer.addSubview(frontImageView)
        
        //below Image
        self.addSubview(BottomContainerView)
        BottomContainerView.addSubview(belowNameLabel)
        BottomContainerView.addSubview(captionLabel)
        BottomContainerView.addSubview(likesLabel)
        BottomContainerView.addSubview(LikeButton)
        
    ///above Image
        
    //TopContainerView
        TopContainerView.backgroundColor = .cyan
        TopContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        TopContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        TopContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        TopContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    //profileImage
        profileImageView.backgroundColor = .green
        profileImageView.leftAnchor.constraint(equalTo: TopContainerView.leftAnchor, constant: 15).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: TopContainerView.centerYAnchor).isActive = true
        
    //name
        aboveNameLabel.text = "Christian Grinling"
        aboveNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        aboveNameLabel.centerYAnchor.constraint(equalTo: TopContainerView.centerYAnchor).isActive = true
    
    //flag
        reportuserbutton.rightAnchor.constraint(equalTo: TopContainerView.rightAnchor, constant: -30).isActive = true
        reportuserbutton.centerYAnchor.constraint(equalTo: TopContainerView.centerYAnchor).isActive = true
        
    //timelabel
        timeLabel.text = "33m ago"
        timeLabel.centerXAnchor.constraint(equalTo: reportuserbutton.centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: reportuserbutton.bottomAnchor, constant: 5).isActive = true
    
    ///Image
        
        postImagecontainer.topAnchor.constraint(equalTo: TopContainerView.bottomAnchor).isActive = true
        postImagecontainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        postImagecontainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
        postImagecontainer.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        frontImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        frontImageView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        postBackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        postBackView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
    ///BelowImage
        
    //BottomContainerView
        BottomContainerView.backgroundColor = .systemPink
        BottomContainerView.topAnchor.constraint(equalTo: postImagecontainer.bottomAnchor).isActive = true
        BottomContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        BottomContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        BottomContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    //belowname
        belowNameLabel.text = "Christian Grinling"
        belowNameLabel.leftAnchor.constraint(equalTo: BottomContainerView.leftAnchor, constant: 15).isActive = true
        belowNameLabel.centerYAnchor.constraint(equalTo: BottomContainerView.centerYAnchor).isActive = true
        
    //caption
        captionLabel.text = "This is a cool caption"
        captionLabel.leftAnchor.constraint(equalTo: belowNameLabel.rightAnchor, constant: 8).isActive = true
        captionLabel.centerYAnchor.constraint(equalTo: BottomContainerView.centerYAnchor).isActive = true
        
    //likebutton
        LikeButton.rightAnchor.constraint(equalTo: BottomContainerView.rightAnchor, constant: -15).isActive = true
        LikeButton.centerYAnchor.constraint(equalTo: BottomContainerView.centerYAnchor).isActive = true
      
    //likenumber
        likesLabel.text = "1,024 Likes"
        likesLabel.rightAnchor.constraint(equalTo: LikeButton.leftAnchor, constant: -8).isActive = true
        likesLabel.centerYAnchor.constraint(equalTo: BottomContainerView.centerYAnchor).isActive = true
        
  
    }
    
    @objc func flip() {
        let toView = showingBack ? frontImageView : postBackView
        let fromView = showingBack ? postBackView : frontImageView
        UIView.transition(from: fromView, to: toView, duration: 0.4, options: .transitionFlipFromRight, completion: nil)
        toView.translatesAutoresizingMaskIntoConstraints = false
        showingBack = !showingBack
    }
    
}
