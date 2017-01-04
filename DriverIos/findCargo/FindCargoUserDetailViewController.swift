//
//  FindCargoUserDetailViewController.swift
//  DriverIos
//  找货详情页面
//  Created by my on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class FindCargoUserDetailViewController: UIViewController {
    private let  defaulthttp = DefaultHttp()
    private var token = "D681CD4B984048C6B8FE785F82FD9ADA"
    var userId : String! = ""
    @IBOutlet weak var creditStar: RatingBar!
    @IBOutlet weak var auditIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogo: UIImageView!
    @IBOutlet weak var auditSource: UILabel!
    @IBOutlet weak var publishCargoTimes: UILabel!
    @IBOutlet weak var finishTransportNums: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        userLogo.layer.masksToBounds = true
        userLogo.layer.cornerRadius = 36
        userDetail()
        // Do any additional setup after loading the view.
    }

    private func userDetail(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.user.shipper.get","time":strNowTime,"shipper_id":userId]
        defaulthttp.httopost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let list:Dictionary<String,Any> = results["resultObj"]  as! [String:Any]
                    let userLogo = list["AVATAR"] as? String
                    if(userLogo != nil && !(userLogo?.isEmpty)!){
                        let urlStr = NSURL(string: userLogo!)
                        let data = NSData(contentsOf: urlStr! as URL)
                        self.userLogo.image = UIImage(data: data! as Data)
                        //                cell.userLogoImage.layer.cornerRadius = 32
                    }
                    self.userName.text = list["SHIPPER_NAME"] as? String
                    let auditStatus = list["SHIPPER_STATUS"] as? String
                    if(auditStatus != nil && !(auditStatus?.isEmpty)! && auditStatus == "Y"){
                        self.auditIcon.image = UIImage(named: "vip")
                        self.auditSource.text = "运吧认证"
                    }
                    let starNum = list["EVALUTION"] as? Int
                    if(starNum != nil){
                        self.creditStar.rating = CGFloat(starNum!)
                    }
                    var cargoNum = String(describing: list["CARGO_NUM"] as! Int)
                    if(cargoNum == nil || cargoNum.isEmpty){
                        cargoNum = "0"
                    }
                    self.publishCargoTimes.text = "累计发布"+cargoNum+"次"
                    var orderNum = String(describing: list["ORDER_NUM"] as! Int)
                    if(orderNum == nil || orderNum.isEmpty){
                        orderNum = "0"
                    }
                    self.finishTransportNums.text = "完成"+orderNum+"个运单"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //发货大于一次，绑定此方法
    func cargoListPage(){
        
    }
    //完成运单大于一次，绑定此方法
    func transportListPage(){
        
    }
}
