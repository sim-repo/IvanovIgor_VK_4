import UIKit
 // Задание 5: рефакторинг >>>
class Configurator {
    static let shared = Configurator()
    private init(){}
    
    private lazy var view2presenter: [String:BasePresenter] = [:]
    
    
    func getPresenter(viewController: ViewProtocolDelegate, completion: (()->Void)?)->BasePresenter?{
        let clazz = viewController.className()
        var res: BasePresenter? = view2presenter[clazz]
        
        if res == nil {
            res = createPresenter(viewController, completion)
        } else {
            res?.postPreloading(view: viewController, completion: completion)
        }
        return res
    }
    
    
    private func createPresenter(_ viewController: ViewProtocolDelegate, _ completion: (()->Void)? = nil) -> BasePresenter? {
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
        res.setup(view: viewController, completion: completion)
        return res
    }
    
    
    public func preloadPresenter(for futureViewController: String, _ completion: (()->Void)? = nil) -> BasePresenter? {
        var presenter: BasePresenter?
    
        switch futureViewController {
        case String(describing: FriendsController.self):
            presenter = FriendPresenter(completion: completion)
        case String(describing: MyGroupsController.self):
            presenter = GroupPresenter(completion: completion)
        case String(describing: AllGroupsTableController.self):
            presenter = AllGroupPresenter(completion: completion)
        case String(describing: MyPhotoController.self):
            presenter = MyPhotosPresenter(completion: completion)
        default:
            fatalError("Configurator: getPresenter - no presenter has found")
        }
        guard let res = presenter
            else { return nil }
        
        view2presenter[String(describing: futureViewController)] = res
        return res
    }
}
