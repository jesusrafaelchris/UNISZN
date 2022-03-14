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

class ClosestUnis {
    
    var distances = [Distances]()
    var output = [String]()
    
    let unicoords: [(String,(Double,Double))] = [("University of Cambridge", (52.2042666,0.1127198)),
    ("University of Oxford", (51.7548164,-1.2565555)),
    ("University of St Andrews", (56.3417136,-2.7964561)),
    ("London School of Economics and Politics", (51.5144388,-0.11864)),
    ("Imperial College London", (51.4987997,-0.1770659)),
    ("University of Bath", (51.3782228,-2.3285874)),
    ("UCL", (51.5245592,-0.1362288)),
    ("University of Warwick", (52.3792525,-1.5636591)),
    ("University of Exeter", (50.7371369,-3.5373362)),
    ("University of Birmingham", (52.4508168,-1.9327022)),
    ("University of Bristol", (51.4584172,-2.6051679)),
    ("University of Edinburgh", (55.9445158,-3.19143)),
    ("University of Leeds", (53.8066815,-1.5572215)),
    ("University of Manchester", (53.4668498,-2.2360724)),
    ("University of Southampton", (50.9155989,-1.4326799)),
    ("University of Glasgow", (55.8721211,-4.2903892)),
    ("University of Nottingham", (52.938636,-1.1973469)),
    ("King's College London", (51.5114864,-0.1181857)),
    ("University of York", (53.9461089,-1.0539605)),
    ("Royal Holloway, University of London", (51.425673,-0.5652512)),
    ("University of East Anglia UEA", (52.6219215,1.2369874)),
    ("University of Aberdeen", (57.16476,-2.1037144)),
    ("Queen's University Belfast", (54.5844087,-5.936238)),
    ("University of Sheffield", (53.3809409,-1.4901356)),
    ("University of Dundee", (56.4582447,-2.9843315)),
    ("University of Liverpool", (53.4047824,-2.9674877)),
    ("University of Surrey", (51.2427533,-0.5899642)),
    ("University of Strathclyde", (55.8621112,-4.244579)),
    ("Queen Mary University of London", (51.5240671,-0.0425632)),
    ("SOAS University of London", (51.52235,-0.1314477)),
    ("University of Leicester", (52.6211393,-1.1268212)),
    ("University of Reading", (51.4414205,-0.9440044)),
    ("University of Sussex", (50.8670895,-0.0901027)),
    ("University of Essex", (51.8777259,0.9450182)),
    ("Harper Adams University", (52.7794512,-2.4293233)),
    ("Aston University, Birmingham", (52.4868584,-1.8904061)),
    ("University for the Creative Arts", (51.2150866,-0.8075617)),
    ("University of Stirling", (56.1454119,-3.92276)),
    ("Nottingham Trent University", (52.9580712,-1.1562113)),
    ("University of Kent", (51.297233,1.0610285)),
    ("Oxford Brookes University", (51.755011,-1.2264137)),
    ("Arts University Bournemouth", (50.7410205,-1.9002356)),
    ("University of Lincoln", (53.2279107,-0.552382) )]
    
    func getClosestUnis(University: String) -> [String] {
        let dictionary = unicoords.reduce(into: [:]) { $0[$1.0] = $1.1 }

        //My location
        let Uni = University
        let UniLocation = CLLocation(latitude: dictionary[Uni]!.0, longitude: dictionary[Uni]!.1)

        //My Next Destination
        for uni in dictionary {
            let NextDestination = CLLocation(latitude: uni.value.0 , longitude: uni.value.1)
            //Finding my distance to my next destination (in km)
            let distance = UniLocation.distance(from: NextDestination) / 1000
            //print(uni.key, distance)
            let sequence = Distances(Uni: uni.key, distance: distance)
            distances.append(sequence)

        }
        distances.sort { (distance1, distance2) -> Bool in
            return Int(distance2.distance) > Int(distance1.distance)
            }
        
        let array = distances.prefix(6)
        for i in (1...5) {
            let s = (array[i].Uni)
            output.append(s)
        }
        return output
    }
    
    
}

struct Distances {
    var Uni: String
    var distance: Double
}
