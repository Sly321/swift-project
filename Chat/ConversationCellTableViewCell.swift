//
//  ConversationCellTableViewCell.swift
//  Chat
//
//  Created by zerg on 22.06.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import UIKit

class ConversationCellTableViewCell: UITableViewCell {

    @IBOutlet var message: UILabel!
    @IBOutlet var datum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        message.numberOfLines = 0
        // Configure the view for the selected state
    }

}
