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
    
    override func loadFromDisk(completion: (()->Void)? = nil){
        guard let ds = DatabaseService.realmLoad(clazz: MyPhotos.self, sortField: MyPhotos.Sorting.id.rawValue)?.toArray(ofType: MyPhotos.self)
            else { return }
        if ds.count != 0 {
            setModel(ds: ds, didLoadedFrom: .diskFirst)
            ds.forEach({$0.postInit()}) //TODO: избавиться
        }
        completion?()
    }
    
    
    override func saveModel(ds: [ModelProtocol]) {
        if let photos = ds as? [MyPhotos] {
            DatabaseService.realmSave(items: photos, config: DatabaseService.configuration, update: true)
        }
    }
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        return ds
    }

    
    override func refreshData()->( [ModelProtocol], [String] ){
        let groupingProps: [String] = []
        return (getModel(), groupingProps)
    }
    
}
