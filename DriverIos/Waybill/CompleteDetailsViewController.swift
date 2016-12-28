//
//  CompleteDetailsViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class CompleteDetailsViewController: UIViewController {
    var orderId:String = ""
    @IBOutlet var ratingHeight: NSLayoutConstraint!
    @IBOutlet var buttonHeight: NSLayoutConstraint!
    @IBOutlet var buttonTopSpacing: NSLayoutConstraint!
    @IBOutlet var buttonBottomSpacing: NSLayoutConstraint!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var ratingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if orderId == "111"{
            completeButton.isHidden = true
            buttonHeight.constant = 0
            buttonTopSpacing.constant = 0
            buttonBottomSpacing.constant = 0
        }else{
            ratingView.isHidden = true
            ratingHeight.constant = 0
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
