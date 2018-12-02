import Foundation
import UIKit
import RealmSwift

public class BasePresenter: PresenterProtocol {
  
    weak var view: ViewProtocolDelegate?
    
    var sortedDataSource: [ModelProtocol] = []
    
    private var sectionsOffset: [Int] = []
    private var groupingProperties: [String] = []
    private var sectionsTitle: [Alphabet] = []
    
    internal var filteredText: String?
    internal var realmToken: NotificationToken?
    
    public var state: StatePresenterType = .initial
    
    var numberOfSections: Int {
        return sectionsOffset.count
    }
    
    // constructor for preloading
    // view doesn't exists yet
    convenience init(_ loadType: LoadModelType, completion: (()->Void)? ) {
        self.init()
        loadModel(loadType, completion)
    }
    
    func postPreloading(view: ViewProtocolDelegate, completion: (()->Void)?){
        self.view = view
        completion?()
    }
    
    // view already exists
    func setup(view: ViewProtocolDelegate, _ loadType: LoadModelType, completion: (()->Void)? ){
        self.view = view
        loadModel(loadType, completion)
    }
    

    private final func loadModel(_ loadType: LoadModelType, _ completion: (()->Void)?) {
        switch loadType {
        case .diskFirst:
            print("######## LOADING FROM DISK ########")
            let outerCompletion = {[weak self] in
                if self?.sortedDataSource.count == 0 {
                    print("######## TRYING LOADING FROM NETWORK ########")
                    self?.loadFromNetwork(completion: completion)
                } else {
                    completion?()
                }
            }
            loadFromDisk(completion: outerCompletion)
        case .networkFirst:
            print("######## LOADING FROM NETWORK ########")
            let outerCompletion = {[weak self] in
                if self?.sortedDataSource.count == 0 {
                    print("######## TRYING LOADING FROM DISK ########")
                    self?.loadFromDisk(completion: completion)
                } else {
                    completion?()
                }
            }
            loadFromNetwork(completion: outerCompletion)
        }
    }
    
    
    open func redrawUI(){
        self.sortedDataSource = sortModel(self.sortedDataSource)
        view?.reloadCells()
    }
    
    
    func onDidModelChanged<T: ModelProtocol>(_ results: [T], _ deletions: [Int], _ insertions: [Int], _ modifications: [Int], forceFullReload: Bool){
        
        // changed key or grouping field
        if forceFullReload || insertions.count > 0 || deletions.count > 0 {
            redrawUI()
            return
        }
        
        // changed any other fields,
        // reactive refresh
        var indexPathsUpdate: [IndexPath] = []
        for idx in modifications {
            let model = results[idx]
            if let indexPath = getIndexPath(model: model) {
                indexPathsUpdate.append(indexPath)
            }
        }
        guard indexPathsUpdate.count > 0
            else {
                fatalError("no indexPaths in array") // only for testing
            }
        
        view?.optimReloadCells([], [], indexPathsUpdate)
    }
    
    
    func setModel(ds: [ModelProtocol], didLoadedFrom: LoadModelType) {
      
        self.sortedDataSource = sortModel(ds)
        
        switch didLoadedFrom {
            case .diskFirst:
                return // data stored already
            case .networkFirst:
                saveModel(ds: ds)
        }
    }
    
    
    func setState(state: StatePresenterType) {
        self.state = state
    }
    
     //MARK: ***** overriding functions *****
    
