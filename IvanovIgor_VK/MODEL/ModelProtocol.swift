import Foundation
import SwiftyJSON
import RealmSwift

protocol ModelProtocol: class {
    func getId()->Int
    func setup(json: JSON?)
    init() // need for AlamofireNetworkManager.parseJSON
    func getGroupByField()->String
    func getXGroupByField()->String
    func updateXGroupByField(val: String)
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
    
    func getGroupByField()->String {
        return ""
    }
    
    func getXGroupByField()->String {
        return ""
    }
    
    func updateXGroupByField(val: String) {
    }
}
