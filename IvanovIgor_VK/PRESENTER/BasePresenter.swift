import Foundation
import UIKit


public class BasePresenter: PresenterProtocol {
    
    var ds: [ModelProtocol]?
    
    weak var view: ViewProtocolDelegate?
    
    private var sortedDataSource: [ModelProtocol] = []
    private var sectionsOffset: [Int] = []
    private var groupingProperties: [String] = []
    private var sectionsTitle: [Alphabet] = []
    internal var filteredText: String?
    
    var numberOfSections: Int {
        return sectionsOffset.count
    }
    
    
    // Задание 5: рефакторинг >>>
    
    init(){
        NotificationCenter.default.add(observer: self, selector: #selector(onNeedDownload(_:)), notification: .needDownload)
        NotificationCenter.default.add(observer: self, selector: #selector(onDidModelChanged(_:)), notification: .didModelChanged)
    }
    
    
    // constructor for preloading
    // view doesn't exists yet
    convenience init(completion: (()->Void)?) {
        self.init()
        loadModel(completion: completion)
    }
    
    func postPreloading(view: ViewProtocolDelegate, completion: (()->Void)?){
        self.view = view
        completion?()
    }
    
    // view already exists
    func setup(view: ViewProtocolDelegate, completion: (()->Void)?){
        self.view = view
        loadModel(completion: completion)
    }
    
    // Задание 5: рефакторинг  <<<
   
    
    //MARK: ***** model 2 presentation functions *****
    
    @objc func onNeedDownload(_ notification: Notification){
        guard let url = notification.userInfo!["url"] as? URL
            else { return }
        
        guard let completion = notification.userInfo!["completion"] as? ((_: Data) -> Void)
            else { return }
        
        AlamofireNetworkManager.doGet(url: url, completion: completion)
    }
    
    
    @objc func onDidModelChanged(_ notification: Notification){
        guard let model = notification.userInfo!["model"] as? ModelProtocol
            else { return }
        
        guard let indexPath = getIndexPath(model: model)
            else { return }
        
        view?.reloadCell(indexPath: indexPath)
    }
    
    
    
    
    
    //MARK: ***** overriding functions *****
    
    func loadModel(completion:(()->Void)?){
        fatalError("Override Error: this method must be overriding by child classes")
    }
    
    func setModel(ds: [ModelProtocol]) {
        self.ds = ds
    }
    
    func refreshData()->( [ModelProtocol], [String] ){
        return ([],[])
    }
    
    // TODO: избавиться от метода -->
    func refreshData()->( [AnyObject], [String] ){
        return ([],[])
    }
    
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
    
   
    
    final func refreshDataSource(with completion: (([String])->Void)? ) {
        (sortedDataSource,groupingProperties) = refreshData()
        setup(_sortedDataSource: sortedDataSource, _groupingProperties: groupingProperties)
        completion?(groupingProperties)
    }
    
    
    final func numberOfRowsInSection(section: Int) -> Int {
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
    
    private final func getIndexPath(model: ModelProtocol) -> IndexPath?{
        guard let sortedIdx = sortedDataSource.firstIndex(where: { $0.id == model.id })
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
    
    
    final func sectionName(section: Int)->String {
        let idx = sectionsTitle[section].rawValue
        return String(Alphabet.titles[idx])
    }
    
    final func getGroupingProperties() -> [String] {
        return groupingProperties
    }
    
    
    func filterData(_ filterText: String) {
        filteredText = !filterText.isEmpty ? filterText : nil
    }
    

    func handleWillChanges(url: URL?, completion: ((_: Data) -> Void)?) {
        AlamofireNetworkManager.doGet(url: url, completion: completion)
    }
    
}
