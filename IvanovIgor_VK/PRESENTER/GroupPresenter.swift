import Foundation
import Alamofire
import RealmSwift
import Firebase


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
        return groups.sorted(by: { $0.getGroupByField() < $1.getGroupByField() })
    }

    
    override func refreshData()->( [ModelProtocol], [String] ){
        
        guard var tempGroups = getModel() as? [Group] else {
            return ([], [])
        }
        
        if let filteredText  = filteredText {
            tempGroups = tempGroups.filter({
                $0.getGroupByField().lowercased().contains(filteredText.lowercased())
            })
        }
        
        var groupingProps: [String] = []
        for group in tempGroups {
            groupingProps.append( group.getGroupByField() )
        }
        return (tempGroups, groupingProps)
    }
    
    
    func prepareCompletion()-> (Data, Int, Int)->Void  {
        let completion: (Data, Int, Int)->Void = { [weak self] (data, id, imageFieldIndex) in
            guard let group = self?.sortedDataSource.first(where: { $0.getId() == id }) as? Group
            else {
                fatalError("only for test")
            }
            
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
    
    
    
    override func modelLoadImages(arr: [ModelProtocol]?){
        print("async loading images...")
        guard let groups = arr as? [Group]
            else {
                fatalError("only for test")
                return
        }
                
        for group in groups {
            group.updateXGroupByField(val: group.getGroupByField())
            let completion = prepareCompletion()

            var url = URL(string: group.imageURL50)
            AlamofireNetworkManager.downloadImage(url: url, id: group.getId(),
                                                  imageFieldIndex: Group.GroupImagesType.image50.rawValue,
                                                  completion)
            
            url = URL(string: group.imageURL200)
            AlamofireNetworkManager.downloadImage(url: url, id: group.getId(),
                                                  imageFieldIndex: Group.GroupImagesType.image200.rawValue,
                                                  completion)

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
    
    
    
    //TODO Refactor
    override func update(object: AnyObject)->Void {
        let group = object as! SearchedGroup
        
        Session.shared.user.groupsName.append(FIBGroup(groupName:group.name))
        let data = Session.shared.user.toAnyObject()
        
        let dbLink = Database.database().reference()
        dbLink.child("Humans").setValue(data)
        let myGroup = Group(id: group.id,
                            name: group.name,
                            desc: group.desc,
                            imageURL50: group.imageURL50,
                            imageURL200: group.imageURL200)
        self.sortedDataSource.append(myGroup)
        self.saveModel(ds: [myGroup])
        self.modelLoadImages(arr: [myGroup])
        self.redrawUI()
    }
    
    
    override func remove(object: AnyObject) {
        let group = object as! Group
        group.isMember = false
    }
    
    //TODO Refactor
    override func setAlien(with object: ModelProtocol) {
        update(object: object)
    }
 
}
