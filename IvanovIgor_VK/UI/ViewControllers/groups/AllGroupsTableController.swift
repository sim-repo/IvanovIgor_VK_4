import UIKit


class AllGroupsTableController: UITableViewController {
    
    var presenter: PresenterProtocol?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupStandardSearchController()
        refreshDataSource()
    }
    
    deinit {
        presenter = nil
    }
    
    private func setupPresenter(){
        presenter = Configurator.shared.getPresenter(viewController: self){
            self.refreshDataSource()
            self.tableView.reloadData()
        }
    }
    
    public func refreshDataSource(){
        presenter?.refreshDataSource(with: nil)
    }
    
    private func setupStandardSearchController(){
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        searchController.delegate = self
        
        // cancel-button text color
        searchController.searchBar.tintColor = .white
        
        // white color input text
        searchController.searchBar.barStyle = .default
        
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
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
    }
}

extension AllGroupsTableController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections ?? 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsTableCell
        
        guard let data = presenter?.getData(indexPath: indexPath)
            else {
                return UITableViewCell()
            }
        let allGroup = data as! Group
        cell.logo50ImageView.image = allGroup.image50
        cell.groupNameLabel.text = allGroup.name
        return cell
    }
}


// MARK: Standard Search Controller
extension AllGroupsTableController: UISearchControllerDelegate {

}

extension AllGroupsTableController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchData(searchText: searchText) {
            self.refreshDataSource()
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.searchData(searchText: "") {
            self.refreshDataSource()
            self.tableView.reloadData()
        }
    }
}


extension AllGroupsTableController: ViewProtocolDelegate {
    
    func className() -> String {
        return String(describing: AllGroupsTableController.self)
    }
    
    func reloadCell(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates();
    }
    
    func reloadCells() {
        tableView.beginUpdates()
        let indexPaths = tableView.indexPathsForVisibleRows!
        tableView.reloadRows(at: indexPaths, with: .automatic)
        tableView.endUpdates();
    }
}

