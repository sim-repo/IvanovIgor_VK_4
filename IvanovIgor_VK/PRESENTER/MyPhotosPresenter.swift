import Foundation
import Alamofire
import RealmSwift

public class MyPhotosPresenter: BasePresenter {
    let urlPath: String = "photos.getAll"
    var realmData: Results<MyPhotos>?
    

    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "0",
            "count":50,
            "fields":["description","members_count","is_member","photo_50","photo_200"],
            "v": "5.80"
        ]
        
        let outerCompletion: (([ModelProtocol]) -> Void)? = {[weak self] (arr: [ModelProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
            completion?()
        }
        AlamofireNetworkManager.request(clazz: MyPhotos.self, urlPath: urlPath, params: params, completion: outerCompletion)
    }
    
    
    override func saveModel(ds: [ModelProtocol]) {
        if let photos = ds as? [MyPhotos] {
            DatabaseService.realmSave(items: photos, config: DatabaseService.configuration, update: true)
            realmNotify()
        }
    }
    
    
    override func loadFromDisk(completion: (()->Void)? = nil){        
        guard let data = realmLoadData()
            else { return }
        let ds = data.toArray(ofType: MyPhotos.self)
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        realmNotify()
        completion?()
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        return ds
    }

    
    override func refreshData()->( [ModelProtocol], [String] ){
        let groupingProps: [String] = []
        return (getModel(), groupingProps)
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
        self.realmToken = realmData?.observe {  (changes: RealmCollectionChange) in
            switch changes {
            case let .update(results, deletions, insertions, modifications):
                print(results, deletions, insertions, modifications)
            case .error(let error):
                print(error)
            default: break
            }
            print("данные изменились")
        }
    }
    
    
    func realmLoadData()->Results<MyPhotos>?{
        return DatabaseService.realmLoad(clazz: MyPhotos.self)
    }
    
}
