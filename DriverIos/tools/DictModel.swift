//
//  DictModel.swift
//  DriverIos
//
//  Created by my on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class DictModel: NSObject {
    
    var dictId : String = ""
    var dictType : String = ""
    var dictCode : String = ""
    var dictText : String = ""
    init(dictId : String,dictType : String ,dictCode : String ,dictText : String ){
        self.dictId = dictId
        self.dictType = dictType
        self.dictCode = dictCode
        self.dictText = dictText
    }
    override init() {
        super.init()
    }
}
