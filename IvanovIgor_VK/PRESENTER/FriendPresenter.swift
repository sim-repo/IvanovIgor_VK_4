import Foundation
import Alamofire

public class FriendPresenter: BasePresenter {
    
    let urlPath: String = "friends.get"
    
    override func loadModel(completion: (()->Void)?){
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["bdate","sex","photo_50","photo_200_orig"],
            "v": "5.80"
        ]
        
        AlamofireNetworkManager.doGet(clazz: MyFriend.self, presenter: self, urlPath: urlPath, params: params, completion: completion)
    }
    
    override func setModel(ds: [ModelProtocol]) {
        var friends:[MyFriend]? = []
        friends = ds as? [MyFriend]
        
        savePersistence(friends: friends)
        
        if let fr = friends {
            self.ds = fr.sorted(by: { $0.firstName < $1.firstName })
        }
    }
    
    // ДЗ 4 >>>
    // сохранять то, что было получено из сети
    func savePersistence(friends: [MyFriend]?){
        guard let friends = friends
            else {
                return
            }
        for f in friends {
            MyFriendPersistence(id: f.id ?? 10000000,
                                firstName:f.firstName,
                                lastName: f.lastName,
                                profilePicURL50: f.profilePictureURL50 ?? "",
                                profilePicURL200: f.profilePictureURL200 ?? "")
        }
    }
    
    // подгружать в случае,если нет сети
    func loadPersistence()->[MyFriend]?{
        var res: [MyFriend]? = []
        guard let recs = MyFriendPersistence.loadPersistence()
            else {
                return nil
           }
        
        for r in recs {
            let friend = MyFriend(id: r.id,
                                  firstName: r.firstName,
                                  lastName: r.lastName,
                                  profilePictureURL50: r.profilePictureURL50,
                                  profilePictureURL200: r.profilePictureURL200)
            res?.append(friend)
        }
        
        return res
    }
    // ДЗ 4 <<<
    
    
    override func refreshData()->( [ModelProtocol], [String] ){
        var tempFriends: [MyFriend]
        guard let friends = ds as? [MyFriend] ?? loadPersistence()  else {
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
