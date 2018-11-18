//
//  TitleTableViewCell.swift
//  PayloadDemo
//
//  Created by Parveen Khatkar on 17/11/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit
import Payload

class TitleTableViewCell: UITableViewCell, Consignee {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(_ model: Title) {
        titleLabel.text = model.title;
    }
    
}

protocol Title {
    var title: String? {get}
}
