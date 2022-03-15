////
////  Testing.swift
////  FinalUniApp
////
////  Created by Christian Grinling on 30/08/2020.
////  Copyright © 2020 Christian Grinling. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class Testing: UIViewController {
//
//    var unis = [
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let ref = Firestore.firestore().collection("UniversityList").document("Total")
//        for uni in unis {
//            ref.setData([uni: 1], merge: true) { (error) in
//                print("complete")
//            }
//        }
//    }
//}
