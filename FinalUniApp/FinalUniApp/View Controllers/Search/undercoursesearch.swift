//
//  undercoursesearch.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 29/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

extension CoursePage: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularcourses.prefix(11).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! unicollectioncell
        let course = popularcourses[indexPath.item]
        cell.textLabel.text = course.name
        if let count = course.count {
            cell.countLabel.text = "\(String(describing: count)) Students"
        }
        cell.layer.borderColor = UIColor(red: 0.00, green: 0.70, blue: 0.93, alpha: 1.00).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 14
        cell.layer.masksToBounds = true
        //cell.backgroundColor = .systemBlue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (collectionView.frame.width * (1/24)), height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Course = popularcourses[indexPath.item]
        guard let course = Course.name else {return}
        let listofusersfromcourse = ListOfUsersFromCourse()
        listofusersfromcourse.Course = course
        navigationController?.pushViewController(listofusersfromcourse, animated: true)
    }
    
}
