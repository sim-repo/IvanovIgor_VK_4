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
    
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    var image50: UIImage?
    var image200: UIImage?
    
    @objc dynamic var imageURL50:  String?
    @objc dynamic var imageURL200: String?
    @objc dynamic var isMember: Bool = false

    // service fields
    var xName: String = ""
    var groupBy: MyGroupByType = .name
    
    convenience init(json: JSON?) {
        self.init()
        setup(json: json)
    }
    
    override func setup(json: JSON?){
        if let json = json {
            self.id = json["id"].intValue
            self.name = json["name"].stringValue
            self.desc = json["description"].stringValue
            self.imageURL50 = json["photo_50"].stringValue
            self.imageURL200 = json["photo_200"].stringValue
        }
    }
    
    override func getSortingField()->String {
        switch groupBy {
        case .name:
            return self.name
        }
    }
    
    func getXSortingField()->String {
        switch groupBy {
        case .name:
            return self.name
        }
    }
    
    func updateXSortingField(val: String) {
        switch groupBy {
        case .name:
            xName = val
        }
    }

    
}


