import UIKit

var allNews = News.allList()

class NewsCollectionController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: PresenterProtocol?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
    //    flowLayout.presenter = presenter
       // let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
       // flowLayout.itemSize = CGSize(width: self.view.frame.width-30, height: self.view.frame.width-30)
    }
    
    private func setupPresenter(){
        presenter = Configurator.shared.getPresenter(viewController: self, loadType: .networkFirst) { // TODO
        self.refreshDataSource()
        self.collectionView.reloadData()
        }
    }
    
    public func refreshDataSource(){
        presenter?.refreshDataSource(with: nil)
    }
}



extension NewsCollectionController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = presenter?.numberOfRowsInSection(section: section) ?? 0
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        
        guard let data = presenter?.getData(indexPath: indexPath)
            else {
                return UICollectionViewCell()
        }
        let news = data as! News
        
        
        if let count = news.images?.count {
            switch count {
            case 1:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "News1PhotoCell", for: indexPath) as! NewsCollectionCell
                c.postImageView.userActivityType = .look
                c.likeImageView.userActivityType = .like
                
                c.text.text = news.desc
                c.postImageView.image = news.images?[0] ?? UIImage(named:"apple")
                cell = c
                c.likeImageView.boundMetrics = c.likeNumber
                break
            case _ where count == 2 :
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "News2PhotosCell", for: indexPath) as! News2PhotosCell
                c.postImage1.userActivityType = .look
                c.postImage2.userActivityType = .look
                c.likeImageView.userActivityType = .like
                
                c.postImage1.image = news.images?[0]
                c.postImage2.image = news.images?[1]
                cell = c
                c.likeImageView.boundMetrics = c.likeNumber
                break
            case _ where count == 3 :
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "News3PhotosCell", for: indexPath) as! News3PhotosCell
                c.postImage1.userActivityType = .look
                c.postImage2.userActivityType = .look
                c.postImage3.userActivityType = .look
                c.likeImageView.userActivityType = .like
                
                c.postImage1.image = news.images?[0]
                c.postImage2.image = news.images?[1]
                c.postImage3.image = news.images?[2]
                cell = c
                c.likeImageView.boundMetrics = c.likeNumber
                break
            case _ where count == 4 :
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "News4PhotosCell", for: indexPath) as! News4PhotosCell
                c.postImage1.userActivityType = .look
                c.postImage2.userActivityType = .look
                c.postImage3.userActivityType = .look
                c.postImage4.userActivityType = .look
                c.likeImageView.userActivityType = .like
                
                c.postImage1.image = news.images?[0]
                c.postImage2.image = news.images?[1]
                c.postImage3.image = news.images?[2]
                c.postImage4.image = news.images?[3]
                cell = c
                c.likeImageView.boundMetrics = c.likeNumber
                break
            case _ where count == 5 :
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "News5PhotosCell", for: indexPath) as! News5PhotosCell
                c.postImage1.userActivityType = .look
                c.postImage2.userActivityType = .look
                c.postImage3.userActivityType = .look
                c.postImage4.userActivityType = .look
                c.postImage5.userActivityType = .look
                c.likeImageView.userActivityType = .like
                
                c.postImage1.image = news.images?[0]
                c.postImage2.image = news.images?[1]
                c.postImage3.image = news.images?[2]
                c.postImage4.image = news.images?[3]
                c.postImage5.image = news.images?[4]
                cell = c
                c.likeImageView.boundMetrics = c.likeNumber
                break
            case _ where count == 6 :
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "News6PhotosCell", for: indexPath) as! News6PhotosCell
                c.postImage1.userActivityType = .look
                c.postImage2.userActivityType = .look
                c.postImage3.userActivityType = .look
                c.postImage4.userActivityType = .look
                c.postImage5.userActivityType = .look
                c.postImage6.userActivityType = .look
                c.likeImageView.userActivityType = .like
                
                
                c.postImage1.image = news.images?[0]
                c.postImage2.image = news.images?[1]
                c.postImage3.image = news.images?[2]
                c.postImage4.image = news.images?[3]
                c.postImage5.image = news.images?[4]
                c.postImage6.image = news.images?[5]
                cell = c
                c.likeImageView.boundMetrics = c.likeNumber
                break
            default:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "News1PhotoCell", for: indexPath) as! NewsCollectionCell
             //   c.postText.text = news.description
                c.postImageView.image = news.images?[0] ?? UIImage(named:"apple")
                c.likeImageView.boundMetrics = c.likeNumber
                cell = c
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNewsDetailsSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else { return }
        
        if segue.identifier == "ShowNewsDetailsSegue",
            let dest = segue.destination as? NewsDetailsController {
            guard let data = presenter?.getData(indexPath: indexPath)
                else {
                    return
            }
            let news = data as! News
            dest.news = news
        }
    }
    
}


// MARK: Refresh Protocol Delegate
extension NewsCollectionController: ViewProtocolDelegate {
    func optimReloadCells(_ deletions: [IndexPath], _ insertions: [IndexPath], _ updates: [IndexPath]) {
        
    }
    
    func className() -> String {
        return String(describing: self)
    }
    
    
    func optimReloadCell(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func reloadCells() {
        let indexPaths = collectionView.indexPathsForVisibleItems
        collectionView.reloadItems(at: indexPaths)
    }
    
    func insertNewSections(sections: IndexSet){
        collectionView.insertSections(sections)
    }
}
