







import Foundation
import UIKit
import Firebase

class messageInfo:NSObject {
    
   @objc var Text: String?
   @objc var ToID: String?
   @objc var FromID: String?
   @objc var TimeStamp: NSNumber?

    
    @objc var imageUrl: String?
    @objc var imageWidth: NSNumber?
    @objc var imageHeight: NSNumber?
 
    func chatPartner() -> String? {
        return FromID == Auth.auth().currentUser?.uid ? ToID : FromID
    }
    
    init(dictionary: [String:Any]) {
        super.init()
        
        FromID = dictionary["FromID"] as? String
        Text = dictionary["Text"] as? String
        ToID = dictionary["ToID"] as? String
        TimeStamp = dictionary["TimeStamp"] as? NSNumber
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
   
    }
    
  }
