import Foundation
import RealmSwift


func realmSave(obj: Object) {
    do {
        let realm = try Realm()
        
        try realm.write {
            realm.add(obj)
        }
    } catch {
        print(error.localizedDescription)
    }
}

func realmLoad(clazz: Object.Type) -> Results<Object>? {
    var res: Results<Object>?
    do {
        let realm = try Realm()
        
        res = realm.objects(clazz)
    } catch {
        print(error.localizedDescription)
    }
    return res
}