    func loadFromDisk(completion: (()->Void)? = nil){
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func loadFromNetwork(completion: (()->Void)? = nil){
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func refreshData()->( [ModelProtocol], [String] ){
        return ([],[])
    }
    
    // TODO: избавиться от метода -->
    func refreshData()->( [AnyObject], [String] ){
        return ([],[])
    }
    // TODO: избавиться от метода <--
    
    func update(object: AnyObject)->Void {
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func remove(object: AnyObject) {
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func getContentVolume(indexPath: IndexPath) -> ContentVolume {
        return .def
    }
    
    func sendRequest(searchText: String, completion:(()->Void)?){
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func searchData(searchText: String, completion: (()->Void)?) {
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func saveModel(ds: [ModelProtocol]) {
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func sortModel(_ ds: [ModelProtocol]) -> [ModelProtocol]{
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func getGroupByDataSource() -> [String] {
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    
    func changeGroupBy(by fieldName: String) {
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func modelLoadImages(arr: [ModelProtocol]?){
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    
    func setAlien(with object: ModelProtocol) {
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    //MARK: ***** final functions *****
    
    final func setup(_sortedDataSource: [ModelProtocol], _groupingProperties: [String]){
        guard _sortedDataSource.count > 0 else {
            sectionsOffset = []
            sectionsTitle = []
            return
        }
        sortedDataSource = _sortedDataSource
        groupingProperties = _groupingProperties
        (sectionsTitle, sectionsOffset)  = Alphabet.getOffsets(with: groupingProperties)
    }
    
   
    
    public final func refreshDataSource(with completion: (([String])->Void)? = nil) {
        (sortedDataSource,groupingProperties) = refreshData()
        setup(_sortedDataSource: sortedDataSource, _groupingProperties: groupingProperties)
        completion?(groupingProperties)
    }
    
    
    public func filterData(_ filterText: String, fromView completion: (([String])->Void)? = nil) {
        filteredText = !filterText.isEmpty ? filterText : nil
        let outerCompletion: ([String])->Void = {[weak self] (name) in
            completion?(name)
            self?.view?.reloadCells()
        }
        refreshDataSource(with: outerCompletion)
    }
    
    
    public final func numberOfRowsInSection(section: Int) -> Int {
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource.count
            }
        let offset = sectionsOffset[section]
        
        guard numberOfSections > section + 1
            else {
                return sortedDataSource.count - offset
            }
        
        let next = sectionsOffset[section+1]
        return next - offset
    }
    
    
    final func getData(indexPath: IndexPath) -> ModelProtocol? {
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource[indexPath.row]
            }
        let offset = sectionsOffset[indexPath.section]
        
        guard sortedDataSource.count > offset + indexPath.row
            else {
                return nil
        }
        
        return sortedDataSource[offset + indexPath.row]
    }
    
    
    final func getIndexPath(model: ModelProtocol) -> IndexPath?{
        
        guard let sortedIdx = sortedDataSource.firstIndex(where: { $0.getId() == model.getId() })
            else {return nil}
        
        if sectionsOffset.count == 0 {
            return IndexPath(row: sortedIdx, section: 0)
        }
        
        guard let sectionIdx = sectionsOffset.firstIndex(where: { $0 > sortedIdx })
            else {return nil}
        guard sectionIdx > 0
            else {return nil}
        
        let offset = sectionsOffset[sectionIdx-1]
        
        let row = sortedIdx - offset
        
        return IndexPath(row: row, section: sectionIdx-1)
    }
    
    
    
    
    public final func sectionName(section: Int)->String {
        let idx = sectionsTitle[section].rawValue
        return String(Alphabet.titles[idx])
    }
    
    public final func viewDeinit() {
        realmToken?.invalidate()
    }
    
    public final func getGroupByProperties() -> [String] {
        return groupingProperties
    }
    
    
    
    final func realmNotify<T: BaseModel>(realmData: inout Results<T>?){
        guard self.realmToken == nil
            else { return }
        
        if realmData == nil {
            realmData = realmLoadData(clazz: T.self)
        }
        if realmData == nil {
            fatalError("realmNotify: realmData is nil")
        }
        self.realmToken = realmData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                self?.modelLoadImages(arr: self?.sortedDataSource)
                
            case let .update(results, deletions, insertions, modifications):
                var forceRealod = false
                var reloadRightNow = false
                
                if deletions.count == 0 && insertions.count == 0 && modifications.count > 0 {
                    for idx in modifications {
                        let obj = self?.sortedDataSource.first(where: {$0.getId() == results[idx].getId()}) as? MyFriend
                        if results[idx].getGroupByField() != obj?.getXGroupByField() {
                            obj?.updateXGroupByField(val: results[idx].getGroupByField())
                            forceRealod = true
                        }
                        if results[idx].isImageURLChanged() {
                            let obj = results[idx]
                            self?.modelLoadImages(arr: [obj])
                        }
                        if obj?.isURLlessChanded() ?? false {
                            reloadRightNow = true
                        }
                    }
                }
                if reloadRightNow || forceRealod {
                    print("reload right now!")
                    self?.onDidModelChanged(results.toArray(ofType: T.self), deletions, insertions, modifications, forceFullReload: forceRealod)
                }
                
            case .error(let error):
                print(error)
                
            default: break
            }
        }
    }
    
    final func realmLoadData<T: Object>(clazz: T.Type)->Results<T>?{
        return DatabaseService.realmLoad(clazz: clazz)
    }
    
    
  
    
    func getModel()->[ModelProtocol] {
        return sortedDataSource
    }
    
    func removeModel(){
        sortedDataSource.removeAll()
    }
    
    func viewWillAppear() {
        switch state {
        case .modelDidUpdated:
            state = .noChanged
            self.redrawUI()
        default:
            return
        }
    }
    
    
    func setDML(indexPath: IndexPath, dml: DML) {
        guard let data = getData(indexPath: indexPath)
            else {
                fatalError() //TODO
            }
        handleEmit(with: data, dml: dml)
    }
    
    
    func handleEmit(with model: ModelProtocol, dml: DML) {
        Configurator.shared.emit(source: self, model: model, dml: dml)
    }
    
    func className() -> String {
        return String(describing: BasePresenter.self)
    }
}
