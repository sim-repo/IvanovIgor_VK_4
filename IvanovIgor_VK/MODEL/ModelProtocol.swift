import Foundation
import SwiftyJSON
import RealmSwift

protocol ModelProtocol: class {
    var id: Int? {get set}
    init(json: JSON?)
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

class BaseModel: ModelProtocol{
    var id: Int?
    required init(json: JSON?) {}
}
