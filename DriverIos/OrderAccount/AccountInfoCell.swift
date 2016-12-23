//
//  AccountInfoCell.swift
//  DriverIos
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class AccountInfoCell: UITableViewCell {

    @IBOutlet weak var labelDate: UILabel!//时间
    @IBOutlet weak var viewAccountInfo: UIView!//收支信息
    @IBOutlet weak var labelType: UILabel!//收支类型
    @IBOutlet weak var labelCash: UILabel!//收支金额
    @IBOutlet weak var labelCashType: UILabel!//支出类型
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initData()
    }
    /**
     * 初始化
     */
    func initData() {
        viewAccountInfo.layer.borderWidth = 1;
        viewAccountInfo.layer.masksToBounds = true;
        viewAccountInfo.layer.borderColor = UIColor.rgb(red: 200 , green: 199, blue: 204).cgColor
        
        labelCashType.layer.borderWidth = 0.5;
        labelCashType.layer.cornerRadius = 4;
        labelCashType.layer.masksToBounds = true;
        labelCashType.layer.borderColor = UIColor.rgb(red: 102, green: 102, blue: 102).cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
