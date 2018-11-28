import UIKit
import SwiftyJSON


class MyPhotos : BaseModel{

    enum PhotosGroupByType: String {
        case id = "По поступлению"
    }
    
    enum PhotosImagesType: Int{
        case image
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
    
    
    
    
//    convenience init(id: Int, imageURL: String) {
//        self.init()
//        self.id = id
//        setPhotoURL(imageURL)
//    }
    
//    func setPhotoURL(_ url: String){
//        self.imageURL = url
//    }
    
    
    override func setup(json: JSON?){
        if let json = json {
            self.id = json["id"].intValue
            let arr = json["sizes"].arrayValue.map{ $0 }
            
            for element in arr {
                let type = element["type"].stringValue
                if type == "m" {
                    self.imageURL = element["url"].stringValue
                }
            }
        }
    }
    
    override func getSortingField()->String {
        switch groupBy {
        case .id:
            return "\(self.getId())"
        }
    }
    
    func getXSortingField()->String {
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
    
}
