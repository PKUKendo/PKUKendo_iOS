//
//  ArticleCell.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/17/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var commentNumField: UITextField!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
