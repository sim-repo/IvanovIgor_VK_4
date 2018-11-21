import Foundation
import Alamofire


public class MyPhotosPresenter: BasePresenter {
    let urlPath: String = "photos.getAll"
    

    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "0",
            "count":50,
            "fields":["description","members_count","is_member","photo_50","photo_200"],
            "v": "5.80"
        ]
        
        AlamofireNetworkManager.doGet(clazz: MyPhotos.self, presenter: self, urlPath: urlPath, params: params, completion: completion)
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        return ds
    }
    
    override func saveModel(ds: [ModelProtocol]) {}
    
    override func refreshData()->( [ModelProtocol], [String] ){
        let groupingProps: [String] = []
        return (getModel(), groupingProps)
    }
    
}
