import UIKit
import SwiftyJSON


let tagsTxt: [String] = ["dolor","tempor"]
let gDesc = "As written by Paul in the comments, property observers didSet and willSet are not called during value initialization." +
           "If you want to call them for a value also on initialization, you could add a function call to re-set the radius property after it has been initially set in the initializer"

class News : BaseModel{
    
    func sortingField() -> Any? {
        return nil
    }
    var ownerId: Int?
    var desc: String?
    var images: [UIImage]?
    var tags: [String]?
    
    convenience init(json: JSON?) {
        self.init()
        self.ownerId = 3
        self.desc = "Fd"
        self.images = []
        self.tags = []
    }
    
    
    convenience init(id: Int, ownerId: Int, description: String, images: [UIImage], tags: [String]) {
        self.init()
        self.id = id
        self.ownerId = ownerId
        self.desc = description
        self.images = images
        self.tags = []
    }

    
    public static func allList()->[News] {
        return [
            News(id: 6, ownerId: 5, description: gDesc, images: [UIImage(named: "ural")!, UIImage(named: "baikal")!, UIImage(named: "syberia")!, UIImage(named: "ural")!,
                                                                UIImage(named: "baikal")!], tags: tagsTxt),
            
            News(id: 1, ownerId: 1, description: gDesc, images: [UIImage(named: "syberia")!, UIImage(named: "baikal")!, UIImage(named: "ural")!], tags: tagsTxt),
            
            News(id: 1, ownerId: 1, description: gDesc, images: [UIImage(named: "ural")!, UIImage(named: "baikal")!], tags: tagsTxt),
            
            News(id: 2, ownerId: 1, description: gDesc, images: [UIImage(named: "ural")!, UIImage(named: "syberia")!, UIImage(named: "ural")!, UIImage(named: "syberia")!], tags: tagsTxt),
            
            News(id: 3, ownerId: 2, description: gDesc, images: [UIImage(named: "ural")!], tags: tagsTxt),
            
            News(id: 4, ownerId: 3, description: gDesc, images: [UIImage(named: "baikal")!], tags: tagsTxt),
            
            News(id: 5, ownerId: 4, description: gDesc, images: [UIImage(named: "baikal")!], tags: tagsTxt),
            
            News(id: 6, ownerId: 5, description: gDesc, images: [UIImage(named: "ural")!, UIImage(named: "baikal")!, UIImage(named: "syberia")!, UIImage(named: "ural")!,
                                                                UIImage(named: "baikal")!, UIImage(named: "syberia")!], tags: tagsTxt),
        ]
    }
    
}
