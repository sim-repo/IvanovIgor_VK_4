import Foundation
import Firebase


struct FIBGroup: Codable {
    let groupName: String?
    
    var toAnyObject: Any {
        return [
            "groupName": groupName
        ]
    }
}



struct FIBUser {
    let uid: String
    var groupsName: [FIBGroup] = []
    let ref: DatabaseReference?
    
    
    func toAnyObject() -> Any {
        return [
                "uid": uid,
                "groups":groupsName.map{ $0.toAnyObject}
        ]
    }

}


