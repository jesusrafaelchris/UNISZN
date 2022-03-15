//
//  undercoursesearch.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 29/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import SkeletonView

extension CoursePage: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularcourses.prefix(11).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! unicollectioncell
        let course = popularcourses[indexPath.item]
        cell.textLabel.text = course.name
        cell.countLabel.text = "\(String(describing: course.count!)) Students"
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 14
        cell.layer.masksToBounds = true
        //cell.backgroundColor = .systemBlue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (collectionView.frame.width * (1/24)), height: 80)
    }
    
    
}
