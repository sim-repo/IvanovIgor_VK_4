import Foundation

class Session {
    static let shared = Session()
    private init(){}
    
    var token = ""
    var userId = Int()
}
