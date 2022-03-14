//
//  UserPageUnderCollectionView.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 22/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SkeletonView

public protocol SkeletonCollectionViewDataSource: UICollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier
}


extension UsersPage: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePictures.prefix(12).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! userCollectionCell
        
            cell.layer.cornerRadius = 20
            cell.layer.masksToBounds = true
            let image = profilePictures[indexPath.item]
            cell.profileImage.kf.setImage(with: URL(string: image))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item at \(indexPath.section)/\(indexPath.item) tapped")
    }
}

extension UsersPage: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 12
        let totalHorizontalSpacing = (columns - 1) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)

        return itemSize

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func getProfilePictures() {
        docRef.order(by: "Created", descending: true).getDocuments { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else {
                for user in snapshot!.documents {
                    let data = user.data()
                    guard let profilePic = data["ProfilePicUrl"] as? String else {return}
                    
                    if self.profilePictures.count <= 11 {
                        self.profilePictures.append(profilePic)
                    }
                    self.collectionView.reloadData()
                }
                
            }
            DispatchQueue.main.async {
            self.collectionView.reloadData()
            }
        }
    }
}

extension UsersPage: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePictures.count
    }
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CollectionViewCell"
    }
    
    
    
}
