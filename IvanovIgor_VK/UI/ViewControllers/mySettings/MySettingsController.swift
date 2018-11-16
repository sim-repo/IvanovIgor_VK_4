//
//  MySettingsController.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 01.10.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

class MySettingsController: UIViewController {

    @IBOutlet weak var profileImageView: RoundedImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = UIImage(named: "baikal")
    }

    @IBAction func showAllPhotos(_ sender: Any) {
        performSegue(withIdentifier: "ShowMyPhotos", sender: nil)
    }
    
}
