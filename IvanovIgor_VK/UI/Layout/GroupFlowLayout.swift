import UIKit

class GroupFlowLayout: UICollectionViewFlowLayout{
    
    var cacheAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
    var presenter: PresenterProtocol?
    private var standardHeightCell: CGFloat = 400
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        
        
        guard let collection = self.collectionView else {
            return
        }
        
        let itemsCount = collection.numberOfItems(inSection: 0)
        
        guard itemsCount > 0 else {
            return
        }
        
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 50
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: self.minimumLineSpacing, right: 0)
        
        let cellFullWidth = collectionViewWidthWithoutInsets
        var lastY: CGFloat = 0
    
        for index in 0..<itemsCount {
            let indexPath = IndexPath.init(row: index, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let cellHeight = calcCellHeight(indexPath)
            
            attr.frame = CGRect(x: 0, y: lastY, width: cellFullWidth, height: cellHeight)
            lastY += cellHeight
            cacheAttributes[indexPath] = attr
        }
        self.totalCellsHeight = lastY
        super.prepare()
    }
    
    func calcCellHeight(_ indexPath: IndexPath)->CGFloat {
        let vol = presenter?.getContentVolume(indexPath: indexPath)
        guard let _vol = vol else {
            return standardHeightCell
        }
        switch _vol {
            case .def: return standardHeightCell
            
            case .label: return standardHeightCell
            case .text: return standardHeightCell
            case .bigText: return standardHeightCell
            case .photo1: return standardHeightCell
            case .photo1MidText: return standardHeightCell
            case .photo1BigText: return standardHeightCell
            
        case .photos2:
            print("2")
            return standardHeightCell + 300
            
            case .photos2MidText: return standardHeightCell
            case .photos2BigText: return standardHeightCell
            
            case .photos3: return standardHeightCell
            case .photos3MidText: return standardHeightCell
            case .photos3BigText: return standardHeightCell
            
            case .photos4: return standardHeightCell
            case .photos4MidText: return standardHeightCell
            case .photos4BigText: return standardHeightCell
            
            case .photos5: return standardHeightCell
            case .photos5MidText: return standardHeightCell
            
            case .photos6: return standardHeightCell
            case .photos6MidText: return standardHeightCell
            
            case .photos7: return standardHeightCell
            case .photos7MidText: return standardHeightCell
            
            case .photos8: return standardHeightCell
            case .photos8MidText: return standardHeightCell
            default: return standardHeightCell
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attr in
            return rect.intersects(attr.frame)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize.init(width: self.collectionView?.frame.width ?? 0,
                           height: totalCellsHeight)
    }
}
