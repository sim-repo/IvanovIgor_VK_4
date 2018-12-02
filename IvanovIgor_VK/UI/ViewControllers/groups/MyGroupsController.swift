import UIKit

enum OperationType {
    case add, delete
}

class MyGroupsController: UIViewController {

    
    var presenter: PresenterProtocol?

    @IBOutlet weak var lettersSearchControl: LettersSearchControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var letterShowConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var showLetterView: UIView!
    @IBOutlet weak var showLetterLabel: UILabel!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        
        setupNavigationBarColor()
        setupPresenter()
       // presenter?.viewWillAppear()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        setupAlphabetSearchControl()
        setupStandardSearchController()
        setupShowLetter()
        presenter!.viewWillAppear()

    }
    
    private func setupNavigationBarColor(){
        var colors = [UIColor]()
        colors.append(UIColor(red: 0/255, green: 31/255, blue: 0/255, alpha: 0.1))
        colors.append(UIColor(red: 79/255, green: 153/255, blue: 0, alpha: 0.1))
        colors.append(UIColor(red: 0/255, green: 31/255, blue: 0/255, alpha: 0.1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    private func setupPresenter(){
        presenter = Configurator.shared.getPresenter(viewController: self, loadType: .diskFirst) //TODO loadType перенести в координатор
        self.refreshDataSource()
        self.collectionView.reloadData()
    }
    
    private func setupShowLetter(){
        showLetterView.alpha = 0.0
        showLetterLabel.alpha = 0.0
    }
    
    private func hideLetter(){
        UIView.animate(withDuration: 1.0, animations: {
            self.showLetterView.layer.cornerRadius = 40.0
            self.showLetterView.alpha = 0.0
        })
    }
    
    private func changeLetter(title: String){
        showLetterLabel.text = title
        showLetterLabel.alpha = 1.0
        self.showLetterView.layer.cornerRadius = 10.0
        if showLetterView.alpha == 0.0 {
            let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
            cornerAnimation.duration = 1.0
            cornerAnimation.fromValue = 40.0
            cornerAnimation.toValue = 10.0
            showLetterView.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
            UIView.animate(withDuration: 1.0, animations: {
                self.showLetterView.alpha = 1.0
            })
        }
    }
    
    
    private func setupAlphabetSearchControl(){
        guard let presenter = presenter
        else {return}
        lettersSearchControl.delegate = self
        lettersSearchControl.updateControl(with: presenter.getGroupByProperties())
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
        presenter?.refreshDataSource(){ [unowned self] (titles) in
            self.lettersSearchControl.updateControl(with: titles)
        }
    }
    
    private func updateData(group: Group, _ operation : OperationType){
        switch operation {
        case .add:
            presenter?.update(object: group)
        case .delete:
            presenter?.remove(object: group)
        }
    }
    
    private func deleteGroup(indexPath: IndexPath) {
        guard let presenter = presenter
            else {return}
        
        let data = presenter.getData(indexPath: indexPath)
        let group = data as! Group
        updateData(group: group, .delete)
        collectionView.deleteItems(at: [indexPath])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAllGroupsSegue",
            let dest = segue.destination as? AllGroupsTableController {
        }
    }

}


extension MyGroupsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       // print("viewForSupplementaryElementOfKind")
        guard let presenter = presenter
            else {return UICollectionReusableView()}
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myGroupSectionHeader", for: indexPath) as! GroupSectionHeader
        view.title = presenter.sectionName(section: indexPath.section)
        view.count = String(presenter.numberOfRowsInSection(section: indexPath.section))
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       // print("numberOfSections")
        return presenter?.numberOfSections ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  print("collectionView")
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      //  print("cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myGroupCell", for: indexPath) as! MyGroupCollectionCell
        guard let data = presenter?.getData(indexPath: indexPath)
            else {
                return UICollectionViewCell()
        }
        let group = data as! Group
        cell.logo50ImageView.image = group.image50
        cell.nameLabel.text = group.name
        return cell
    }
    
}


extension MyGroupsController: AlphabetSearchViewControlProtocol {
    
    func didEndTouch() {
        hideLetter()
    }
    
    func didChange(indexPath: IndexPath) {
        guard let presenter = presenter
            else {return}
        
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//        let sectionHeader = collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, at: indexPath) as! GroupSectionHeader
        
        let title = presenter.sectionName(section: indexPath.section)
        changeLetter(title: title)
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    
}



// MARK: Standard Search Controller
extension MyGroupsController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {

        self.letterShowConstraint.constant = 0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.letterShowConstraint.constant = -35
            self.view.layoutIfNeeded()
        })
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.letterShowConstraint.constant = -35
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.letterShowConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}

extension MyGroupsController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = presenter
            else {return}
        presenter.filterData(searchText)
        refreshDataSource()
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let presenter = presenter
            else {return}
        presenter.filterData("")
        refreshDataSource()
        collectionView.reloadData()
    }
    
}


// MARK: Refresh Protocol Delegate
extension MyGroupsController: ViewProtocolDelegate {
    
    func className() -> String {
        return String(describing: MyGroupsController.self)
    }

    func optimReloadCell(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
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
