import UIKit

extension UICollectionViewFlowLayout {

    var collectionViewWidthWithoutInsets: CGFloat {
        get {
            guard let collectionView = self.collectionView else { return 0 }
            let collectionViewSize = collectionView.bounds.size
            let widthWithoutInsets = collectionViewSize.width
                - self.sectionInset.left - self.sectionInset.right
                - collectionView.contentInset.left - collectionView.contentInset.right
            return widthWithoutInsets
        }
    }
}

class StickyFlowLayout: UICollectionViewFlowLayout {
    
    var presenter: PresenterProtocol?

    let cellAspectRatio: CGFloat = 3/1

    override func prepare() {
        
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 10
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: self.minimumLineSpacing, right: 0)
        let collectionViewWidth = self.collectionView?.bounds.size.width ?? 0
        self.headerReferenceSize = CGSize(width: collectionViewWidth, height: 40)
        

        let itemWidth = collectionViewWidthWithoutInsets
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
        

        super.prepare()
    }
    
    
}
