//
//  UserPageUnderCollectionView.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 22/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import Nuke

extension UsersPage: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! userCollectionCell
        
        cell.layer.cornerRadius = 20//cell.frame.size.width / 2
        cell.layer.masksToBounds = true
        let imagearr = profilePictures[indexPath.item]
        if let image = imagearr.profilePicUrl {
            if let url = URL(string: image) {
                Nuke.loadImage(with: url, into: cell.profileImage)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newusers = profilePictures[indexPath.item]
        guard let UID = newusers.uid else {return}
        let searchprofile = SearchProfile()
        searchprofile.uid = UID
        navigationController?.pushViewController(searchprofile, animated: true)
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

        listener = docRef.order(by: "Created", descending: true).limit(to: 12).addSnapshotListener( {  (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.profilePictures.removeAll()
                for user in snapshot!.documents {
                    let data = user.data()
                    guard let dictionary = data as [String:AnyObject]? else {return}
                    let Info = ProfilePicturestruct(dictionary: dictionary)
                        self.profilePictures.append(Info)
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
}

