//
//  EmptyCarUpload.swift
//  DriverIos
//
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarUpload: UITableViewCell {

    @IBOutlet weak var uploadButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uploadButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
