//
//  WaybillCellVIew.swift
//  DriverIos
//
//  Created by weiming on 2016/12/14.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit
class WaybillCellVIew: UIView {
    @IBOutlet var CellTopView: UIView!
    var ratingLabel:UILabel?
    
    var ratingValue:Float = 0

    @IBOutlet var ratingBar: RatingBar!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
      
    }

}
