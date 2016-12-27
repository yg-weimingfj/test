//
//  RechargeFlowController.swift
//  DriverIos
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class RechargeFlowController: UIViewController {

    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func rechargeLisener(_ sender: UIButton) {
        rechargeFlow()
    }
    @IBOutlet weak var labelPackage: UILabel!//选择套餐标题
    @IBOutlet weak var labelPayType: UILabel!//支付方式标题
    @IBOutlet weak var labelPackage1: UILabel!//流量套餐--1G
    @IBOutlet weak var labelPackage2: UILabel!//流量套餐--5G
    @IBOutlet weak var labelPackage3: UILabel!//流量套餐--10G
    @IBOutlet weak var labelPackage4: UILabel!//流量套餐--包年
    @IBOutlet weak var labelBalance: UILabel!//钱包余额
    @IBOutlet weak var viewBalance: UIView!//钱包余额
    @IBOutlet weak var viewWeiXinBalance: UIView!//微信钱包
    @IBOutlet weak var viewAliPay: UIView!//支付宝
    @IBOutlet weak var ivBalance: UIImageView!//钱包余额
    @IBOutlet weak var ivWeiXinBalance: UIImageView!//微信钱包
    @IBOutlet weak var ivAliPay: UIImageView!//支付宝
    @IBOutlet weak var btnRecharge: UIButton!
    
    private var labelsPackage :[UILabel] = [UILabel]()
    private var imagesPay :[UIImageView] = [UIImageView]()
    private var token = ""
    private var rechargeType = "WALLET"//充值方式，默认钱包
    private var rechargeAmount = 10//充值金额，默认10元
    private let defaulthttp = DefaultHttp()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     * 初始化
     */
    func initData() {
        labelPackage.layer.cornerRadius = 3
        labelPayType.layer.cornerRadius = 3
        btnRecharge.layer.cornerRadius = 6
        labelsPackage.append(labelPackage1)
        labelsPackage.append(labelPackage2)
        labelsPackage.append(labelPackage3)
        labelsPackage.append(labelPackage4)
        selectPackage(selectPosition :0)

        let viewPackage1 = UITapGestureRecognizer(target: self, action: #selector(labelPackage1Lisener))
        labelPackage1.addGestureRecognizer(viewPackage1)
        labelPackage1.isUserInteractionEnabled = true
        
        let viewPackage2 = UITapGestureRecognizer(target: self, action: #selector(labelPackage2Lisener))
        labelPackage2.addGestureRecognizer(viewPackage2)
        labelPackage2.isUserInteractionEnabled = true
        
        let viewPackage3 = UITapGestureRecognizer(target: self, action: #selector(labelPackage3Lisener))
        labelPackage3.addGestureRecognizer(viewPackage3)
        labelPackage3.isUserInteractionEnabled = true
        
        let viewPackage4 = UITapGestureRecognizer(target: self, action: #selector(labelPackage4Lisener))
        labelPackage4.addGestureRecognizer(viewPackage4)
        labelPackage4.isUserInteractionEnabled = true
        
        imagesPay.append(ivBalance)
        imagesPay.append(ivWeiXinBalance)
        imagesPay.append(ivAliPay)
        selectPay(selectPosition: 0)
        
        let viewBalanceUI = UITapGestureRecognizer(target: self, action: #selector(banalceLisener))
        viewBalance.addGestureRecognizer(viewBalanceUI)
        viewBalance.isUserInteractionEnabled = true
        
        let viewWeiXinBalanceUI = UITapGestureRecognizer(target: self, action: #selector(weiXinBalanceLisener))
        viewWeiXinBalance.addGestureRecognizer(viewWeiXinBalanceUI)
        viewWeiXinBalance.isUserInteractionEnabled = true
        
        let viewAliPayUI = UITapGestureRecognizer(target: self, action: #selector(aliPayLisener))
        viewAliPay.addGestureRecognizer(viewAliPayUI)
        viewAliPay.isUserInteractionEnabled = true

        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.token = obj.token!
            }
        }
    }
    /**
     * 选中套餐1
     */
    func labelPackage1Lisener()  {
        rechargeAmount = 10
        selectPackage(selectPosition: 0)
    }
    /**
     * 选中套餐2
     */
    func labelPackage2Lisener()  {
        rechargeAmount = 40
        selectPackage(selectPosition: 1)
    }
    /**
     * 选中套餐3
     */
    func labelPackage3Lisener()  {
        rechargeAmount = 70
        selectPackage(selectPosition: 2)
    }
    /**
     * 选中套餐4
     */
    func labelPackage4Lisener()  {
        rechargeAmount = 1000
        selectPackage(selectPosition: 3)
    }
    /**
     * 选中的套餐
     */
    func selectPackage(selectPosition : Int) {
        for i in 0..<labelsPackage.count {
            let label = labelsPackage[i]
            label.layer.borderWidth = 1;
            label.layer.masksToBounds = true;
            if(i == selectPosition){
                label.textColor = UIColor.rgb(red: 51, green: 145, blue: 252)
                label.layer.borderColor = UIColor.rgb(red: 51, green: 145, blue: 252).cgColor
            }else{
                label.textColor = UIColor.rgb(red: 51 , green: 51, blue: 51)
                label.layer.borderColor = UIColor.rgb(red: 102 , green: 102, blue: 102).cgColor
            }
        }
    }
    /**
     * 选中的支付方式--余额支付
     */
    func banalceLisener()  {
        rechargeType = "WALLET"
        selectPay(selectPosition: 0)
    }
    /**
     * 选中的支付方式--微信支付
     */
    func weiXinBalanceLisener()  {
        rechargeType = "WX"
        selectPay(selectPosition: 1)
    }
    /**
     * 选中的支付方式--支付宝支付
     */
    func aliPayLisener()  {
        rechargeType = "ALI"
        selectPay(selectPosition: 2)
    }
    /**
     * 选中的支付方式
     */
    func selectPay(selectPosition : Int) {
        for i in 0..<imagesPay.count {
            let imageView = imagesPay[i]
            if(i == selectPosition){
                imageView.image = UIImage(named: "circle_selected")
            }else{
                imageView.image = UIImage(named: "circle_default")
            }
        }
    }
    /**
     * 魔盒流量充值
     */
    func rechargeFlow() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.line.magicbox.flow.recharge.preorder","time":strNowTime,"pay_method":rechargeType,"pay_amount":rechargeAmount]
        
        defaulthttp.httopost(parame: params){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.hint(hintCon: "充值成功")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
