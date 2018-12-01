import UIKit
import RealmSwift


enum TextThreshold: Int {
    case short = 180
    case middle = 500
    case big = 1000
}


enum ContentVolume{
    case def
    
    case label
    case text
    case bigText
    case photo1
    case photo1MidText
    case photo1BigText
    
    case photos2
    case photos2MidText
    case photos2BigText
    
    case photos3
    case photos3MidText
    case photos3BigText
    
    case photos4
    case photos4MidText
    case photos4BigText
    
    case photos5
    case photos5MidText
    
    case photos6
    case photos6MidText

    case photos7
    case photos7MidText
    
    case photos8
    case photos8MidText
}

enum LoadModelType{
    case networkFirst
    case diskFirst
}

public enum StatePresenterType{
    case initial
    case noChanged
    case modelDidUpdated
}

protocol PresenterProtocol: class {
    
    var numberOfSections: Int {get}
    
    var view: ViewProtocolDelegate? {get set}
    
    func numberOfRowsInSection (section: Int)->Int
    
    func getData (indexPath: IndexPath)->ModelProtocol?
    
    func sectionName(section: Int)->String
    
    func refreshDataSource(with completion: (([String])->Void)?  )
    
    func update(object: AnyObject)->Void
    
    func remove(object: AnyObject)->Void
    
    func filterData(_ filterText: String)
    
    func getContentVolume(indexPath: IndexPath)->ContentVolume

    func searchData(searchText: String, completion: (()->Void)?)
    
    func saveModel(ds: [ModelProtocol])
    
    func viewDeinit()
    
    func getGroupByProperties()->[String]
    
    func changeGroupBy(by fieldName: String)
    
    func getGroupByDataSource()->[String]
    
    
    
    func setDML(indexPath: IndexPath, dml: DML)
    
    func handleEmit(with object: ModelProtocol, dml: DML)
    
    
    
    func viewWillAppear()
    
}
