import UIKit
import SwiftyJSON

class MyFriend : BaseModel{
    
    enum FriendGroupByType: String {
        case firstName = "По Имени"
        case lastName = "По Фамилии"
    }
    
    enum IgnoredType: String{
        case profilePictureImage50
        case profilePictureImage200
        case xFirstName
    }
    
    enum FriendImagesType: Int{
        case profilePictureImage50
        case profilePictureImage200
    }
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var profilePictureURL50: String?
    @objc dynamic var profilePictureURL200: String?
    
    var profilePictureImage50: UIImage?
    var profilePictureImage200: UIImage?
    var photos:[String] = []
    
    // service fields
    var xFirstName: String = ""
    var xLastName: String = ""
    var groupBy: FriendGroupByType = .firstName
    
    convenience init(json: JSON?){
        self.init()
        setup(json: json)
    }

    override func setup(json: JSON?){
        if let json = json {
            self.id = json["id"].intValue
            self.firstName = json["first_name"].stringValue
            self.xFirstName = firstName
            self.lastName = json["last_name"].stringValue
            self.profilePictureURL50 = json["photo_50"].stringValue
            self.profilePictureURL200 = json["photo_200_orig"].stringValue
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return [IgnoredType.profilePictureImage50.rawValue,
                IgnoredType.profilePictureImage200.rawValue,
                IgnoredType.xFirstName.rawValue]
    }
    
    override static func indexedProperties() -> [String]{
        return [FriendGroupByType.firstName.rawValue]
    }
    
    override func getGroupByField()->String {
        switch groupBy {
        case .firstName:
            return self.firstName
        case .lastName:
            return self.lastName
        }
    }
    
    override func getXGroupByField()->String {
        switch groupBy {
        case .firstName:
            return self.xFirstName
        case .lastName:
            return self.xLastName
        }
    }

    
    override func updateXGroupByField(val: String) {
        switch groupBy {
        case .firstName:
            xFirstName = val
        case .lastName:
            xLastName = val
        }
    }
}


