import UIKit
import SwiftyJSON

class MyFriend : BaseModel{
    var firstName: String!
    var lastName: String!
    var profilePictureImage50: UIImage?
    var profilePictureURL50: String? {
        didSet{
            guard profilePictureURL50 != oldValue
                else {
                    return
            }
            if let val = profilePictureURL50{
                let url = URL(string: val)
                self.notify(url: url, .needDownload){ (data) in
                    self.profilePictureImage50 = UIImage(data: data)
                    self.notify(model: self, .didModelChanged)
                }
            }
        }
    }
    var profilePictureImage200: UIImage?
    var profilePictureURL200: String? {
        didSet{
            guard profilePictureURL200 != oldValue
                else {
                    return
            }
            if let val = profilePictureURL200{
                let url = URL(string: val)
                self.notify(url: url,.needDownload) { (data) in
                    self.profilePictureImage200 = UIImage(data: data)
                    self.notify(model: self, .didModelChanged)
                }
            }
        }
    }
    
    var photos:[String] = []
    
    required init(json: JSON?){
        super.init(json: json)
        if let json = json {
            self.id = json["id"].intValue
            self.firstName = json["first_name"].stringValue
            self.lastName = json["last_name"].stringValue
            
            setProfilePictureURL50(val: json["photo_50"].stringValue)
            setProfilePictureURL200(val: json["photo_200_orig"].stringValue)
        }
    }
    
    convenience init(id: Int, firstName: String, lastName: String, profilePictureURL50: String, profilePictureURL200: String) {
        self.init(json: nil)
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        
        setProfilePictureURL50(val: profilePictureURL50)
        setProfilePictureURL200(val: profilePictureURL200)
    }
    
    func setProfilePictureURL50(val: String?) {
        self.profilePictureURL50 = val
    }
    
    func setProfilePictureURL200(val: String?) {
        self.profilePictureURL200 = val
    }
    
}
