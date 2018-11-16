//
//  FriendPhotoController.swift
//  IvanovIgor_VK
//
//  Created by MAC on 17.10.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

class FriendPhotoController: UIViewController {

    @IBOutlet weak var photoLabel: UILabel!
    
    var photoTxt: String = "🌗"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoLabel?.text = photoTxt
        // Do any additional setup after loading the view.
    }

    @IBAction func doPress(_ sender: Any) {
        performSegue(withIdentifier: "ShowFriendPhotoSegue", sender:nil)
         //self.navigationController?.pushViewController(FriendPhotoController(), animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
}
