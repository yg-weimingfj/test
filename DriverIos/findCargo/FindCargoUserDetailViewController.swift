//
//  FindCargoUserDetailViewController.swift
//  DriverIos
//
//  Created by my on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class FindCargoUserDetailViewController: UIViewController {

    @IBOutlet weak var creditStar: RatingBar!
    @IBOutlet weak var auditIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogo: UIImageView!
    @IBOutlet weak var auditSource: UILabel!
    @IBOutlet weak var publishCargoTimes: UILabel!
    @IBOutlet weak var finishTransportNums: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        userLogo.layer.masksToBounds = true
        userLogo.layer.cornerRadius = 36
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //发货大于一次，绑定此方法
    func cargoListPage(){
        
    }
    //完成运单大于一次，绑定此方法
    func transportListPage(){
        
    }
}
