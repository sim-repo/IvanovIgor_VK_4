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
        return friends.sorted(by: { $0.getSortingField() < $1.getSortingField() })
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
            groupingProps.append( friend.getSortingField() )
        }
        return (tempFriends, groupingProps)
    }
    

    
    func prepareCompletion()-> (Data, Int, Int)->Void  {
        let completion: (Data, Int, Int)->Void = { [weak self] (data, idx, imageFieldIndex) in
            let friend = self?.sortedDataSource[idx] as! MyFriend
            
            switch imageFieldIndex {
            case MyFriend.FriendImagesType.profilePictureImage50.rawValue:
                friend.profilePictureImage50 = UIImage(data: data)
            case MyFriend.FriendImagesType.profilePictureImage200.rawValue:
                friend.profilePictureImage200 = UIImage(data: data)
            default:
                fatalError("prepareCompletion") // only for test
            }
            guard let indexPath = self?.getIndexPath(model: friend) else {return}
            self?.view?.optimReloadCell(indexPath: indexPath)
        }
        return completion
    }
    
    
    
    override func modelLoadImages(){
        print("async loading images...")
        guard let friends = self.sortedDataSource as? [MyFriend]
            else { return }
        
        for (idx, friend) in friends.enumerated() {
            friend.updateXSortingField(val: friend.getSortingField())
            let completion = prepareCompletion()
            
            if let val = friend.profilePictureURL50 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, idx: idx,
                                                      imageFieldIndex: MyFriend.FriendImagesType.profilePictureImage50.rawValue,
                                                      completion)
            }
            if let val = friend.profilePictureURL200 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, idx: idx,
                                                      imageFieldIndex: MyFriend.FriendImagesType.profilePictureImage200.rawValue,
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
}
