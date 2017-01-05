//
//  FindCargoCell.swift
//  DriverIos
//
//  Created by my on 2016/12/21.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class FindCargoCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var readImageView: UIImageView!

    @IBOutlet weak var userLogoImage: UIImageView!
    
    @IBOutlet weak var sourceAreaLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var destAreaLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var carTypeLabel: UILabel!
    
    @IBOutlet weak var phoneImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userLogoImage.layer.cornerRadius = 36
        userLogoImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showUserInfo(){
        print(12)
    }
}
