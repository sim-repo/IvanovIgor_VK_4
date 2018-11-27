import Foundation
import Alamofire
import RealmSwift

public class FriendPresenter: BasePresenter {
    
    let urlPath: String = "friends.get"
    var realmData: Results<MyFriend>?
    
    
    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
        "access_token": Session.shared.token,
        "extended": "1",
        "fields":["bdate","sex","photo_50","photo_200_orig"],
        "v": "5.80"
        ]
        let outerCompletion: (([ModelProtocol]) -> Void)? = {[weak self] (arr: [ModelProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
            completion?()
        }
        AlamofireNetworkManager.request(clazz: MyFriend.self, urlPath: urlPath, params: params, completion: outerCompletion)
    }
    
    
    override func saveModel(ds: [ModelProtocol]) {
        if let friends = ds as? [MyFriend] {
            DatabaseService.realmSave(items: friends, config: DatabaseService.configuration, update: true)
            realmNotify()
        }
    }
    

    override func loadFromDisk(completion: (()->Void)? = nil){
        guard let data = realmLoadData()
            else { return }
        realmData = data
        let ds = data.toArray(ofType: MyFriend.self)
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        realmNotify()
        completion?()
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        guard let friends = ds as? [MyFriend]
            else {return ds}
        return friends.sorted(by: {$0.getSortingField() < $1.getSortingField() })
    }
    
    
    override func refreshData()->( [ModelProtocol], [String] ){
        var tempFriends: [MyFriend]
        guard let friends =  getModel() as? [MyFriend] else {
            return ([], [])
        }
        
        if let filteredText  = filteredText {
            tempFriends = friends.filter({$0.getSortingField().lowercased().contains(filteredText.lowercased())})
        } else {
            tempFriends = friends
        }
        
        var groupingProps: [String] = []
        for friend in tempFriends {
            groupingProps.append(friend.getSortingField() )
        }
        return (tempFriends, groupingProps)
    }
    

    
    func prepareCompletion()-> (Data, Int, Int)->Void  {
        let completion: (Data, Int, Int)->Void = { [weak self] (data, idx, imageFieldIndex) in
            let friend = self?.sortedDataSource[idx] as! MyFriend
            
            switch imageFieldIndex {
            case MyFriend.ImagesType.profilePictureImage50.rawValue:
                friend.profilePictureImage50 = UIImage(data: data)
            case MyFriend.ImagesType.profilePictureImage200.rawValue:
                friend.profilePictureImage200 = UIImage(data: data)
            default:
                fatalError("prepareCompletion") // only for test
            }
            guard let indexPath = self?.getIndexPath(model: friend) else {return}
            self?.view?.optimReloadCell(indexPath: indexPath)
        }
        return completion
    }
    
    
    
    func modelLoadImages(){
        print("async loading images...")
        guard let friends = self.sortedDataSource as? [MyFriend]
            else { return }
        
        for (idx, friend) in friends.enumerated() {
            friend.updateXSortingField(val: friend.getSortingField())
            let completion = prepareCompletion()
            if let val = friend.profilePictureURL50 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, idx: idx, imageFieldIndex: MyFriend.ImagesType.profilePictureImage50.rawValue,completion: completion)
            }
            if let val = friend.profilePictureURL200 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, idx: idx, imageFieldIndex: MyFriend.ImagesType.profilePictureImage200.rawValue,completion: completion)
            }
        }
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
        self.realmToken = realmData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                self?.modelLoadImages()
              
            case let .update(results, deletions, insertions, modifications):
                var forceRealod = false
                if deletions.count == 0 && insertions.count == 0 && modifications.count > 0 {
                    for idx in modifications {
                        let obj = self?.sortedDataSource.first(where: {$0.getId() == results[idx].getId()}) as? MyFriend
                        if results[idx].getSortingField() != obj?.getXSortingField() {
                            obj?.updateXSortingField(val: results[idx].getSortingField())
                            forceRealod = true
                        }
                    }
                }
                self?.onDidModelChanged(results, deletions, insertions, modifications, forceFullReload: forceRealod)

            case .error(let error):
                print(error)
                
            default: break
            }
        }
    }
    
    func realmLoadData()->Results<MyFriend>?{
        return DatabaseService.realmLoad(clazz: MyFriend.self)
    }
}
