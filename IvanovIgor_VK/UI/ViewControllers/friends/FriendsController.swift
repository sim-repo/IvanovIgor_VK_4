import UIKit

protocol FriendDetailsDelegate: class {
    func prepareForRun(with friend: MyFriend)
}

class FriendsController: UIViewController {

    var presenter: PresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lettersSearchControl: LettersSearchControl!
    @IBOutlet weak var letterShowConstraint: NSLayoutConstraint!
    
    
    
    // Задание 6.5: анимация >>>
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var loupeImageView: UIImageView!
    @IBOutlet weak var loupeCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var loupeLeadingXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchTextWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextCenterDxConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonSearchCancel: UIButton!
    var searchTextWidth: CGFloat = 0
    // Задание 6.5: анимация <<<
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupAlphabetSearchControl()
     //   setupStandardSearchController()
        searchTextField.delegate = self  // Задание 6.5: анимация
        searchTextWidth = searchTextWidthConstraint.constant // Задание 6.5: анимация

    }
    
    deinit {
        presenter = nil
    }
    
    private func setupPresenter(){
        presenter = Configurator.shared.getPresenter(viewController: self, loadType: .diskFirst, completion: nil) //TODO loadType перенести в координатор
        self.refreshDataSource()
        self.tableView.reloadData()
    }
    
    
    private func setupAlphabetSearchControl(){
        guard let presenter = presenter
            else {return}
        lettersSearchControl.delegate = self
        lettersSearchControl.updateControl(with: presenter.getGroupingProperties())
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
    
    
    // Задание 6.5: анимация >>>
    @IBAction func pressButtonSearchCancel(_ sender: Any) {
        searchTextReset()
    }
    
    @IBAction func searchTextEditingChange(_ sender: Any) {
        
        guard let presenter = presenter
            else { return }
        
        if searchTextField.text?.isEmpty ?? true {
            searchTextReset()
            return
        }
        
        
        presenter.filterData(searchTextField.text!)
        refreshDataSource()
        tableView.reloadData()
    }
    
    private func searchTextReset(){
        
        guard let presenter = presenter
            else { return }
        
        searchTextField.text = ""
        buttonSearchCancel.isEnabled = false
        buttonSearchCancel.setTitleColor(.clear, for: .normal)
        searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 1.0, animations: {
            self.loupeLeadingXConstraint.isActive = false
            self.loupeCenterXConstraint.isActive = true
            self.searchTextWidthConstraint.constant = self.searchTextWidth
            self.searchTextCenterDxConstraint.isActive = false
            self.searchTextCenterXConstraint.isActive = true
            
            self.view.layoutIfNeeded()
        })
        presenter.filterData("")
        refreshDataSource()
        tableView.reloadData()
    }
    // Задание 6.5: анимация <<<

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
        cell.name = friend.firstName + " "+friend.lastName
        cell.photoImage = friend.profilePictureImage50

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsFriendSegue", sender: indexPath)
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        return view
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.sectionName(section: section)
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
        // TODO
    }
    
    func didChange(indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        refreshDataSource()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.filterData("")
        refreshDataSource()
        tableView.reloadData()
    }
    
}


//MARK:- UITextFieldDelegates

// Задание 6.5: анимация >>>
extension FriendsController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField?.text?.count != 0 {
            
        }
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else {return}
        buttonSearchCancel.isEnabled = true
        buttonSearchCancel.setTitleColor(.blue, for: .normal)
        UIView.animate(withDuration: 1.0, animations: {
            self.loupeCenterXConstraint.isActive = false
            self.loupeLeadingXConstraint.isActive = true
            self.searchTextWidthConstraint.constant = self.searchTextWidth - 80
            self.searchTextCenterXConstraint.isActive = false
            self.searchTextCenterDxConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? true{
            searchTextReset()
        }
        return true
    }
}
// Задание 6.5: анимация <<<


extension FriendsController: ViewProtocolDelegate{
    func className() -> String {
        return String(describing: FriendsController.self)
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
