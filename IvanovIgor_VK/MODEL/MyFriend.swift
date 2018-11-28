import UIKit
import SwiftyJSON

class MyFriend : BaseModel{
    
    enum FriendGroupByType: String {
        case firstName = "По Имени"
        case lastName = "По Фамилии"
    }
    
    enum FriendImagesType: Int{
        case image50
        case image200
    }
    
    enum FriendIgnored: String{
        case xFirstName
        case xLastName
        case groupBy
        case xImageURL50
        case xImageURL200
    }
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var imageURL50: String?
    @objc dynamic var imageURL200: String?
    
    var image50: UIImage?
    var image200: UIImage?
    var photos:[String] = []
    
    // service fields >>>
    // group by:
    var xFirstName: String = ""
    var xLastName: String = ""
    var groupBy: FriendGroupByType = .firstName
    // async task:
    var xImageURL50: String?
    var xImageURL200: String?
    // service fields <<<
    
    
    convenience init(json: JSON?){
        self.init()
        setup(json: json)
    }

    override func setup(json: JSON?){
        if let json = json {
            id = json["id"].intValue
            firstName = json["first_name"].stringValue
            lastName = json["last_name"].stringValue
            imageURL50 = json["photo_50"].stringValue
            imageURL200 = json["photo_200_orig"].stringValue
            
            xFirstName = firstName
            xLastName = lastName
            xImageURL50 = imageURL50
            xImageURL200 = imageURL200
        }
    }
    
    override func getGroupByField()->String {
        switch groupBy {
        case .firstName:
            return firstName
        case .lastName:
            return lastName
        }
    }
    
    override func getXGroupByField()->String {
        switch groupBy {
        case .firstName:
            return xFirstName
        case .lastName:
            return xLastName
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
    
    override func updateXImages(){
        xImageURL50 = imageURL50
        xImageURL200 = imageURL200
    }
    
    override func isImageURLChanged()->Bool {
        return imageURL50 != xImageURL50 ||
                imageURL200 != xImageURL200
    }
    
    
    override func isURLlessChanded()->Bool {
        return firstName != xFirstName ||
                lastName != xLastName
    }
    
    
    override static func ignoredProperties() -> [String] {
        return [FriendIgnored.xFirstName.rawValue,
                FriendIgnored.xLastName.rawValue,
                FriendIgnored.groupBy.rawValue,
                FriendIgnored.xImageURL50.rawValue,
                FriendIgnored.xImageURL200.rawValue
                ]
    }
    
    
}


