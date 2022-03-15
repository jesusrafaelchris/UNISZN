//
//  ProfilePicturestruct.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 12/07/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import Foundation

class ProfilePicturestruct: NSObject {
    
    @objc var profilePicUrl: String?
    @objc var username: String?
    @objc var uid: String?
    
    init(dictionary: [String:Any]) {
    super.init()
        profilePicUrl = dictionary["ProfilePicUrl"] as? String
        username = dictionary["username"] as? String
        uid = dictionary["uid"] as? String
    }
}
