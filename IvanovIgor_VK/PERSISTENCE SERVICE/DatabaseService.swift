import Foundation
import RealmSwift

class DatabaseService {
    
    static var configuration: Realm.Configuration {
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }
    
    @discardableResult
    static func realmSave<Element: Object>(items: [Element], config: Realm.Configuration = Realm.Configuration.defaultConfiguration, update: Bool = true, dml: DML) -> Realm? {
        
        do {
            let realm = try Realm(configuration: config)
            
            print(realm.configuration.fileURL ?? "")
            
            switch dml {
            case .insert, .update:
                try realm.write {
                    realm.add(items, update: update)
                }
            case .delete:
                try realm.write {
                    realm.delete(items)
                }
            }
            
            
            return realm
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    
    static func realmLoad<Element: Object>(clazz: Element.Type) -> Results<Element>? {
        var res: Results<Element>?
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "")
            res = realm.objects(clazz)
        } catch {
            print(error.localizedDescription)
        }
        return res
    }
}
