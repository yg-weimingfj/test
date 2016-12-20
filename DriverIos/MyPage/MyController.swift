//
//  MyController.swift
//  DriverIos
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class MyController: UIViewController{
    
    @IBOutlet weak var viewScan: UIView!//扫一扫
    @IBOutlet weak var viewQRCode: UIView!//二维码
    @IBOutlet weak var viewEditWiFi: UIView!//修改WiFi设置
    @IBOutlet weak var viewEditFlow: UIView!//修改流量设置
    @IBOutlet weak var myAccount: UIView!//我的记账
    @IBOutlet weak var messageList: UIView!//消息列表
    @IBOutlet weak var suggess: UIView!//意见反馈
    @IBOutlet weak var setting: UIView!//设置
    @IBOutlet weak var help: UIView!//帮助
    @IBOutlet weak var share: UIView!//邀请好友
    @IBOutlet weak var ivHeadImg: UIImageView!//头像
    @IBOutlet weak var ivIdentify: UIImageView!//认证图标
    @IBOutlet weak var labelUserName: UILabel!//姓名
    @IBOutlet weak var labelIdentify: UILabel!//认证
    @IBOutlet weak var labelIssusd: UILabel!//发货次数
    @IBOutlet weak var labelOrderCount: UILabel!//完成运单数
    @IBOutlet weak var rbStar: RatingBar!//评分星级
    @IBOutlet weak var flowProgress: UIProgressView!//流量
    @IBOutlet weak var myScrollView: UIScrollView!//滚动布局
    

    let  defaulthttp = DefaultHttp()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        register()
        // Do any additional setup after loading the view.
    }

    /**
       * 加载数据
      */
    func register() {
        
        let viewEditWiFiUI = UITapGestureRecognizer(target: self, action: #selector(setWiFi))
        viewEditWiFi.addGestureRecognizer(viewEditWiFiUI)
        viewEditWiFi.isUserInteractionEnabled = true
        
        let myAccountUI = UITapGestureRecognizer(target: self, action: #selector(myAccountLinener))
        myAccount.addGestureRecognizer(myAccountUI)
        myAccount.isUserInteractionEnabled = true
        
        let messageListUI = UITapGestureRecognizer(target: self, action: #selector(messageListLinener))
        messageList.addGestureRecognizer(messageListUI)
        messageList.isUserInteractionEnabled = true
        
        let shareUI = UITapGestureRecognizer(target: self, action: #selector(shareLinener))
        share.addGestureRecognizer(shareUI)
        share.isUserInteractionEnabled = true
        
        let suggessUI = UITapGestureRecognizer(target: self, action: #selector(suggessLinener))
        suggess.addGestureRecognizer(suggessUI)
        suggess.isUserInteractionEnabled = true
        
        let settingUI = UITapGestureRecognizer(target: self, action: #selector(settingLinener))
        setting.addGestureRecognizer(settingUI)
        setting.isUserInteractionEnabled = true
        
        let helpUI = UITapGestureRecognizer(target: self, action: #selector(helpLinener))
        help.addGestureRecognizer(helpUI)
        help.isUserInteractionEnabled = true

        flowProgress.progress = 0.2
        flowProgress.transform = CGAffineTransform(scaleX: 1.0, y: 3.0)//改变进度条高度
        
        driverInfo()
    }
    /**
     * 获取司机个人信息
     */
    func driverInfo() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":"","method":"yunba.carrier.v1.user.get","time":strNowTime]
        
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
    /**
     * 设置WiFi
     */
    func setWiFi() {
        let sb = UIStoryboard(name: "SetWiFi", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "setWiFiController") as! SetWiFiController
        self.present(vc, animated: true, completion: nil)
    }

    /**
     * 我的记账
     */
    func myAccountLinener() {
        let sb = UIStoryboard(name: "OrderAccount", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "orderAccountController") as! OrderAccountController
        self.present(vc, animated: true, completion: nil)
    }
    /**
     * 消息列表点击
     */
    func messageListLinener() {
        print("11111")
    }
    /**
     * 邀请好友点击
     */
    func shareLinener() {
        print("22222")
    }
    /**
     * 意见反馈点击
     */
    func suggessLinener() {
        print("33333")
    }
    /**
     * 设置点击
     */
    func settingLinener() {
        print("44444")
    }
    /**
     * 帮助点击
     */
    func helpLinener() {
        print("55555")
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
