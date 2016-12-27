//
//  WaybillCellVIew.swift
//  DriverIos
//
//  Created by weiming on 2016/12/14.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit
class WaybillCell:UITableViewCell {
    @IBOutlet weak var WaybillTime: UILabel!
    
    @IBOutlet weak var WaybillRatingBar: RatingBar!
    @IBOutlet weak var WayBillPlaceOfDeparture: UILabel!
    @IBOutlet weak var WaybillDestination: UILabel!
    @IBOutlet weak var WayBillDistance: UILabel!
    @IBOutlet weak var WaybillGoodsType: UILabel!
    @IBOutlet weak var WaybillCarType: UILabel!
    @IBOutlet weak var WaybillBottomView: UIView!
    @IBOutlet weak var RatingBarLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
