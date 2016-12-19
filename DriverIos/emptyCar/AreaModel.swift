//
//  AreaModel.swift
//  DriverIos
//
//  Created by my on 2016/12/16.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class AreaModel: NSObject {
    
    var areaCode : String = ""
    var parentCode : String = ""
    var text : String = ""
    var pinYin : String = ""
    var remark : String = ""
    var simpleText : String = ""
    var province : String = ""
    var simpleCity : String = ""
    var areaCodeLevel : String = ""
    var isDirectlyUnder : String = ""
    var fullText : String = ""
    var cityText : String = ""
    var lon : String = ""
    var lat : String = ""
    
    init(code : String, parentCode : String,text : String,pinYin : String,remark : String,simpleText : String,province : String,simpleCity : String,areaLevel : String,isDirectlyUnder : String,fullText : String,cityText : String,lon : String,lat : String) {
        self.areaCode = code
        self.parentCode = parentCode
        self.text = text
        self.pinYin = pinYin
        self.remark = remark
        self.simpleText = simpleText
        self.province = province
        self.simpleCity = simpleCity
        self.areaCodeLevel = areaLevel
        self.isDirectlyUnder = isDirectlyUnder
        self.fullText =  fullText
        self.cityText = cityText
        self.lon = lon
        self.lat = lat
    }
    override init() {
        super.init()
    }
}
