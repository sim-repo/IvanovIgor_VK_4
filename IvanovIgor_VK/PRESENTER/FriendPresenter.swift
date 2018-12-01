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
            realmNotify(realmData: &realmData)
        }
    }
    

    override func loadFromDisk(completion: (()->Void)? = nil){
        guard let data = realmLoadData(clazz: MyFriend.self)
            else { return }
        realmData = data
        let ds = data.toArray(ofType: MyFriend.self)
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        realmNotify(realmData: &realmData)
        completion?()
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        guard let friends = ds as? [MyFriend]
            else {return ds}
        return friends.sorted(by: { $0.getGroupByField() < $1.getGroupByField() })
    }
    
    
    override func refreshData()->( [ModelProtocol], [String] ){
        var tempFriends: [MyFriend]
        guard let friends =  getModel() as? [MyFriend] else {
            return ([], [])
        }
        
        if let filteredText  = filteredText {
            tempFriends = friends.filter({$0.getGroupByField().lowercased().contains(filteredText.lowercased())})
        } else {
            tempFriends = friends
        }
        
        var groupingProps: [String] = []
        for friend in tempFriends {
            groupingProps.append( friend.getGroupByField() )
        }
        return (tempFriends, groupingProps)
    }
    

    func prepareCompletion()-> (Data, Int, Int)->Void  {
        let completion: (Data, Int, Int)->Void = { [weak self] (data, id, imageFieldIndex) in
            
            guard let friend = self?.sortedDataSource.first(where: { $0.getId() == id }) as? MyFriend
                else {
                    fatalError("only for test")
                }
            
            switch imageFieldIndex {
            case MyFriend.FriendImagesType.image50.rawValue:
                friend.image50 = UIImage(data: data)
            case MyFriend.FriendImagesType.image200.rawValue:
                friend.image200 = UIImage(data: data)
            default:
                fatalError("prepareCompletion") // only for test
            }
            guard let indexPath = self?.getIndexPath(model: friend)
                else {
                    //fatalError("only for test")
                    return
                }
            self?.view?.optimReloadCell(indexPath: indexPath)
        }
        return completion
    }
    
    
    
    
    override func modelLoadImages(arr: [ModelProtocol]?){
        print("async loading images...")
        guard let friends = arr as? [MyFriend]
            else {
                fatalError("only for test")
                return
            }
        
        
        for friend in friends {
            friend.updateXGroupByField(val: friend.getGroupByField())
            let completion = prepareCompletion()
            
            if let val = friend.imageURL50 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, id: friend.getId(),
                                                      imageFieldIndex: MyFriend.FriendImagesType.image50.rawValue,
                                                      completion)
            }
            if let val = friend.imageURL200 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, id: friend.getId(),
                                                      imageFieldIndex: MyFriend.FriendImagesType.image200.rawValue,
                                                      completion)
            }
        }
    }
    
    
    override func getGroupByDataSource() -> [String] {
        return [MyFriend.FriendGroupByType.firstName.rawValue, MyFriend.FriendGroupByType.lastName.rawValue]
    }
    
    
    override func changeGroupBy(by fieldName: String) {
        for element in self.sortedDataSource {
            if let obj = element as? MyFriend {
                obj.groupBy = MyFriend.FriendGroupByType(rawValue: fieldName)! //TODO
            }
        }
        self.redrawUI()
    }
    
    
    override func className() -> String {
        return String(describing: FriendPresenter.self)
    }
}
