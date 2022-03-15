//
//  courseArray.swift
//  coords
//
//  Created by Christian Grinling on 25/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase

class RelatedCourses {

    var output = [String]()
    let dispatchGroup = DispatchGroup()
    
    func getRelatedCourses(userCourse: String?, completion: @escaping (_ result: [String]?) -> Void) {

            if userCourse == "" {
                print("course is empty")
            }
                
        else {
                
        guard let Usercourse = userCourse else {return}
        let ref = Firestore.firestore().collection("SupportedCourses").whereField(Usercourse, isEqualTo: true)
        ref.getDocuments { (snapshot, error) in
            
        guard let documents = snapshot?.documents else {return}
            
            for document in documents {
                    
                    let data = document.data()
                    let courses = data.keys
                    self.output.append(contentsOf: courses)
                        completion(self.output)
                }
            }
        }
    }
}
