//
//  EmptyCarTransportDetail.swift
//  DriverIos
//
//  Created by my on 2016/12/29.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarTransportDetail: UIViewController {

    @IBOutlet weak var cargoTypeLabel: UILabel!
    @IBOutlet weak var truckLengthLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cargoTypeLabel.layer.cornerRadius = 13
        cargoTypeLabel.layer.borderWidth = 1
        cargoTypeLabel.layer.borderColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 0.5).cgColor
        truckLengthLabel.layer.cornerRadius = 13
        truckLengthLabel.layer.borderWidth = 1
        truckLengthLabel.layer.borderColor = UIColor(red: 255/255, green: 192/255, blue: 0/255, alpha: 0.5).cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
