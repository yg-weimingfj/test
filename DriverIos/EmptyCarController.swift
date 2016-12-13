//
//  EmptyCarController.swift
//  DriverIos
//
//  Created by my on 2016/12/7.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarController: UIViewController {

    @IBOutlet weak var emptyCarButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emptyCarButton.layer.masksToBounds = true
        emptyCarButton.layer.cornerRadius = 10

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    

    @IBAction func emptyCarBack(_ sender: Any) {
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
