import Foundation
import SwiftyJSON
import RealmSwift

protocol ModelProtocol: class {
    func getId()->Int
    func setup(json: JSON?)
    init() // need for AlamofireNetworkManager.parseJSON
    func postInit() // temporary
}

 // Задание 5: рефакторинг >>>
extension ModelProtocol {
    
    func notify(url: URL?, _ notificationType: Model2PresenterNotification, completion: ((_ image: Data)->Void)? = nil){
        NotificationCenter.default.post(notification: notificationType, object: nil, userInfo: ["url": url, "completion": completion])
    }
    
    func notify(model: ModelProtocol, _ notificationType: Model2PresenterNotification){
        NotificationCenter.default.post(notification: notificationType, object: nil, userInfo: ["model": model])
    }
}
 // Задание 5: рефакторинг <<<

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
}
