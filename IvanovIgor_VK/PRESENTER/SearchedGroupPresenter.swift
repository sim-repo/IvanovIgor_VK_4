import Foundation
import Alamofire



public class SearchedGroupPresenter: BasePresenter {
    
    
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
        let outerCompletion: (([ModelProtocol]) -> Void)? = {[weak self] (arr: [ModelProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
            completion?()
        }
        AlamofireNetworkManager.request(clazz: SearchedGroup.self, urlPath: urlPath, params: params, completion: outerCompletion)
    }
    
    
    override func saveModel(ds: [ModelProtocol]){
        modelLoadImages(arr: ds)//TODO
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        guard let groups = ds as? [SearchedGroup]
            else {return ds}
        return groups.sorted(by: {$0.name < $1.name })
    }
    
    override func refreshData()->( [ModelProtocol], [String] ){
        
        guard let ds = getModel() as? [SearchedGroup] else {
            return ([], [])
        }
        return (ds, [])
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
    
    func prepareCompletion()-> (Data, Int, Int)->Void  {
        let completion: (Data, Int, Int)->Void = { [weak self] (data, id, imageFieldIndex) in
            guard let group = self?.sortedDataSource.first(where: { $0.getId() == id }) as? SearchedGroup
                else {
                    return
                   // fatalError("only for test")
            }
            
            switch imageFieldIndex {
            case SearchedGroup.SearchedGroupImagesType.image50.rawValue:
                group.image50 = UIImage(data: data)
            case SearchedGroup.SearchedGroupImagesType.image200.rawValue:
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
        guard let groups = arr as? [SearchedGroup]
            else {
                fatalError("only for test")
                return
        }
        
        for group in groups {
            let completion = prepareCompletion()
            
            if let val = group.imageURL50 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, id: group.getId(),
                                                      imageFieldIndex: SearchedGroup.SearchedGroupImagesType.image50.rawValue,
                                                      completion)
            }
            
            if let val = group.imageURL200 {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, id: group.getId(),
                                                      imageFieldIndex: SearchedGroup.SearchedGroupImagesType.image200.rawValue,
                                                      completion)
            }
        }
    }
    
    override func className() -> String {
        return String(describing: SearchedGroupPresenter.self)
    }
    
}
