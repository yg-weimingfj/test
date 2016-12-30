//
//  UsedLineItemCell.swift
//  DriverIos
//
//  Created by mac on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class UsedLineItemCell: UITableViewCell {

    @IBOutlet weak var labelDepa: UILabel!
    @IBOutlet weak var labelDest: UILabel!
    @IBOutlet weak var labelMile: UILabel!
    @IBOutlet weak var labelDepaDetail: UILabel!
    @IBOutlet weak var labelDestDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
