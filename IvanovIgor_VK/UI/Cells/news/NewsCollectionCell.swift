//
//  NewsCollectionCell.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 01.10.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

class NewsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var postImageView: UserActivityRegControl!
    @IBOutlet weak var likeImageView: UserActivityRegControl!
    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var msgImageView: UIImageView!
    @IBOutlet weak var msgNumber: UILabel!
    @IBOutlet weak var sharedImageView: UIImageView!
    @IBOutlet weak var sharedNumber: UILabel!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var eyeNumber: UIStackView!
}
