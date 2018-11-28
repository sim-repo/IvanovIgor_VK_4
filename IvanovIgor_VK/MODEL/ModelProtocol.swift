import Foundation
import SwiftyJSON
import RealmSwift

protocol ModelProtocol: class {
    func getId()->Int
    func setup(json: JSON?)
    init() // need for AlamofireNetworkManager.parseJSON
    func getSortingField()->String
}

class BaseModel: Object, ModelProtocol {
    
    @objc dynamic var id = 0
    
    func getId()->Int{
        return id
    }
    func setup(json: JSON?) {}
    func postInit() {}
    
    
    enum Key: String {
        case id
    }
    
    override static func primaryKey() -> String? {
        return Key.id.rawValue
    }
    
    func getSortingField()->String {
        return ""
    }
}
