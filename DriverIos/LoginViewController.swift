//
//  LoginViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/1.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit
@IBDesignable
class LoginViewController: UIViewController {
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
    
    var isCounting = false {
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
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

    @IBAction func VerificationCodePhoneButton(_ sender: UIButton) {
        isCounting = true
        buttonNum+=1
    }
    @IBAction func loginTabButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            VerificationCodePhoneView.isHidden = false
            passwordPhoneView.isHidden = true
            passwordTexField.placeholder = "请输入验证码"
            passwordTexField.text = ""
        case 1:
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
        errorLabel.text = "验证码错误，请重新输入"
        errorLabel.isHidden = false
        voiceView.isHidden = true
        
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
        if #available(iOS 10, *) {
            print("跳转电话界面")
            UIApplication.shared.open(URL(string: "tel://4008856913")!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(URL(string: "tel://4008856913")!)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("id===\(segue.identifier)")
        let des = segue.destination as! RegisterViewController
        des.type = "13131313"
        
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