//
//  ClosestUnis.swift
//  coords
//
//  Created by Christian Grinling on 25/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Firebase

class ClosestUnis {
    
    var distances = [Distances]()
    var output = [String]()
    
    func getMyUniCoords(_ university: String, completion: @escaping (_ unis: CLLocation) -> Void) {
            let userUniRef = Firestore.firestore().collection("SupportedUniversities").document(university)
            userUniRef.getDocument { (snapshot, error) in
                guard let data = snapshot?.data() else {return}
                guard let Latitude = data["Latitude"] as? Double else {return}
                guard let Longitude = data["Longitude"] as? Double else {return}
                let UniLocation = CLLocation(latitude: Latitude, longitude: Longitude)
                completion(UniLocation)
        }
    }
        let dispatchGroup = DispatchGroup()
        
    func getClosestUnis(_ Uni: String, completion: @escaping ([String]) -> Void) {
            self.dispatchGroup.enter()
            getMyUniCoords(Uni) { (UniLocation) in
            defer{ self.dispatchGroup.leave() }
                let otherUniRef = Firestore.firestore().collection("SupportedUniversities")
                self.dispatchGroup.enter()
                otherUniRef.getDocuments { (snapshot, error) in
                    defer{ self.dispatchGroup.leave() }
                        guard let documents = snapshot?.documents else {return}
                        for document in documents {
                            let data = document.data()
                            guard let Latitude = data["Latitude"] as? Double else {return}
                            guard let Longitude = data["Longitude"] as? Double else {return}
                            guard let uni = data["University"] as? String else {return}
                            let NextDestination = CLLocation(latitude: Latitude, longitude: Longitude)
                            let distance = UniLocation.distance(from: NextDestination) / 1000
                            let sequence = Distances(Uni: uni, distance: distance)
                            self.distances.append(sequence)
                            self.distances.sort { (distance1, distance2) -> Bool in
                            return Int(distance2.distance) > Int(distance1.distance)
                            }
                        }
                    }
                }
            
            self.dispatchGroup.notify(queue: .main) {
                let array = self.distances.prefix(5)
                for i in (0...array.count - 1)  {
                    let result = array[i].Uni
                    if result == Uni {}
                    else {
                        let s = (array[i].Uni)
                        self.output.append(s)
                    }
                }
                completion(self.output)
            }
        }
    
}

struct Distances {
    var Uni: String
    var distance: Double
}
