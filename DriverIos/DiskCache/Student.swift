//
//  Student.swift
//  ZZDiskCache
//
//  Created by duzhe on 16/3/3.
//  Copyright © 2016年 dz. All rights reserved.
//

import Foundation

class Student: NSObject,NSCoding {
    
    var userId:String?//用户唯一标识
    var name:String?//用户姓名
    var token:String?//会话串
    var userCode:String?//用户账户
    var carrierPhone:String?//联系电话
    var carrierAvatar:String?//头像图片地址
    var deviceMark:String?//最后登陆的机器识别码
    var carrierStatus:String?//用户认证状态
    var isPrivate:String?//是否内部人员
    
    override init() {
        
    }
    
    //MARK: -序列化
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.userId, forKey: "useridid")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.userCode, forKey: "userCode")
        aCoder.encode(self.carrierPhone, forKey: "carrierPhone")
        aCoder.encode(self.carrierAvatar, forKey: "carrierAvatar")
        aCoder.encode(self.deviceMark, forKey: "deviceMark")
        aCoder.encode(self.carrierStatus, forKey: "carrierStatus")
        aCoder.encode(self.isPrivate, forKey: "isPrivate")
    }
    
    
    //MARK: -反序列化
    required init?(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeObject(forKey: "id") as? String
        self.name = aDecoder.decodeObject(forKey: "useridname") as? String
        self.token = aDecoder.decodeObject(forKey: "token") as? String
        self.userCode = aDecoder.decodeObject(forKey: "userCode") as? String
        self.carrierPhone = aDecoder.decodeObject(forKey: "carrierPhone") as? String
        self.carrierAvatar = aDecoder.decodeObject(forKey: "carrierAvatar") as? String
        self.deviceMark = aDecoder.decodeObject(forKey: "deviceMark") as? String
        self.carrierStatus = aDecoder.decodeObject(forKey: "carrierStatus") as? String
        self.isPrivate = aDecoder.decodeObject(forKey: "isPrivate") as? String
    }
}
