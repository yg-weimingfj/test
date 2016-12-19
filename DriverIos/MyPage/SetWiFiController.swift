//
//  SetWiFiController.swift
//  DriverIos
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class SetWiFiController: UIViewController {

    
    @IBOutlet weak var textWiFiName: UITextField!
    @IBOutlet weak var textWiFiPwd: UITextField!
    @IBOutlet weak var btnSure: UIButton!
    @IBAction func btnSureLisener(_ sender: UIButton) {
        setWiFi()
    }
    
    
    let  defaulthttp = DefaultHttp()
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        // Do any additional setup after loading the view.
    }

    /**
     * 初始化
     */
    func initData() {
        btnSure.layer.cornerRadius = 6
    }
    /**
     * 设置WiFi
     */
    func setWiFi() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":"","method":"yunba.carrier.v1.line.magicbox.wifi.config","time":strNowTime,"wifi_name":textWiFiName.text!,"wifi_pass":textWiFiPwd.text!]
        
        defaulthttp.httopost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    
                    
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.hint(hintCon: info)
                }
            }
            print("JSON: \(results)")
            
        }
    }
    /**
     * 提示
     */
    func hint(hintCon: String){
        let alertController = UIAlertController(title: hintCon,message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //1秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
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
