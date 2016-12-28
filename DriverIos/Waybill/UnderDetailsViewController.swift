//
//  UnderDetailsViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class UnderDetailsViewController: UIViewController {
    var orderId:String = ""

    @IBOutlet var serviceButton: UIButton!
    @IBOutlet weak var NavigationBar: UINavigationBar!
    @IBOutlet var QRImage: UIImageView!
    @IBOutlet var QRLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceButton.layer.masksToBounds = true
        serviceButton.layer.cornerRadius = 5

        serviceButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        serviceButton.isEnabled = false
        print("orserid------\(orderId)")

        // Do any additional setup after loading the view.
        let qrImg = LBXScanWrapper.createCode128(codeString: "005103906002", size: QRImage.bounds.size, qrColor: UIColor.black, bkColor: UIColor.white)
        
        
        QRImage.image = qrImg
        QRLabel.text = "005103906002"
    }

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
