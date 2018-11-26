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
            realmNotify()
        }
    }
    
    
    override func loadFromDisk(completion: (()->Void)? = nil){        
        guard let data = realmLoadData()
            else { return }
        let ds = data.toArray(ofType: Group.self)
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        realmNotify()
        completion?()
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        guard let groups = ds as? [Group]
            else {return ds}
        return groups.sorted(by: {$0.name < $1.name })
    }

    
    override func refreshData()->( [ModelProtocol], [String] ){
        
        guard var tempGroups = getModel() as? [Group] else {
            return ([], [])
        }
        
        if let filteredText  = filteredText {
            tempGroups = tempGroups.filter({
                $0.name.lowercased().contains(filteredText.lowercased())
            })
        }
        
        var groupingProps: [String] = []
        for group in tempGroups {
            groupingProps.append(group.name )
        }
        return (tempGroups, groupingProps)
    }
    
    
    override func update(object: AnyObject)->Void {
        let group = object as! Group
        group.isMember = true
    }
    
    
    override func remove(object: AnyObject) {
        let group = object as! Group
        group.isMember = false
    }
    
    
    func realmNotify(){
        guard self.realmToken == nil
            else { return }
        
        if realmData == nil {
            realmData = realmLoadData()
        }
        if realmData == nil {
            fatalError("realmNotify: realmData is nil")
        }
        self.realmToken = realmData?.observe {  (changes: RealmCollectionChange) in
            switch changes {
            case let .update(results, deletions, insertions, modifications):
                print(results, deletions, insertions, modifications)
            case .error(let error):
                print(error)
            default: break
            }
            print("данные изменились")
        }
    }
    
    
    func realmLoadData()->Results<Group>?{
        return DatabaseService.realmLoad(clazz: Group.self, sortField: Group.Sorting.name.rawValue)
    }
    
}
