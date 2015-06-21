//
//  ArticleTitleCell.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/17/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class ArticleTitleCell: UITableViewCell {
    
    @IBOutlet weak var avartar: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
