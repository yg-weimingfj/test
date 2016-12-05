//
//  RegisterViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/2.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    var type:String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print("注册界面的==\(type)")

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
