//
//  BaseCollectionCell.swift
//  IvanovIgor_VK
//
//  Created by MAC on 26.09.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    static var nib : UINib {return UINib(nibName: String(describing: self), bundle: nil) }
    static var identifier : String {return String(describing: self) }
}
