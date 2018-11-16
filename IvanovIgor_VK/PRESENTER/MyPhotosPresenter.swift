import Foundation
import Alamofire


public class MyPhotosPresenter: BasePresenter {
    let urlPath: String = "photos.getAll"
    
    override func loadModel(completion: (()->Void)?=nil ){
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "0",
            "count":50,
            "fields":["description","members_count","is_member","photo_50","photo_200"],
            "v": "5.80"
        ]
        
       AlamofireNetworkManager.doGet(clazz: MyPhotos.self, presenter: self, urlPath: urlPath, params: params, completion: completion)
    }
    
    // ДЗ 4 >>>
    // сохранять то, что было получено из сети
    func savePersistence(photos: [MyPhotos]?){
        guard let photos = photos
            else {
                return
        }
        for p in photos {
            MyPhotosPersistence(id: p.id ?? 1000000 , photoURL: p.photoURL ?? "")
        }
    }
    
    // подгружать в случае,если нет сети
    func loadPersistence()->[MyPhotos]?{
        var res: [MyPhotos]? = []
        guard let recs = MyPhotosPersistence.loadPersistence()
            else {
                return nil
        }
        
        for r in recs {
            let photo = MyPhotos(id: r.id, photoURL: r.photoURL)
            res?.append(photo)
        }
        return res
    }
    // ДЗ 4 <<<
    
    override func refreshData()->( [ModelProtocol], [String] ){
        let groupingProps: [String] = []
        let ds2 = ds!
        return (ds2, groupingProps)
    }
    
}
