import UIKit


class AllGroupsController: UIViewController {
    
    var presenter: PresenterProtocol?
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupStandardSearchController()
        refreshDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.viewDidDisappear()
    }
    
    
    
    private func setupPresenter(){
        presenter = Configurator.shared.getPresenter(viewController: self, loadType: .networkFirst){ //TODO loadType перенести в координатор
            self.refreshDataSource()
            self.collectionView.reloadData()
        }
    }
    
    private func setupStandardSearchController(){
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        
        if let navigationbar = self.navigationController?.navigationBar {
            navigationbar.setBackgroundImage(UIImage(), for: .default)
            navigationbar.shadowImage = UIImage()
            navigationbar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
        }
        searchController.delegate = self
        // cancel-button text color
        searchController.searchBar.tintColor = .white
        // white color input text
        searchController.searchBar.barStyle = .default
        // searchController.searchBar.barTintColor = .red
        // handle press cancel-button
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        // searchController.searchBar.searchBarStyle = .default
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 15;
                backgroundview.clipsToBounds = true;
            }
        }
    }
    
    public func refreshDataSource(){
        presenter?.refreshDataSource(){ [unowned self] (names) in
        }
    }

}


extension AllGroupsController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection")
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllGroupCell", for: indexPath)
        guard let data = presenter?.getData(indexPath: indexPath)
            else {
                return UICollectionViewCell()
        }
        let allGroup = data as! SearchedGroup
        let imageView =  cell.viewWithTag(1000) as! UIImageView
        let label = cell.viewWithTag(2000) as! UILabel
        imageView.image = allGroup.image50
        label.text = allGroup.name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.contentView.backgroundColor == UIColor.orange {
            cell?.contentView.backgroundColor = UIColor.clear
            presenter?.setDML(indexPath: indexPath, dml: .delete)
        } else {
            presenter?.setDML(indexPath: indexPath, dml: .insert)
            cell?.contentView.backgroundColor = UIColor.orange
        }
    }
}


// MARK: Standard Search Controller
extension AllGroupsController: UISearchControllerDelegate {
    
}

extension AllGroupsController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchData(searchText: searchText) {
            self.refreshDataSource()
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.searchData(searchText: "") {
            self.refreshDataSource()
            self.collectionView.reloadData()
        }
    }
}


// MARK: Refresh Protocol Delegate
extension AllGroupsController: ViewProtocolDelegate {
    
    func className() -> String {
        return String(describing: AllGroupsController.self)
    }
    
    func optimReloadCell(indexPath: IndexPath) {
        if collectionView.hasRowAtIndexPath(indexPath: indexPath) {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func optimReloadCells(_ deletions: [IndexPath], _ insertions: [IndexPath], _ updates: [IndexPath]) {
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: insertions )
            collectionView.deleteItems(at: deletions )
            collectionView.reloadItems(at: updates )
        }, completion: nil)
    }
    
    // called when changed grouping field
    func reloadCells() {
        refreshDataSource()
        collectionView.reloadData()
    }
    
    func insertNewSections(sections: IndexSet){
        collectionView.insertSections(sections)
    }
}


extension UICollectionView {
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}
