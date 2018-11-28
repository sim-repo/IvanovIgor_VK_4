import UIKit
import SwiftyJSON


class MyPhotos : BaseModel{

    enum PhotosGroupByType: String {
        case id = "По поступлению"
    }
    
    enum PhotosImagesType: Int{
        case image
    }
    
    enum PhotosIgnored: String{
        case xId
        case groupBy
    }
    
    @objc dynamic var imageURL:String?
    var image: UIImage?
    
    // service fields
    var xId: String = ""
    var groupBy: PhotosGroupByType = .id
    
    convenience init(json: JSON?) {
        self.init()
        setup(json: json)
    }
    
    override func setup(json: JSON?){
        if let json = json {
            id = json["id"].intValue
            let arr = json["sizes"].arrayValue.map{ $0 }
            
            for element in arr {
                let type = element["type"].stringValue
                if type == "m" {
                    imageURL = element["url"].stringValue
                }
            }
        }
    }
    
    override func getGroupByField()->String {
        switch groupBy {
        case .id:
            return "\(self.getId())"
        }
    }
    
    override func getXGroupByField()->String {
        switch groupBy {
        case .id:
            return "\(self.getId())"
        }
    }
    
    func updateXSortingField(val: String) {
        switch groupBy {
        case .id:
            xId = val
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return [PhotosIgnored.xId.rawValue,
                PhotosIgnored.groupBy.rawValue
        ]
    }
    
}
