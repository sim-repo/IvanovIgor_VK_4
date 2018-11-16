import Foundation
import Alamofire
import SwiftyJSON

class AlamofireNetworkManager{
    static let baseURL = "https://api.vk.com/method/"
    
    public static let sharedManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        config.timeoutIntervalForResource = 40
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    
    public static func doGet<T: ModelProtocol>(clazz: T.Type , presenter: PresenterProtocol?, urlPath: String?, params: Parameters, completion: (()->Void)? = nil ){
        guard let presenter = presenter
            else {return}
        guard let urlPath = urlPath
            else {return}
        AlamofireNetworkManager.sharedManager.request(baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let val):
                let arr:[T]? = parseJSON(val)
                if let arr = arr {
                    presenter.setModel(ds: arr)
                }
                completion?()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    
    public static func doGet(url: URL?, completion: ((_: Data) -> Void)?){
        guard let url = url
            else {
                return
        }
        
        Alamofire.request(url).response{ (response) in
            guard response.error == nil
                else {
                    //print(response.error?.localizedDescription)
                    fatalError(response.error!.localizedDescription) // only for test
                    return
            }
    
            if let data = response.data {
                completion?(data)
            }
        }
    }
    
    private static func parseJSON<T: ModelProtocol>(_ val: Any)->[T]?{
        let json = JSON(val)
        let res = json["response"]["items"].arrayValue.map{ T(json: $0) }
        return res
    }
    
    
}
