//
//  FriendTableCell.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 06/10/2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit
import Alamofire

class FriendTableCell: UITableViewCell {

    @IBOutlet private weak var photoImageView: UIImageView! {
        didSet {
            self.photoImageView.layer.borderColor = UIColor(displayP3Red: 222/255, green: 71/255, blue: 227/255, alpha: 1.0).cgColor
            self.photoImageView.layer.borderWidth = 1
        }
    }

    @IBOutlet private weak var nameLabel: UILabel!
    
    var photoImage: UIImage? {
        didSet {
            self.photoImageView.image = photoImage
        }
    }
    
    var name: String = "" {
        didSet{
            nameLabel.text = name
        }
    }
    
    
    func configure(name: String, photoImage: UIImage){
        self.name = name
        self.photoImage = photoImage
        self.backgroundColor = UIColor.blue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
        self.nameLabel.text = nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.photoImageView.clipsToBounds = true
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.width / 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
