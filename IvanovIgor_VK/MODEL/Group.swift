import SwiftyJSON
import UIKit


class Group : BaseModel{
    var name: String!
    var description:String!
    var image50: UIImage?
    var imageURL50:  String? {
        didSet{
            guard imageURL50 != oldValue
                else {
                    return
            }
            if let val = imageURL50{
                let url = URL(string: val)
                self.notify(url: url, .needDownload){ (data) in
                    self.image50 = UIImage(data: data)
                    self.notify(model: self, .didModelChanged)
                }
            }
        }
    }
    
    
    var image200: UIImage?
    var imageURL200: String? {
        didSet{
            guard imageURL200 != oldValue
                else {
                    return
            }
            if let val = imageURL200{
                let url = URL(string: val)
                self.notify(url: url, .needDownload){ (data) in
                    self.image200 = UIImage(data: data)
                    self.notify(model: self, .didModelChanged)
                }
            }
        }
    }
    var isMember: Bool = false

    
    required init(json: JSON?) {
        super.init(json: json)
        if let json = json {
            self.id = json["id"].intValue
            self.name = json["name"].stringValue
            self.description = json["description"].stringValue
            
            setImageURL50(val: json["photo_50"].stringValue)
            setImageURL200(val: json["photo_200"].stringValue)
        }
    }
    
    
    convenience init(id: Int, name: String, description: String, imageURL50: String, imageURL200: String) {
        self.init(json: nil)
        self.id = id
        self.name = name
        self.description = description
        
        setImageURL50(val: imageURL50)
        setImageURL200(val: imageURL200)
    }
    
    func setImageURL50(val: String?) {
        self.imageURL50 = val
    }
    
    func setImageURL200(val: String?) {
        self.imageURL200 = val
    }
}


