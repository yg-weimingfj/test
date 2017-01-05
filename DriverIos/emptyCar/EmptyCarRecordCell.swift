//
//  EmptyCarRecordCell.swift
//  DriverIos
//  空车匹配列表 -- 空车记录cell
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarRecordCell: UITableViewCell {
    
    @IBOutlet weak var sourceAreaLabel: UILabel!
    @IBOutlet weak var destAreaLabel: UILabel!
    @IBOutlet weak var fromImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
