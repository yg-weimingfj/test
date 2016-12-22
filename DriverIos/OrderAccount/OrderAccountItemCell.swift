//
//  OrderAccountItemCell.swift
//  DriverIos
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class OrderAccountItemCell: UITableViewCell {

    @IBOutlet weak var labelOrderNo: UILabel!//运单编号
    @IBOutlet weak var labelFinishDate: UILabel!//完成时间
    @IBOutlet weak var labelDepa: UILabel!//出发地
    @IBOutlet weak var labelDest: UILabel!//目的地
    @IBOutlet weak var labelMile: UILabel!//公里数
    @IBOutlet weak var viewMoney: UIView!//收入支出
    @IBOutlet weak var viewAccount: UIView!//记一记
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
