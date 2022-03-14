//
//  zoomedPhoto.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 30/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Kingfisher

class zoomedPhoto: UIViewController {

    var image = String()
    
    lazy var Image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()
    
    var p = Profile()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(Image)
        view.backgroundColor = .black
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Dismiss(gesture:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
        Image.kf.setImage(with: URL(string: image))
        Image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        Image.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        Image.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        Image.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    @objc func Dismiss(gesture: UITapGestureRecognizer) {
        //hero.dismissViewController()
        self.dismiss(animated: true) {
        }
    }
    

}
