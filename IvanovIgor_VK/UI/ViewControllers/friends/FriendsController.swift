import UIKit

protocol FriendDetailsDelegate: class {
    func prepareForRun(with friend: MyFriend)
}

class FriendsController: UIViewController {

    var presenter: PresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lettersSearchControl: LettersSearchControl!
    @IBOutlet weak var letterShowConstraint: NSLayoutConstraint!
    @IBOutlet weak var showLetterView: UIView!
    
    @IBOutlet weak var showLetterLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    private let sortingViewDS = ["Apple","Microsoft","Samsung","Android", "Google"]
    
    let searchController = UISearchController(searchResultsController: nil)
    var headerCell: HeaderCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerCell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        
        setupNavigationBarColor()
        setupStandardSearchController()
        setupPresenter()
        setupAlphabetSearchControl()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        setupShowLetter()
    }
    
    
    private func setupNavigationBarColor(){
        var colors = [UIColor]()
        colors.append(UIColor(red: 0/255, green: 31/255, blue: 0/255, alpha: 0.1))
        colors.append(UIColor(red: 79/255, green: 153/255, blue: 0, alpha: 0.1))
        colors.append(UIColor(red: 0/255, green: 31/255, blue: 0/255, alpha: 0.1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
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
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .default
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
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
    
    deinit {
        presenter?.viewDeinit()
        presenter = nil
    }
    
    private func setupPresenter(){
        presenter = Configurator.shared.getPresenter(viewController: self, loadType: .diskFirst, completion: nil) //TODO loadType перенести в координатор
        self.refreshDataSource()
    }
    
    
    private func setupAlphabetSearchControl(){
        guard let presenter = presenter
            else {return}
        lettersSearchControl.delegate = self
        lettersSearchControl.updateControl(with: presenter.getGroupByProperties())
    }
    
    
    public func refreshDataSource(){
        presenter?.refreshDataSource(){ [unowned self] (names) in
            self.lettersSearchControl.updateControl(with: names)
        }
    }
    
}


extension FriendsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath) as! FriendTableCell
        guard let data = presenter?.getData(indexPath: indexPath)
            else {
                return UITableViewCell()
            }
        
        let friend = data as! MyFriend
        cell.name = friend.firstName + " " + friend.lastName
        cell.photoImage = friend.image50
        
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        } else {
            cell.backgroundColor = UIColor(displayP3Red: 50/255, green: 50/255, blue: 50/255, alpha: 0.25)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "DetailsFriendSegue", sender: indexPath)
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        headerCell.titleLabel.text = presenter?.sectionName(section: section)
        return headerCell
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.sectionName(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerCell?.frame.size.height ?? 50
    }
    
    
    
// commented out 8.1 >>>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else { return }

        if segue.identifier == "DetailsFriendSegue",
            let dest = segue.destination as? FriendDetailsDelegate {
            guard let data = presenter?.getData(indexPath: indexPath)
                else {
                    return
                }
            let friend = data as! MyFriend
            dest.prepareForRun(with: friend)
        }
    }
}

extension FriendsController: AlphabetSearchViewControlProtocol {
    func didEndTouch() {
        hideLetter()
    }
    
    func didChange(indexPath: IndexPath) {
        guard let presenter = presenter
            else {return}
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        let title = presenter.sectionName(section: indexPath.section)
        changeLetter(title: title)
    }
    
    func getView() -> UIView {
        return self.view
    }
}



extension FriendsController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        
        self.letterShowConstraint.constant = 0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.letterShowConstraint.constant = 35
            self.view.layoutIfNeeded()
        })
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.letterShowConstraint.constant = 35
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.letterShowConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}

extension FriendsController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterData(searchText)
        refreshDataSource() { [weak self] (name) in
            self.reload
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.filterData("")
        refreshDataSource()
    }
}

extension FriendsController: ViewProtocolDelegate{
   
    func className() -> String {
        return String(describing: FriendsController.self)
    }
    
    func optimReloadCell(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates();
    }
    
    func optimReloadCells(_ deletions: [IndexPath], _ insertions: [IndexPath], _ updates: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: deletions, with: .automatic)
        tableView.insertRows(at: insertions, with: .automatic)
        tableView.reloadRows(at: updates, with: .automatic)
        tableView.endUpdates();
    }
    
    // called when changed grouping field
    func reloadCells() {
        refreshDataSource() {
            tableView.reloadData()
        }
    }
    
    func insertNewSections(sections: IndexSet){
        tableView.insertSections(sections, with: .automatic)
    }
}


extension FriendsController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.getGroupByDataSource().count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.getGroupByDataSource()[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        if let s = presenter?.getGroupByDataSource()[row] {
            presenter?.changeGroupBy(by: s) //TODO
        }
        
    }
}
