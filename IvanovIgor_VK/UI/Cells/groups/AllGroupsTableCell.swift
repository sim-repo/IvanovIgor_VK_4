//
//  AllGroupesTableCell.swift
//  IvanovIgor_VK
//
//  Created by MAC on 25.09.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

class AllGroupsTableCell: BaseTableCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var logo50ImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
