//
//  AddUsedLineController.swift
//  DriverIos
//
//  Created by mac on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class AddUsedLineController: UIViewController {

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addLineLisener(_ sender: UIButton) {
    }
    
    @IBOutlet weak var viewDepa: UIView!//出发地
    @IBOutlet weak var viewDest: UIView!//目的地
    @IBOutlet weak var viewAddLine: UIView!//添加返程路线
    @IBOutlet weak var labelDepa: UILabel!//出发地
    @IBOutlet weak var labelDest: UILabel!//目的地
    @IBOutlet weak var ivAddLine: UIImageView!//添加返程路线图标
    @IBOutlet weak var btnAddLine: UIButton!//添加返程路线按钮
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let sourceAreaViewUI = UITapGestureRecognizer(target: self, action: #selector(sourceAreaPickViewShow))
//        viewDepa.addGestureRecognizer(sourceAreaViewUI)
//        viewDepa.isUserInteractionEnabled = true
        
        btnAddLine.layer.cornerRadius = 6

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}
