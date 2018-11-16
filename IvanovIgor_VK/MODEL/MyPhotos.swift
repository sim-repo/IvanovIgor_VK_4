import UIKit
import SwiftyJSON


class MyPhotos : BaseModel{
    
    var photoURL:String? {
        didSet{
            guard photoURL != oldValue
                else {
                    return
            }
            if let val = photoURL{
                let url = URL(string: val)
                self.notify(url: url,.needDownload) { (data) in
                    self.photo = UIImage(data: data)
                    self.notify(model: self, .didModelChanged)
                }
            }
        }
    }
    var photo: UIImage?
    
    required init(json: JSON?) {
        super.init(json: json)
        if let json = json {
            self.id = json["id"].intValue
            let arr = json["sizes"].arrayValue.map{ $0 }
            
            for element in arr {
                let type = element["type"].stringValue
                if type == "m" {
                    let photoURL = element["url"].stringValue
                    setPhotoURL(photoURL)
                }
            }
        }
    }
    
    convenience init(id: Int, photoURL: String) {
        self.init(json: nil)
        self.id = id
        setPhotoURL(photoURL)
    }
    
    func setPhotoURL(_ url: String){
        self.photoURL = url
    }
    
}
