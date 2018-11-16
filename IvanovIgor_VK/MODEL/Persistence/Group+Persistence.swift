import Foundation
import RealmSwift

class GroupPersistence: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic  var desc = ""
    @objc dynamic var imageURL50 = ""
    @objc dynamic var imageURL200 = ""
    
    convenience init(name: String, desc: String, imageURL50: String, imageURL200: String) {
        self.init()
        self.name = name
        self.desc = desc
        self.imageURL50 = imageURL50
        self.imageURL200 = imageURL200
        
        // saving
        saveOrUpdate()
    }
    
    func saveOrUpdate(){
        guard let ret = realmLoad(clazz: GroupPersistence.self)
            else {
                return
        }
        
        for r in ret {
            if let rec = r as? GroupPersistence {
                // check something...
            }
        }
        realmSave(obj: self)
    }
    
    static func loadPersistence()->[GroupPersistence]?{
        var res: [GroupPersistence]? = []
        guard let ret = realmLoad(clazz: GroupPersistence.self)
            else {
                return nil
        }
        
        for r in ret {
            if let rec = r as? GroupPersistence {
                res?.append(rec)
            }
        }
        return res
    }
}
