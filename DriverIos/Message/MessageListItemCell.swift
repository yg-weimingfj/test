//
//  MessageListItemCell.swift
//  DriverIos
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class MessageListItemCell: UITableViewCell {

    
    @IBOutlet weak var viewNormalMsg: UIView!//资讯消息
    @IBOutlet weak var viewSystemMsg: UIView!//系统消息
    //资讯消息
    @IBOutlet weak var ivMsgPic: UIImageView!//消息图片
    @IBOutlet weak var labelMsgTitle: UILabel!//消息标题
    @IBOutlet weak var labelMsgCon: UILabel!//消息内容
    @IBOutlet weak var labelMsgDate: UILabel!//消息时间
    //系统消息
    @IBOutlet weak var labelSysTitle: UILabel!//消息标题
    @IBOutlet weak var labelSysType: UILabel!//消息类型
    @IBOutlet weak var labelSysCon: UILabel!//消息内容
    @IBOutlet weak var labelSysDate: UILabel!//消息时间
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initData()
    }
    /**
     * 初始化
     */
    func initData() {
        labelSysType.layer.borderWidth = 1;
        labelSysType.layer.cornerRadius = 4;
        labelSysType.layer.masksToBounds = true;
        labelSysType.textColor = UIColor.rgb(red: 254, green: 69, blue: 81)
        labelSysType.layer.borderColor = UIColor.rgb(red: 254, green: 69, blue: 81).cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
