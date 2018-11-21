import Foundation
import Alamofire



public class AllGroupPresenter: BasePresenter {
    
    
    let urlPath: String = "groups.search"
    
    
    override func loadFromNetwork(completion: (()->Void)? = nil){
       
    }
    
    func sendRequest(txtSearch: String, completion: (() -> Void)?){
        let params: Parameters = [
            "access_token": Session.shared.token,
            "q": txtSearch,
            "count":10,
            "v": "5.80"
        ]
        AlamofireNetworkManager.doGet(clazz: Group.self, presenter: self, urlPath: urlPath, params: params, completion: completion)
    }
    
    
    override func saveModel(ds: [ModelProtocol]) {}
    
    
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
                $0.name.lowercased().contains(filteredText.lowercased()) &&
                    $0.isMember == false
            })
        } else {
            tempGroups = tempGroups.filter({$0.isMember == false})
        }
        
        var groupingProps: [String] = []
        for group in tempGroups {
            groupingProps.append(group.name )
        }
        return (tempGroups, groupingProps)
    }
    
    
    override func searchData(searchText: String, completion: (() -> Void)?) {
        removeModel()
        guard searchText != "" else
        {
            completion?()
            return
        }
        sendRequest(txtSearch: searchText, completion: completion)
    }
}
