//
//  undersearchcell.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 28/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

extension UniversityPage: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularUnis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! unicollectioncell
        let uni = popularUnis[indexPath.item]
        cell.textLabel.text = uni.name
        if let count = uni.count {
            cell.countLabel.text = "\(String(describing: count)) Students"
        }
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 14
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (collectionView.frame.width * (1/24)), height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let university = popularUnis[indexPath.item]
        guard let uni = university.name else {return}
        let listofusersfromuni = ListOfUsersFromUniversity()
        listofusersfromuni.University = uni
        navigationController?.pushViewController(listofusersfromuni, animated: true)
    }
    
}


