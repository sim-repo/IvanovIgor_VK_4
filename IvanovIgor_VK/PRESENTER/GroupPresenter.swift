import Foundation
import Alamofire
import RealmSwift

var gGroups: [Group] = []

public class GroupPresenter: BasePresenter {
    
    let urlPath: String = "groups.get"
    var realmData: Results<Group>?
    
    
    
    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["description","members_count","photo_50","photo_200"],
            "v": "5.80"
        ]
        let outerCompletion: (([ModelProtocol]) -> Void)? = {[weak self] (arr: [ModelProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
            completion?()
        }
        AlamofireNetworkManager.request(clazz: Group.self, urlPath: urlPath, params: params, completion: outerCompletion)
    }
    
    
    override func saveModel(ds: [ModelProtocol]) {
        if let groups = ds as? [Group] {
            DatabaseService.realmSave(items: groups, config: DatabaseService.configuration, update: true)
            realmNotify(realmData: &realmData)
        }
    }
    
    
    override func loadFromDisk(completion: (()->Void)? = nil){        
        guard let data = realmLoadData(clazz: Group.self)
            else { return }
        realmData = data
        let ds = data.toArray(ofType: Group.self)
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        realmNotify(realmData: &realmData)
        completion?()
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        guard let groups = ds as? [Group]
            else {return ds}
        return groups.sorted(by: { $0.getSortingField() < $1.getSortingField() })
    }

    
    override func refreshData()->( [ModelProtocol], [String] ){
        
        guard var tempGroups = getModel() as? [Group] else {
            return ([], [])
        }
        
        if let filteredText  = filteredText {
            tempGroups = tempGroups.filter({
                $0.getSortingField().lowercased().contains(filteredText.lowercased())
            })
        }
        
        var groupingProps: [String] = []
        for group in tempGroups {
            groupingProps.append( group.getSortingField() )
        }
        return (tempGroups, groupingProps)
    }
    
    
    func prepareCompletion()-> (Data, Int, Int)->Void  {
        let completion: (Data, Int, Int)->Void = { [weak self] (data, idx, imageFieldIndex) in
            let group = self?.sortedDataSource[idx] as! Group
            
            switch imageFieldIndex {
            case Group.GroupImagesType.image50.rawValue:
                group.image50 = UIImage(data: data)
            case Group.GroupImagesType.image200.rawValue:
                group.image200 = UIImage(data: data)
            default:
                fatalError("prepareCompletion") // only for test
            }
            guard let indexPath = self?.getIndexPath(model: group) else {return}
            self?.view?.optimReloadCell(indexPath: indexPath)
        }
        return completion
    }
    
    
    
    override func modelLoadImages(){
        print("async loading images...")
        guard let groups = self.sortedDataSource as? [Group]
            else { return }
        
        for (idx, group) in groups.enumerated() {
            group.updateXSortingField(val: group.getSortingField())
            let completion = prepareCompletion()
            
            if let val = group.imageURL50 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, idx: idx,
                                                      imageFieldIndex: Group.GroupImagesType.image50.rawValue,
                                                      completion)
            }
            if let val = group.imageURL200 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, idx: idx,
                                                      imageFieldIndex: Group.GroupImagesType.image200.rawValue,
                                                      completion)
            }
        }
    }
    
    
    override func getGroupByDataSource() -> [String] {
        return [Group.MyGroupByType.name.rawValue]
    }
    
    
    override func changeGroupBy(by fieldName: String) {
        for element in self.sortedDataSource {
            if let obj = element as? Group {
                obj.groupBy = Group.MyGroupByType(rawValue: fieldName)! //TODO
            }
        }
        self.redrawUI()
    }
    
    
    override func update(object: AnyObject)->Void {
        let group = object as! Group
        group.isMember = true
    }
    
    
    override func remove(object: AnyObject) {
        let group = object as! Group
        group.isMember = false
    }
 
}
