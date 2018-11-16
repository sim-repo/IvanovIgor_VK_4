//
//  MyPhotoController.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 18/10/2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

class MyPhotoController: UIViewController {

    
    @IBOutlet weak var myPhotoImageView: UIImageView!
    
    var myPhotoImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPhotoImageView.image = myPhotoImage
    }


    @IBAction func doPressButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
