//
//  LoginViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/1.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit
import AdSupport
@IBDesignable
class LoginViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet var loginTabButton: UISegmentedControl!
    @IBOutlet var VerificationCodePhoneView: UIView!
    @IBOutlet var VerificationCodePhoneTextField: UITextField!

    @IBOutlet var VerificationCodePhoneButton: UIButton!
    @IBOutlet var passwordPhoneView: UIView!
    @IBOutlet var passwordPhoneTextField: UITextField!
    @IBOutlet var passwordTexField: UITextField!
    
    @IBOutlet var voiceView: UIView!
    var countdownTimer: Timer!
    @IBOutlet var voiceLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!//错误提示label
    
    @IBOutlet var toForgetPassword: UILabel!
    
    @IBOutlet var toRegister: UILabel!
    
    @IBOutlet var loginCell: UILabel!
    @IBOutlet var loginButton: UIButton!
    private let  defaulthttp = DefaultHttp()
    private let appsecret = "weimingfj_ios_app_secret"
    private var loginType = "verfy"//登录模式，默认验证码登录
    
    @IBOutlet var buttonToText: NSLayoutConstraint!
    @IBOutlet var loginTopLogoHeight: NSLayoutConstraint!
    @IBOutlet var passwordTextView: UIView!
    private var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(updateTime(timer:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 10
                VerificationCodePhoneButton.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                VerificationCodePhoneButton.backgroundColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1)
            }
            
            VerificationCodePhoneButton.isEnabled = !newValue
        }
    }
    var remainingSeconds: Int = 0  {
        willSet {
            VerificationCodePhoneButton.setTitle("\(newValue)秒后重新获取", for: .normal)
            
            if newValue <= 0 {
                VerificationCodePhoneButton.setTitle("重新获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    var buttonNum: Int = 0 {
        willSet{
            if newValue > 2 && errorLabel.isHidden
            {
                self.voiceView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTabButton.layer.masksToBounds = true
        loginTabButton.layer.cornerRadius = 20
        
        loginTabButton.layer.borderWidth = 1
        loginTabButton.widthForSegment(at: 0)
        loginTabButton.layer.borderColor = loginTabButton.tintColor.cgColor
        
        
        VerificationCodePhoneButton.layer.cornerRadius  = 5
        loginButton.layer.cornerRadius = 5
        
        let toVoice = UITapGestureRecognizer(target: self, action: #selector(openVoice))
        voiceLabel.addGestureRecognizer(toVoice)
        voiceLabel.isUserInteractionEnabled = true
        
        let toForgetPasswordUI = UITapGestureRecognizer(target: self, action: #selector(toForgetPasswordSelector))
        toForgetPassword.addGestureRecognizer(toForgetPasswordUI)
        toForgetPassword.isUserInteractionEnabled = true
        
        let toRegisterUI = UITapGestureRecognizer(target: self, action: #selector(toRegisterSelector))
        toRegister.addGestureRecognizer(toRegisterUI)
        toRegister.isUserInteractionEnabled = true
        
        let loginCellUI = UITapGestureRecognizer(target: self, action: #selector(cellPhone))
        loginCell.addGestureRecognizer(loginCellUI)
        loginCell.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let loginHeight = self.view.frame.size.height
        if loginHeight<570 {
            loginTopLogoHeight.constant = loginHeight/3
            buttonToText.constant = buttonToText.constant/2
        }
    }
    func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

    @IBAction func VerificationCodePhoneButton(_ sender: UIButton) {
        let phone = VerificationCodePhoneTextField.text!
        if(phone.isEmpty){
            self.tishi(st: "请输入手机号")
        }else{
            isCounting = true
            buttonNum+=1
            sendVerfy()
        }
        
    }
    @IBAction func loginTabButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loginType = "verfy"
            VerificationCodePhoneView.isHidden = false
            passwordPhoneView.isHidden = true
            passwordTexField.placeholder = "请输入验证码"
            passwordTexField.text = ""
        case 1:
            loginType = "password"
            VerificationCodePhoneView.isHidden = true
            passwordPhoneView.isHidden = false
            passwordTexField.placeholder = "请输入密码"
            voiceView.isHidden = true
            passwordTexField.text = ""
        default:
            break
        }
    }
    @IBAction func loginButton(_ sender: UIButton) {
        if(loginType == "password"){
            let passd5 = passEncryption(passtext: passwordTexField.text!, appEncryotion: appsecret)
            let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            
            let des : Dictionary<String,Any> = ["token":"","mobile_no":passwordPhoneTextField.text!,"user_pwd":passd5,"method":"yunba.carrier.v1.user.login","device_mark":uuid,"time":strNowTime]
            
            defaulthttp.httpPost(parame: des){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        
                        let homePath = results["resultObj"] as! Dictionary<String,Any>
                        
                        
                        let stu = Student()
                        stu.name = homePath["carrier_name"] as! String?
                        stu.userId = homePath["user_id"] as! String?
                        stu.token = homePath["token"] as! String?
                        stu.carrierAvatar = homePath["carrier_avatar"] as! String?
                        stu.carrierPhone = homePath["carrier_phone"] as! String?
                        stu.carrierStatus = homePath["carrier_status"] as! String?
                        stu.deviceMark = homePath["device_mark"] as! String?
                        stu.isPrivate = homePath["is_private"] as! String?
                        stu.userCode = homePath["user_code"] as! String?
                        $.saveObj("driverUserInfo", value: stu)

                        let sb = UIStoryboard(name: "HomePage", bundle:nil)
                        let vc = sb.instantiateViewController(withIdentifier: "homePageController") as! HomePageController
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.tishi(st: info)
                    }
                }
                print("JSON: \(results)")
                
            }
        }else{
            let verfy = passwordTexField.text!
            let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            
            let des : Dictionary<String,Any> = ["token":"","tel":VerificationCodePhoneTextField.text!,"code":verfy,"method":"yunba.carrier.v1.user.codelogin","device_mark":uuid,"time":strNowTime]
            
            defaulthttp.httpPost(parame: des){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        
                        let homePath = results["resultObj"] as! Dictionary<String,Any>
                        let stu = Student()
                        stu.name = homePath["carrier_name"] as! String?
                        stu.userId = homePath["user_id"] as! String?
                        stu.token = homePath["token"] as! String?
                        stu.carrierAvatar = homePath["carrier_avatar"] as! String?
                        stu.carrierPhone = homePath["carrier_phone"] as! String?
                        stu.carrierStatus = homePath["carrier_status"] as! String?
                        stu.deviceMark = homePath["device_mark"] as! String?
                        stu.isPrivate = homePath["is_private"] as! String?
                        stu.userCode = homePath["user_code"] as! String?
                        $.saveObj("driverUserInfo", value: stu)
                        
                        let sb = UIStoryboard(name: "HomePage", bundle:nil)
                        let vc = sb.instantiateViewController(withIdentifier: "homePageController") as! HomePageController
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.tishi(st: info)
                    }
                }
                print("JSON: \(results)")
                
            }
        }

//        errorLabel.text = "验证码错误，请重新输入"
//        errorLabel.isHidden = false
//        voiceView.isHidden = true
        
    }
    /**
     * 发送短信验证码
     */
    func sendVerfy() {
        
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            
            let params : Dictionary<String,Any> = ["token":"","method":"yunba.carrier.v1.smscode.send","time":strNowTime,"mobile_no":VerificationCodePhoneTextField.text!,"voice":""]
            
            defaulthttp.httpPost(parame: params){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        self.tishi(st: "验证码发送成功")
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.tishi(st: info)
                    }
                }
                print("JSON: \(results)")
                
            }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        
        return true
    }
    func keyBoardWillShow(_ notification: Notification){
        let he = self.view.frame.size.height - passwordTextView.frame.origin.y - passwordTextView.frame.size.height-10
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        let changeY = kbRect.origin.y - SCREEN_HEIGHT
//        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //界面偏移动画
        if -changeY > he{
            UIView.animate(withDuration: duration) {
                
                self.view.frame.origin.y = changeY + he
            }
        }else{
            self.view.frame.origin.y = 0
        }
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo
//        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
             self.view.frame.origin.y = 0
        }
    }
    func openVoice(){
        print("打开语音")
    }
    func toForgetPasswordSelector() {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "forgetPasswordViewController") as! ForgetPasswordViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    func toRegisterSelector() {
//                let sb = UIStoryboard(name: "Main", bundle:nil)
//                let vc = sb.instantiateViewController(withIdentifier: "registerViewController") as! RegisterViewController
//                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//                self.present(vc, animated: true, completion: nil)
        self.performSegue(withIdentifier: "registerViewController", sender: self)
    }
    func cellPhone() {
            let phone = "4008856913"
            let alertController = UIAlertController(title: phone,
                                                    message: nil, preferredStyle: .alert)
            let alertCancelAction = UIAlertAction(title:"取消",style: .cancel,handler: nil)
            let alertActionOK = UIAlertAction(title: "拨打", style: .default, handler: {
                action in
                if #available(iOS 10, *) {
                    print("跳转电话界面")
                    UIApplication.shared.open(URL(string: "tel://"+phone)!, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(URL(string: "tel://"+phone)!)
                }
            })
            alertController.addAction(alertCancelAction)
            alertController.addAction(alertActionOK)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
        
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
    
    func tishi(st:String){
        let alertController = UIAlertController(title: st,
                                                message: nil, preferredStyle: .alert)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
