//
//  ForgetPasswordViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/2.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var textTel: UITextField!//电话
    @IBOutlet weak var textVerfy: UITextField!//验证码
    @IBOutlet weak var textNewPwd: UITextField!//新密码
    @IBOutlet weak var textNewPwdSure: UITextField!//确认新密码
    @IBOutlet weak var btnGetVerfy: UIButton!//获取验证码
    @IBAction func btnGetVerfyLisener(_ sender: UIButton) {
        sendVerfy()
    }
    @IBAction func btnSure(_ sender: UIButton) {
        editPassword()
    }
    
    private let defaulthttp = DefaultHttp()
    private let appsecret = "weimingfj_ios_app_secret"
    private var countdownTimer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     * 修改密码
     */
    func editPassword() {
        let phone = textTel.text!
        let verfy = textVerfy.text!
        let newPwd = textNewPwd.text!
        let newPwdSure = textNewPwdSure.text!
        if(phone.isEmpty){
            self.hint(hintCon: "请输入手机号")
        }else if(verfy.isEmpty){
            self.hint(hintCon: "请输入验证码")
        }else if(newPwd.isEmpty){
            self.hint(hintCon: "请输入密码")
        }else if(newPwdSure.isEmpty){
            self.hint(hintCon: "请再次输入密码")
        }else if(newPwd != newPwdSure){
            self.hint(hintCon: "两次密码输入不一致，请重新输入")
        }else{
            let password = passEncryption(passtext: newPwd, appEncryotion: appsecret)
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            let des : Dictionary<String,Any> = ["token":"","method":"yunba.carrier.v1.user.password.reset","time":strNowTime,"mobile_no":phone,"user_pwd":password,"sms_verify_code":verfy]
            
            defaulthttp.httopost(parame: des){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        self.backUI()
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.hint(hintCon: info)
                    }
                }
                print("JSON: \(results)")
            }
        }
    }
    func backUI() {
        self.dismiss(animated: true, completion: nil)
    }
    /**
     * 发送短信验证码
     */
    func sendVerfy() {
        let phone = textTel.text!
        if(phone.isEmpty){
            self.hint(hintCon: "请输入手机号")
        }else{
            isCounting = true
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            
            let params : Dictionary<String,Any> = ["token":"","method":"yunba.carrier.v1.smscode.send","time":strNowTime,"mobile_no":phone,"voice":""]
            
            defaulthttp.httopost(parame: params){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        self.hint(hintCon: "验证码发送成功")
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.hint(hintCon: info)
                    }
                }
                print("JSON: \(results)")
                
            }
        }
        
    }
    //密码加密
    func passEncryption(passtext:String,appEncryotion:String) -> String {
        var i = 0
        var bytes: [UInt8] = [UInt8]()
        for ch in passtext.utf8 {
            bytes.append(ch.advanced(by:0))
        }
        
        var bytes2:[UInt8] = [UInt8]()
        for ch in appEncryotion.utf8 {
            bytes2.append(ch.advanced(by:0))
        }
        var bytes3:[UInt8] = [UInt8]()
        for ch in bytes{
            bytes3.append(ch^bytes2[i%bytes2.count])
            i+=1
        }
        return ioshex(types: bytes3)
    }
    func ioshex(types:[UInt8]) -> String {
        var res:[String] = [String]()
        var j = 0
        var encryptionOne:UInt8
        var encryptionTwo:UInt8
        
        let hexDigits:[String] = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
        for _ in types {
            encryptionOne = types[j]>>4&0x0f
            encryptionTwo = types[j]&0x0f
            
            res.append(hexDigits[encryptionOne.hashValue])
            res.append(hexDigits[encryptionTwo.hashValue])
            j+=1
            
        }
        var passend = ""
        for vars in res{
            passend += vars
        }
        return passend
    }
    /**
     * 错误提示
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
    func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    private var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(updateTime(timer:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
                btnGetVerfy.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                btnGetVerfy.backgroundColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1)
            }
            
            btnGetVerfy.isEnabled = !newValue
        }
    }
    
    var remainingSeconds: Int = 0  {
        willSet {
            btnGetVerfy.setTitle("\(newValue)秒后重新获取", for: .normal)
            if newValue <= 0 {
                btnGetVerfy.setTitle("重新获取验证码", for: .normal)
                isCounting = false
            }
        }
    }


}
