import Foundation
import RealmSwift

class MyPhotosPersistence: Object {
    @objc dynamic var id = 0
    @objc dynamic var photoURL = ""
    
    convenience init(id: Int, photoURL: String) {
        self.init()
        self.id = id
        self.photoURL = photoURL
        
        // saving
        saveOrUpdate()
    }
    
    func saveOrUpdate(){
        guard let ret = realmLoad(clazz: MyPhotosPersistence.self)
            else {
                return
        }
        
        for r in ret {
            if let rec = r as? MyPhotosPersistence {
                // check something...
            }
        }
        realmSave(obj: self)
    }
    
    static func loadPersistence()->[MyPhotosPersistence]?{
        var res: [MyPhotosPersistence]? = []
        guard let ret = realmLoad(clazz: MyPhotosPersistence.self)
            else {
                return nil
        }
        
        for r in ret {
            if let rec = r as? MyPhotosPersistence {
                res?.append(rec)
            }
        }
        return res
    }
}
