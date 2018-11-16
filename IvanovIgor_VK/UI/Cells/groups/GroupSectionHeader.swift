//
//  SectionHeader.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 06/10/2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

class GroupSectionHeader: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    
    var count: String? {
        didSet{
            countLabel.text = count
        }
    }
}
