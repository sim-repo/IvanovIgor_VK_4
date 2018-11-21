import UIKit
 // Задание 5: рефакторинг >>>
class Configurator {
    static let shared = Configurator()
    private init(){}
    
    private lazy var view2presenter: [String:BasePresenter] = [:]
    
    
    func getPresenter(viewController: ViewProtocolDelegate, loadType: LoadModelType, completion: (()->Void)? = nil)->BasePresenter?{
        let clazz = viewController.className()
        var res: BasePresenter? = view2presenter[clazz]
        
        if res == nil {
            res = createPresenter(viewController, loadType, completion)
        } else {
            res?.postPreloading(view: viewController, completion: completion)
        }
        return res
    }
    
    
    private func createPresenter(_ viewController: ViewProtocolDelegate, _ loadType: LoadModelType, _ completion: (()->Void)? = nil) -> BasePresenter? {
        var presenter: BasePresenter?
        
        switch viewController {
            case is FriendsController :
                presenter = FriendPresenter()
            case is MyGroupsController :
                presenter = GroupPresenter()
            case is AllGroupsTableController:
                presenter = AllGroupPresenter()
            case is MyPhotosCollectionController :
                presenter = MyPhotosPresenter()
            case is NewsCollectionController:
                presenter = NewsPresenter()
            default:
                fatalError("Configurator: getPresenter - no presenter has found")
            }
        guard let res = presenter
            else { return nil }
        
        view2presenter[String(describing: viewController.self)] = res
        res.setup(view: viewController, completion: completion, loadType)
        return res
    }
    
    
    public func preloadPresenter(for futureViewController: String, loadType: LoadModelType,_ completion: (()->Void)? = nil) -> BasePresenter? {
        var presenter: BasePresenter?
    
        switch futureViewController {
        case String(describing: FriendsController.self):
            presenter = FriendPresenter(completion: completion, loadType)
        case String(describing: MyGroupsController.self):
            presenter = GroupPresenter(completion: completion, loadType)
        case String(describing: AllGroupsTableController.self):
            presenter = AllGroupPresenter(completion: completion, loadType)
        case String(describing: MyPhotoController.self):
            presenter = MyPhotosPresenter(completion: completion, loadType)
        default:
            fatalError("Configurator: getPresenter - no presenter has found")
        }
        guard let res = presenter
            else { return nil }
        
        view2presenter[String(describing: futureViewController)] = res
        return res
    }
}
