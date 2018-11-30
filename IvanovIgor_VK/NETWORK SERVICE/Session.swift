import Foundation

class Session {
    static let shared = Session()
    lazy var user: FIBUser = FIBUser(uid: "\(userId)", groupsName: [], ref: nil)
    
    private init(){}
    
    var token = ""
    var userId = Int()
}
