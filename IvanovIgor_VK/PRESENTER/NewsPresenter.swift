import Foundation



public class NewsPresenter: BasePresenter {
    
    override func loadModel(completion: (()->Void)?){
        let allNews = News.allList()
        var groupingProps: [String] = []
        for news in allNews {
            news.tags?.forEach({ tag in
                groupingProps.append(tag)
            })
        }
        setup(_sortedDataSource: allNews, _groupingProperties: groupingProps)
    }
    
    override func refreshData()->( [ModelProtocol], [String] ){
        var res: [News]
        
        if let filteredText  = filteredText {
            res = News.allList().filter({$0.tags?.contains(filteredText) ?? false })
        } else {
            res = News.allList()
        }
        
        var groupingProps: [String] = []
        for news in res {
            news.tags?.forEach({ tag in
                groupingProps.append(tag)
            })
        }
        return (res, groupingProps)
    }
    
    
    override func getContentVolume(indexPath: IndexPath) -> ContentVolume {
        let news = getData(indexPath: indexPath) as! News
        
        guard let _ = news.images?.count else {
            guard let desc = news.description else { return .def }
            
            if desc.count <= 180 {
                return .text
            }
            if desc.count > 180 {
                return .bigText
            }
            return .def
        }
        
        let imageCount: Int = news.images?.count ?? 0
        let txtCount: Int = news.description?.count ?? 0
        
        let short = TextThreshold.short.rawValue
        let mid = TextThreshold.middle.rawValue
        let big = TextThreshold.big.rawValue
        
        switch imageCount {
        case 0 :
            if txtCount == 0 { return .def }
            if txtCount <= TextThreshold.short.rawValue { return .text }
            if txtCount > TextThreshold.short.rawValue {return .bigText }
        break
            
        case 1:
            if (0...short).contains(txtCount) { return .photo1 }
            if (short...mid).contains(txtCount) { return .photo1MidText}
            if (mid...big).contains(txtCount) { return .photo1BigText }
        break
            
        case 2:
            if (0...short).contains(txtCount) { return .photos2 }
            if (short...mid).contains(txtCount) { return .photos2MidText}
            if (mid...big).contains(txtCount) { return .photos2BigText }
        break
            
        case 3:
            if (0...short).contains(txtCount) { return .photos3 }
            if (short...mid).contains(txtCount) { return .photos3MidText}
            if (mid...big).contains(txtCount) { return .photos3BigText }
        break
        
            
        case 4:
            if (0...short).contains(txtCount) { return .photos4 }
            if (short...mid).contains(txtCount) { return .photos4MidText}
            if (mid...big).contains(txtCount) { return .photos4BigText }
        break
            
        case 5:
            if (0...short).contains(txtCount) { return .photos5 }
            if (short...mid).contains(txtCount) { return .photos5MidText}
        break
            
        case 6:
            if (0...short).contains(txtCount) { return .photos6 }
            if (short...mid).contains(txtCount) { return .photos6MidText}
        break
            
        case 7:
            if (0...short).contains(txtCount) { return .photos7 }
            if (short...mid).contains(txtCount) { return .photos7MidText}
        break
            
        case 8:
            if (0...short).contains(txtCount) { return .photos8 }
            if (short...mid).contains(txtCount) { return .photos8MidText}
        break
        
        default:
            return .def
        }
        
        return .def
    }
    
}
