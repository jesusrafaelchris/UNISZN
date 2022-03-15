//
//  UserInfo.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 14/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UserInfo: NSObject {
    @objc var FirstName: String?
    @objc var Course: String?
    @objc var University: String?
    @objc var Surname: String?
    @objc var uid:String?
    @objc var ProfilePicUrl: String?
    @objc var username: String?
    @objc var Created: Timestamp?
    @objc var NotificationToken: String?
    @objc var CountryFlag: String?
    
     init(dictionary: [String:Any]) {
         super.init()
         
         FirstName = dictionary["FirstName"] as? String
         uid = dictionary["uid"] as? String
         Surname = dictionary["Surname"] as? String
         Course = dictionary["Course"] as? String
         University = dictionary["University"] as? String
         ProfilePicUrl = dictionary["ProfilePicUrl"] as? String
         username = dictionary["username"] as? String
         Created = dictionary["Created"] as? Timestamp
         NotificationToken = dictionary["NotificationToken"] as? String
         CountryFlag = dictionary["countryFlag"] as? String
     }
    
    override var description:String {
        let seconds = Double(self.Created!.seconds)
        let timeStampDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y"
        let date = dateFormatter.string(from: timeStampDate as Date)
        
        return "\(String(describing: self.University!)),\(String(describing: date))\n"
    }
}
