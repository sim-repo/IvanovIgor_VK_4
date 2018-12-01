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
    
    var headerCell: HeaderCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       headerCell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        
        var colors = [UIColor]()
        colors.append(UIColor(red: 0/255, green: 31/255, blue: 0/255, alpha: 0.1))
        colors.append(UIColor(red: 79/255, green: 153/255, blue: 0, alpha: 0.1))
        colors.append(UIColor(red: 0/255, green: 31/255, blue: 0/255, alpha: 0.1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        
        setupPresenter()
        setupAlphabetSearchControl()
      // setupStandardSearchController()
        searchTextField.delegate = self  // Задание 6.5: анимация
        searchTextWidth = searchTextWidthConstraint.constant // Задание 6.5: анимация
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        setupShowLetter()
    }
    
    
    func changeColor(){
        var colors = [UIColor]()
        colors.append(UIColor(red: r1/255, green: g1/255, blue: b1/255, alpha: 1))
        colors.append(UIColor(red: r2/255, green: g2/255, blue: b2/255, alpha: 1))
        colors.append(UIColor(red: r3/255, green: g3/255, blue: b3/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
    
    var r1: CGFloat = 0
    var g1: CGFloat = 0
    var b1: CGFloat = 0
    
    var r2: CGFloat = 0
    var g2: CGFloat = 0
    var b2: CGFloat = 0
    
    var r3: CGFloat = 0
    var g3: CGFloat = 0
    var b3: CGFloat = 0
    

    
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
        self.tableView.reloadData()
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


    @IBAction func pressFilterButton(_ sender: Any) {
        pickerView.isHidden = !pickerView.isHidden
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
        refreshDataSource()
        tableView.reloadData()
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
