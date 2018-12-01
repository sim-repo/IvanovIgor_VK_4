import SwiftyJSON
import UIKit


class Group : BaseModel{
    
    enum MyGroupByType: String {
        case name = "По Названию"
    }
    
    enum GroupImagesType: Int{
        case image50
        case image200
    }
    
    enum GroupIgnored: String{
        case xName
        case groupBy
        case xImageURL50
        case xImageURL200
    }
    
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    var image50: UIImage?
    var image200: UIImage?
   
    
    
    @objc dynamic var imageURL50:  String = ""
    @objc dynamic var imageURL200: String = ""
    @objc dynamic var isMember: Bool = false

    // service fields >>>
    // service fields
    var xName: String = ""
    var groupBy: MyGroupByType = .name
    // async task:
    var xImageURL50: String?
    var xImageURL200: String?
    // service fields <<<
    
    
    convenience init(id: Int, name: String, desc: String, imageURL50: String, imageURL200: String) {
        self.init()
        self.id = id
        self.name = name
        self.desc = desc
        self.imageURL50 = imageURL50
        self.imageURL200 = imageURL200
        
        xName = name
        xImageURL50 = imageURL50
        xImageURL200 = imageURL200
    }
    
    convenience init(json: JSON?) {
        self.init()
        setup(json: json)
    }
    
    override func setup(json: JSON?){
        if let json = json {
            id = json["id"].intValue
            name = json["name"].stringValue
            desc = json["description"].stringValue
            imageURL50 = json["photo_50"].stringValue
            imageURL200 = json["photo_200"].stringValue
            
            xName = name
            xImageURL50 = imageURL50
            xImageURL200 = imageURL200
        }
    }
    
    override func getGroupByField()->String {
        switch groupBy {
        case .name:
            return name
        }
    }
    
    override func getXGroupByField()->String {
        switch groupBy {
        case .name:
            return name
        }
    }
    
    override func updateXGroupByField(val: String) {
        switch groupBy {
        case .name:
            xName = val
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
    
    
    override static func ignoredProperties() -> [String] {
        return [GroupIgnored.xName.rawValue,
                GroupIgnored.groupBy.rawValue,
                GroupIgnored.xImageURL50.rawValue,
                GroupIgnored.xImageURL200.rawValue
        ]
    }

    
}


