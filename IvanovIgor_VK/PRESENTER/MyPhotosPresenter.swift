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
            DatabaseService.realmSave(items: photos, config: DatabaseService.configuration, update: true, dml: .insert)
            realmNotify(realmData: &realmData)
        }
    }
    
    
    override func loadFromDisk(completion: (()->Void)? = nil){        
        guard let data = realmLoadData(clazz: MyPhotos.self)
            else { return }
        let ds = data.toArray(ofType: MyPhotos.self)
        setModel(ds: ds, didLoadedFrom: .diskFirst)
        realmNotify(realmData: &realmData)
        completion?()
    }
    
    
    override func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol] {
        return ds
    }

    
    override func refreshData()->( [ModelProtocol], [String] ){
        let groupingProps: [String] = []
        return (getModel(), groupingProps)
    }
    
    
    func prepareCompletion()-> (Data, Int, Int)->Void  {
        let completion: (Data, Int, Int)->Void = { [weak self] (data, id, imageFieldIndex) in

            guard let photo = self?.sortedDataSource.first(where: { $0.getId() == id }) as? MyPhotos
                else {
                    fatalError("only for test")
                }
            
            
            switch imageFieldIndex {
            case MyPhotos.PhotosImagesType.image.rawValue:
                photo.image = UIImage(data: data)
            default:
                fatalError("only for test")
            }
            guard let indexPath = self?.getIndexPath(model: photo)
                else {
                    fatalError("only for test")
                }
            self?.view?.optimReloadCell(indexPath: indexPath)
        }
        return completion
    }
    
    
    
    override func modelLoadImages(arr: [ModelProtocol]?){
        print("async loading images...")
        guard let photos = arr as? [MyPhotos]
            else {
                fatalError("only for test")
            }
        
        
        for photo in photos {
            photo.updateXSortingField(val: photo.getGroupByField())
            let completion = prepareCompletion()
            
            if let val = photo.imageURL {
                let url = URL(string: val)!
                AlamofireNetworkManager.downloadImage(url: url, id: photo.getId(),
                                                      imageFieldIndex: MyPhotos.PhotosImagesType.image.rawValue,
                                                      completion)
            }
        }
    }
    
    
    override func getGroupByDataSource() -> [String] {
        return [MyPhotos.PhotosGroupByType.id.rawValue]
    }
    
    
    override func changeGroupBy(by fieldName: String) {
        for element in self.sortedDataSource {
            if let obj = element as? MyPhotos {
                obj.groupBy = MyPhotos.PhotosGroupByType(rawValue: fieldName)! //TODO
            }
        }
        self.redrawUI()
    }
    
}
