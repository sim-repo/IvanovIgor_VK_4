import Foundation
import SwiftyJSON

class SearchedGroup: BaseModel {
    var name: String!
    var desc: String!
    var imageURL50: String!
    var imageURL200: String!
    var image50: UIImage?
    var image200: UIImage?
    
    enum SearchedGroupImagesType: Int{
        case image50
        case image200
    }
    
    
    override func setup(json: JSON?){
        if let json = json {
            id = json["id"].intValue
            name = json["name"].stringValue
            desc = json["description"].stringValue
            imageURL50 = json["photo_50"].stringValue
            imageURL200 = json["photo_200"].stringValue
        }
    }
}
