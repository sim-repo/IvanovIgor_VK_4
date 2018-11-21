import Foundation
import RealmSwift

class DatabaseService {
    
    static var configuration: Realm.Configuration {
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }
    
    @discardableResult
    static func realmSave<Element: Object>(items: [Element], config: Realm.Configuration = Realm.Configuration.defaultConfiguration, update: Bool = true) -> Realm? {
        
        do {
            let realm = try Realm(configuration: config)
            
           // print(realm.configuration.fileURL ?? "")
            
            try realm.write {
                realm.add(items, update: update)
            }
            
            return realm
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static func realmLoad<Element: Object>(clazz: Element.Type, sortField: String) -> Results<Element>? {
        var res: Results<Element>?
        do {
            let realm = try Realm()
            res = realm.objects(clazz).sorted(byKeyPath: sortField)
        } catch {
            print(error.localizedDescription)
        }
        return res
    }
 
}
