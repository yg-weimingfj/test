//
//  EmptyCarCell.swift
//  DriverIos
//
//  Created by my on 2016/12/22.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarCell: UITableViewCell {

    @IBOutlet weak var destAreaLabel: UILabel!
    @IBOutlet weak var sourceAreaLabel: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
