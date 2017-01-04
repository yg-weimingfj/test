//
//  SettingController.swift
//  DriverIos
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class SettingController: UIViewController {

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var viewVersion: UIView!
    @IBOutlet weak var viewEditPwd: UIView!
    @IBOutlet weak var viewExit: UIView!
    @IBOutlet weak var labelVersion: UILabel!
    
    private let  defaulthttp = DefaultHttp()
    private var token = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    /**
     * 初始化
     */
    func initData() {
        labelVersion.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let versionUI = UITapGestureRecognizer(target: self, action: #selector(versionLinener))
        viewVersion.addGestureRecognizer(versionUI)
        viewVersion.isUserInteractionEnabled = true
        
        let editPwdUI = UITapGestureRecognizer(target: self, action: #selector(editPwdLinener))
        viewEditPwd.addGestureRecognizer(editPwdUI)
        viewEditPwd.isUserInteractionEnabled = true
        
        let exitUI = UITapGestureRecognizer(target: self, action: #selector(exitLinener))
        viewExit.addGestureRecognizer(exitUI)
        viewExit.isUserInteractionEnabled = true
        
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.token = obj.token!
            }
        }
    }

    /**
     * 版本信息点击
     */
    func versionLinener() {
        //        let date = Date()
        //        let timeFormatter = DateFormatter()
        //        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        //        let strNowTime = timeFormatter.string(from: date) as String
        //
        //        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.routes.list.get","time":strNowTime]
        //
        //        defaulthttp.httopost(parame: params){results in
        //            print("JSON: \(results)")
        //            if let result:String = results["result"] as! String?{
        //                if result == "1"{
        //
        //                }else{
        //                    let info:String = results["resultInfo"] as! String!
        //                    self.hint(hintCon: info)
        //                }
        //            }
        //        }
        
    }
    /**
     * 修改密码点击
     */
    func editPwdLinener() {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "forgetPasswordViewController") as! ForgetPasswordViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    /**
     * 退出点击
     */
    func exitLinener() {
        //清空用户信息
        let stu = Student()
        $.saveObj("driverUserInfo", value: stu)
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(vc, animated: true, completion: nil)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
