//
//  EditEmptyCarCell.swift
//  DriverIos
//  空车上报列表可编辑cell
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EditEmptyCarCell: UITableViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var sourceAreaLabel: UILabel!
    @IBOutlet weak var fromImageView: UIImageView!
    @IBOutlet weak var destAreaLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
