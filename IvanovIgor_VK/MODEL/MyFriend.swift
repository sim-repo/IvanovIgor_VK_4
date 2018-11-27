import UIKit
import SwiftyJSON

class MyFriend : BaseModel{
    
    enum FriendSortType: String {
        case firstName
        case lastName
    }
    
    enum IgnoredType: String{
        case profilePictureImage50
        case profilePictureImage200
        case xFirstName
    }
    
    enum ImagesType: Int{
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
    var sorting: FriendSortType = .firstName
    
    convenience init(json: JSON?){
        self.init()
        setup(json: json)
    }
    
//    convenience init(id: Int, firstName: String, lastName: String, profilePictureURL50: String, profilePictureURL200: String) {
//        self.init()
//        self.id = id
//        self.firstName = firstName
//        self.lastName = lastName
//        self.profilePictureURL200 = profilePictureURL50
//        self.profilePictureURL200 = profilePictureURL200
//    }
    
    func getSortingField()->String {
        switch sorting {
        case .firstName:
            return self.firstName
        case .lastName:
            return self.lastName
        }
    }
    
    func getXSortingField()->String {
        switch sorting {
        case .firstName:
            return self.xFirstName
        case .lastName:
            return self.xLastName
        }
    }
    
    func updateXSortingField(val: String) {
        switch sorting {
        case .firstName:
            xFirstName = val
        case .lastName:
            xLastName = val
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return [IgnoredType.profilePictureImage50.rawValue,
                IgnoredType.profilePictureImage200.rawValue,
                IgnoredType.xFirstName.rawValue]
    }
    
    override static func indexedProperties() -> [String]{
        return [FriendSortType.firstName.rawValue]
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
}


