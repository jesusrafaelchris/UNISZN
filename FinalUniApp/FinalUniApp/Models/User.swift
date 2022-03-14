//
//  User.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 10/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class User: NSObject {
    @objc var FirstName: String?
    @objc var Course: String?
    @objc var University: String?
    @objc var Surname: String?
    @objc var uid:String?
    @objc var ProfilePicUrl: String?
    @objc var username: String?
    @objc var BioText: String?
    @objc var Picture1: String?
    @objc var Picture2: String?
    @objc var Picture3: String?
    @objc var Created: NSDate?
    @objc var countryFlag: String?
    @objc var NotificationToken: String?
    
    init(dictionary: [String: AnyObject]) {
        self.FirstName = dictionary["FirstName"] as? String
        self.username = dictionary["username"] as? String
        self.Course = dictionary["Course"] as? String
        self.University = dictionary["University"] as? String
        self.Surname = dictionary["Surname"] as? String
        self.uid = dictionary["uid"] as? String
        self.ProfilePicUrl = dictionary["ProfilePicUrl"] as? String
        self.BioText = dictionary["BioText"] as? String
        self.Picture1 = dictionary["Picture1"] as? String
        self.Picture2 = dictionary["Picture2"] as? String
        self.Picture3 = dictionary["Picture3"] as? String
        self.Created = dictionary["Created"] as? NSDate
        self.countryFlag = dictionary["countryFlag"] as? String
        self.NotificationToken = dictionary["NotificationToken"] as? String
    }
}
