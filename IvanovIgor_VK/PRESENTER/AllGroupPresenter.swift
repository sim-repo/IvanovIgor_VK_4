import Foundation
import Alamofire



public class AllGroupPresenter: BasePresenter {
    
    
    let urlPath: String = "groups.search"
    
    
    override func loadModel(completion: (()->Void)?){
        let groups = gGroups.filter({$0.isMember == false})
        var groupingProps: [String] = []
        for group in groups {
            groupingProps.append(group.name)
        }
        setup(_sortedDataSource: groups, _groupingProperties: groupingProps)
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
    
    override func setModel(ds: [ModelProtocol]) {
        let groups = ds as? [Group]
        if let gr = groups {
            self.ds = gr.sorted(by: { $0.name < $1.name })
        }
    }
    
    override func refreshData()->( [ModelProtocol], [String] ){
        
        guard var tempGroups = ds as? [Group] else {
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
        ds?.removeAll()
        guard searchText != "" else
        {
            completion?()
            return
        }
        sendRequest(txtSearch: searchText, completion: completion)
    }
}
