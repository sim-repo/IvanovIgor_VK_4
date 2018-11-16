import Foundation
import RealmSwift

class MyFriendPersistence: Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic  var lastName = ""
    @objc dynamic var profilePictureURL50 = ""
    @objc dynamic var profilePictureURL200 = ""
    
    convenience init(id: Int, firstName: String, lastName: String, profilePicURL50: String, profilePicURL200: String) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePictureURL50 = profilePicURL50
        self.profilePictureURL200 = profilePicURL200
        
        // saving
        saveOrUpdate()
    }
    
    func saveOrUpdate(){
        guard let ret = realmLoad(clazz: MyFriendPersistence.self)
            else {
                return
            }
        
        for r in ret {
            if let rec = r as? MyFriendPersistence {
               // check something...
            }
        }
        realmSave(obj: self)
    }
    
    static func loadPersistence()->[MyFriendPersistence]?{
        var res: [MyFriendPersistence]? = []
        guard let ret = realmLoad(clazz: MyFriendPersistence.self)
            else {
                return nil
        }
        
        for r in ret {
            if let rec = r as? MyFriendPersistence {
               res?.append(rec)
            }
        }
        return res
    }
    
}
