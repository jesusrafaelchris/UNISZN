//
//  zoomedPhoto.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 30/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Nuke

class zoomedPhoto: UIViewController, UIScrollViewDelegate {

    var image = String()
    
    lazy var Image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var scrollview: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .black
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Dismiss(gesture:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
        guard let url = URL(string: image) else {return}
        Nuke.loadImage(with: url, into: Image)
        scrollview.delegate = self
        scrollview.minimumZoomScale = 1.0
        scrollview.maximumZoomScale = 5.0
        scrollview.bouncesZoom = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return Image
    }
    
    @objc func Dismiss(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidLayoutSubviews() {
        Image.contentMode = .scaleAspectFit
        Image.layer.masksToBounds = true
        scrollview.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func setupView() {
        view.addSubview(scrollview)
        scrollview.addSubview(Image)
        
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        Image.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        Image.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    

}
