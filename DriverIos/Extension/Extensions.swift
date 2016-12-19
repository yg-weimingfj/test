//
//  UnitFile.swift
//  MYYouTuBe
//
//  Created by mac on 2016/12/9.
//  Copyright © 2016年 wcb. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red: CGFloat,green: CGFloat,blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView{
    func addconstraintsWithVisualFormat(_ format: String,views: UIView...) {
        var viewsDict = [String: UIView]()
        for (index,view) in views.enumerated() {
            viewsDict["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}
