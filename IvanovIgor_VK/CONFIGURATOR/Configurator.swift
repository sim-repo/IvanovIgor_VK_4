import UIKit


enum DML {
    case insert, update, delete
}


class Configurator {
    static let shared = Configurator()
    private init(){}
    
    private lazy var view2presenter: [String:BasePresenter] = [:]
    private lazy var presenters: [String:BasePresenter] = [:]
    
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
                presenter = SearchedGroupPresenter()
            case is MyPhotosCollectionController :
                presenter = MyPhotosPresenter()
            case is NewsCollectionController:
                presenter = NewsPresenter()
            default:
                fatalError("Configurator: getPresenter - no presenter has found")
            }
        guard let res = presenter
            else { return nil }
        
        let clazz = viewController.className()
        view2presenter[clazz] = res
        presenters[res.className()] = res
        res.setup(view: viewController, loadType, completion: completion)
        return res
    }
    
    
    public func preloadPresenter(for futureViewController: String, loadType: LoadModelType,_ completion: (()->Void)? = nil) -> BasePresenter? {
        var presenter: BasePresenter?
    
        switch futureViewController {
        case String(describing: FriendsController.self):
            presenter = FriendPresenter(loadType, completion: completion)
        case String(describing: MyGroupsController.self):
            presenter = GroupPresenter(loadType, completion: completion)
        case String(describing: AllGroupsTableController.self):
            presenter = SearchedGroupPresenter(loadType, completion: completion)
        case String(describing: MyPhotoController.self):
            presenter = MyPhotosPresenter(loadType, completion: completion)
        default:
            fatalError("Configurator: getPresenter - no presenter has found")
        }
        guard let res = presenter
            else { return nil }
        
        view2presenter[String(describing: futureViewController)] = res
        return res
    }
    
    
    public func emit(source presenter: PresenterProtocol, model: ModelProtocol, dml: DML){
        
        switch presenter {
        case is SearchedGroupPresenter:
            let p1 = presenters[String(describing: GroupPresenter.self)]
            print("presenter p 1: \(presenter)")
            p1?.handleEmit(with: model, dml: dml)
        default: return
        }
    }
    
}
