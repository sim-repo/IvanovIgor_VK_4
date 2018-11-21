import Foundation
import Alamofire

var gGroups: [Group] = []

public class GroupPresenter: BasePresenter {
    
    let urlPath: String = "groups.get"
    
    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["description","members_count","photo_50","photo_200"],
            "v": "5.80"
        ]
        AlamofireNetworkManager.doGet(clazz: Group.self, presenter: self, urlPath: urlPath, params: params, completion: completion)
    }
    
    
    override func loadFromDisk(completion: (()->Void)? = nil){
        guard let ds = DatabaseService.realmLoad(clazz: Group.self, sortField: Group.Sorting.name.rawValue)?.toArray(ofType: Group.self)
            else { return }
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        completion?()
    }
    
    
    override func saveModel(ds: [ModelProtocol]) {
        if let groups = ds as? [Group] {
            DatabaseService.realmSave(items: groups, config: DatabaseService.configuration, update: true)
        }
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
    
}
