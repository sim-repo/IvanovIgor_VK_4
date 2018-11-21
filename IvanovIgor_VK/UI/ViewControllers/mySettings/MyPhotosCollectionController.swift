import UIKit


class MyPhotosCollectionController: UICollectionViewController , UIViewControllerTransitioningDelegate {

    
    var presenter: PresenterProtocol? 
    
    let transition = CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up a 3-column Collection View
        let width = view.frame.size.width / 2
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        let recognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handleGesture(_:)))
        self.view.addGestureRecognizer(recognizer)
        setupPresenter()
    }
    
    deinit {
        presenter = nil
    }
    
    
    private func setupPresenter(){
        presenter = Configurator.shared.getPresenter(viewController: self, loadType: .diskFirst){
        self.refreshDataSource()
        self.collectionView?.reloadData()
        }
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let presenter = presenter {
            return presenter.numberOfSections == 0 ? 1 : presenter.numberOfSections
        }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let presenter = presenter {
            return presenter.numberOfRowsInSection(section: section)
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPhotosCollectionCell", for: indexPath)
    
        if let presenter = presenter {
        
            guard let data = presenter.getData(indexPath: indexPath)
                else {
                    return UICollectionViewCell()
            }
            
            if let photo = data as? MyPhotos {
                let imageView = cell.viewWithTag(3000) as! UIImageView
                imageView.image = photo.photo
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMyPhotoSegue", sender: indexPath)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        
        transition.circleColor = UIColor.orange
        return transition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.circleColor = UIColor.orange
        return transition
    }
    
    public func refreshDataSource(){
        presenter?.refreshDataSource(with: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        let frame = collectionView!.layoutAttributesForItem(at: indexPath)!.frame
        transition.startingPoint = CGPoint(x: frame.midX, y: frame.midY)
        let dest = segue.destination as! MyPhotoController
        dest.transitioningDelegate = self
        dest.modalPresentationStyle = .custom
        if let photo = presenter?.getData(indexPath: indexPath) as? MyPhotos {
            dest.myPhotoImage = photo.photo
        }
        //TODO: dest.myPhoto = photo 
    }
    
    @objc func handleGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
            
            
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            if progress > 0.33 {
                dismiss(animated: true, completion: nil)
            }
        default: return
        }
    }
    

}

extension MyPhotosCollectionController: ViewProtocolDelegate{
    
    func className() -> String {
        return String(describing: self)
    }
    
    func reloadCell(indexPath: IndexPath) {
        collectionView?.reloadItems(at: [indexPath])
    }
    
    func reloadCells() {
        let indexPaths = collectionView?.indexPathsForVisibleItems
        if let indexPaths = indexPaths {
            collectionView?.reloadItems(at: indexPaths)
        }
    }
}
