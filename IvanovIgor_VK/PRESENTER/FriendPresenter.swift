import Foundation
import Alamofire

public class FriendPresenter: BasePresenter {
    
    let urlPath: String = "friends.get"
    
    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
        "access_token": Session.shared.token,
        "extended": "1",
        "fields":["bdate","sex","photo_50","photo_200_orig"],
        "v": "5.80"
        ]
        AlamofireNetworkManager.doGet(clazz: MyFriend.self, presenter: self, urlPath: urlPath, params: params, completion: completion)
    }
    
    
    override func loadFromDisk(completion: (()->Void)? = nil){
        guard let ds = DatabaseService.realmLoad(clazz: MyFriend.self, sortField: MyFriend.Sorting.firstName.rawValue)?.toArray(ofType: MyFriend.self)
            else { return }
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        completion?()
    }
    
    
    override func saveModel(ds: [ModelProtocol]) {
        if let friends = ds as? [MyFriend] {
            DatabaseService.realmSave(items: friends, config: DatabaseService.configuration, update: true)
        }
    }
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        guard let friends = ds as? [MyFriend]
            else {return ds}
        return friends.sorted(by: {$0.firstName < $1.firstName })
    }
    
    
    override func refreshData()->( [ModelProtocol], [String] ){
        var tempFriends: [MyFriend]
        guard let friends =  getModel() as? [MyFriend] else {
            return ([], [])
        }
        
        if let filteredText  = filteredText {
            tempFriends = friends.filter({$0.firstName.lowercased().contains(filteredText.lowercased())})
        } else {
            tempFriends = friends
        }
        
        var groupingProps: [String] = []
        for friend in tempFriends {
            groupingProps.append(friend.firstName )
        }
        return (tempFriends, groupingProps)
    }
    
}
