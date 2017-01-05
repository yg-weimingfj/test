//
//  AdvertisementViewController.swift
//  DriverIos
//
//  Created by my on 2017/1/5.
//  Copyright © 2017年 weiming. All rights reserved.
//

import UIKit
import WebKit

class AdvertisementViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString : String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = NSURL(string:urlString) {
            
            let request = NSURLRequest(url: url as URL)
            
            webView.loadRequest(request as URLRequest)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
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
