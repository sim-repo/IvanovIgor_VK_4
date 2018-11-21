import SwiftyJSON
import UIKit


class Group : BaseModel{
    
    enum Sorting: String {
        case name
    }
    
    enum Ignored: String{
        case image50
        case image200
    }
    
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    var image50: UIImage?
    var image200: UIImage?
    
    @objc dynamic var imageURL50:  String? {
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
    
    @objc dynamic var imageURL200: String? {
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
    
    @objc dynamic var isMember: Bool = false

    
    convenience init(json: JSON?) {
        self.init()
        setup(json: json)
    }
    
    
    convenience init(id: Int, name: String, description: String, imageURL50: String, imageURL200: String) {
        self.init()
        self.id = id
        self.name = name
        self.desc = description
        
        setImageURL50(val: imageURL50)
        setImageURL200(val: imageURL200)
    }
    
    func setImageURL50(val: String?) {
        self.imageURL50 = val
    }
    
    func setImageURL200(val: String?) {
        self.imageURL200 = val
    }
    
    override static func ignoredProperties() -> [String] {
        return [Ignored.image50.rawValue,
                Ignored.image200.rawValue]
    }
    
    override func setup(json: JSON?){
        if let json = json {
            self.id = json["id"].intValue
            self.name = json["name"].stringValue
            self.desc = json["description"].stringValue
            
            setImageURL50(val: json["photo_50"].stringValue)
            setImageURL200(val: json["photo_200"].stringValue)
        }
    }
    
    // TODO: избавиться от метода -->
    override func postInit() {
        
        if let val = imageURL50{
            let url = URL(string: val)
            self.notify(url: url, .needDownload){ (data) in
                self.image50 = UIImage(data: data)
                self.notify(model: self, .didModelChanged)
            }
        }
        
        if let val = imageURL200{
            let url = URL(string: val)
            self.notify(url: url,.needDownload) { (data) in
                self.image200 = UIImage(data: data)
                self.notify(model: self, .didModelChanged)
            }
        }
    }
    // TODO: избавиться от метода <--
    
}


