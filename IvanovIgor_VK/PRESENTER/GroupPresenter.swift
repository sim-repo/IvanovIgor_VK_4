import Foundation
import Alamofire


var gGroups: [Group] = []


public class GroupPresenter: BasePresenter {
    
    
    let urlPath: String = "groups.get"
    
    override func loadModel(completion: (()->Void)?=nil ){
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["description","members_count","photo_50","photo_200"],
            "v": "5.80"
        ]
        
        AlamofireNetworkManager.doGet(clazz: Group.self, presenter: self, urlPath: urlPath, params: params, completion: completion)
    }
    
    override func setModel(ds: [ModelProtocol]) {
        let groups = ds as? [Group]
        if let gr = groups {
            self.ds = gr.sorted(by: { $0.name < $1.name })
        }
    }
    
    // ДЗ 4 >>>
    // сохранять то, что было получено из сети
    func savePersistence(groups: [Group]?){
        guard let groups = groups
            else {
                return
        }
        for g in groups {
           GroupPersistence(name: g.name,
                            desc: g.description,
                            imageURL50: g.imageURL50 ?? "",
                            imageURL200: g.imageURL200 ?? "")
        }
    }
    
    // подгружать в случае,если нет сети
    func loadPersistence()->[Group]?{
        var res: [Group]? = []
        guard let recs = GroupPersistence.loadPersistence()
            else {
                return nil
        }
        
        for r in recs {
            let group = Group(id:r.id,
                              name: r.name,
                              description: r.desc,
                              imageURL50: r.imageURL50,
                              imageURL200: r.imageURL200)
            res?.append(group)
        }
        return res
    }
    // ДЗ 4 <<<
    
    
    override func refreshData()->( [ModelProtocol], [String] ){
        
        guard var tempGroups = ds as? [Group] ?? loadPersistence() else {
            return ([], [])
        }
        
        if let filteredText  = filteredText {
            tempGroups = tempGroups.filter({
                $0.name.lowercased().contains(filteredText.lowercased())
            })
        }
        
        var groupingProps: [String] = []
        for group in tempGroups {
            groupingProps.append(group.name )
        }
        return (tempGroups, groupingProps)
    }
    
    
    override func update(object: AnyObject)->Void {
        let group = object as! Group
        group.isMember = true
        loadModel()
    }
    
    
    override func remove(object: AnyObject) {
        let group = object as! Group
        group.isMember = false
        loadModel()
    }
    
}
