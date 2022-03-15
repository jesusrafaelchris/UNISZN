//
//  FetchingUsersLogic.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 25/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import Foundation
import Firebase

class FetchingUsersLogic {
    
    var sameUniSameCourse = [UserInfo]()
    
       func SameUniSameCourse() -> [UserInfo] {
            service.loadUniversityAndCourse { (uni, course) in
                let usersRef = Firestore.firestore().collection("users").whereField("University", isEqualTo: uni).whereField("Course", isEqualTo: course)
                usersRef.getDocuments { (snapshot, error) in
                    
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        if let dictionary = data as [String:AnyObject]? {
                        let Info = UserInfo(dictionary: dictionary)
                            self.sameUniSameCourse.append(Info)
                            }
            }}}}
            return sameUniSameCourse
    }
    
    
    
    
    
}
