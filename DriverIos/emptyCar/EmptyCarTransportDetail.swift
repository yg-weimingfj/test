//
//  EmptyCarTransportDetail.swift
//  DriverIos
//  空车详情列表
//  Created by my on 2016/12/29.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarTransportDetail: UIViewController {

    private let  defaulthttp = DefaultHttp()
    private var token = "D681CD4B984048C6B8FE785F82FD9ADA"
    
    @IBOutlet weak var sourceAreaLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var destAreaLabel: UILabel!
    @IBOutlet weak var cargoOrderLabel: UILabel!
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var pickCargoTimeLabel: UILabel!
    @IBOutlet weak var thumsUpImage: UIImageView!
    @IBOutlet weak var truckTypeLabel: UILabel!
    @IBOutlet weak var truckLengthLabel: UILabel!
    @IBOutlet weak var cargoTypeLabel: UILabel!
    @IBOutlet weak var cargoSizeLabel: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var userLogoImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var callPhone: UIImageView!
    
    private var phoneNum : String! = ""
    private var userId : String! = ""
    
    var transportId : String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        cargoTypeLabel.layer.cornerRadius = 13
        cargoTypeLabel.layer.borderWidth = 1
        cargoTypeLabel.layer.borderColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 0.5).cgColor
        truckTypeLabel.layer.cornerRadius = 13
        truckTypeLabel.layer.borderWidth = 1
        truckTypeLabel.layer.borderColor = UIColor(red: 255/255, green: 192/255, blue: 0/255, alpha: 0.5).cgColor
        userLogoImage.layer.cornerRadius = 32
        userLogoImage.layer.masksToBounds = true
        self.transportDetail(ustoken: self.token)
    }
    
    func transportDetail(ustoken:String){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.cargo.get","time":strNowTime,"cargo_id":transportId]
        defaulthttp.httopost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let list:Dictionary<String,Any> = results["resultObj"]  as! [String:Any]
                    self.sourceAreaLabel.text = self.getAreaInfo((list["place_from_code"] as? String)!)["TEXT"] as! String?
                    self.destAreaLabel.text = self.getAreaInfo((list["place_to_code"] as? String)!)["TEXT"] as! String?
                    self.distanceLabel.text = (list["estimated_distance"] as? String)! + "公里"
                    self.cargoOrderLabel.text = list["order_no"] as? String
                    self.publishTimeLabel.text = list["post_time"] as? String
                    self.pickCargoTimeLabel.text = list["post_time"] as? String
                    var truckType = list["vehicle_type"] as? String
                    if(truckType == nil || (truckType?.isEmpty)!){
                        truckType = "不限"
                    }
                    self.truckTypeLabel.text = truckType
                    var vehicleLength = list["vehicle_length"] as? String
                    if(vehicleLength == nil || (vehicleLength?.isEmpty)!){
                        vehicleLength = ""
                    }else if(vehicleLength != "不限"){
                        vehicleLength = vehicleLength! + "米"
                    }
                    self.truckLengthLabel.text = vehicleLength
                    var cargoType = list["cargo_type"] as? String
                    if(cargoType == nil || (cargoType?.isEmpty)!){
                        cargoType = "不限"
                    }
                    self.cargoTypeLabel.text = truckType
                    var cargoSize = list["cargo_size"] as? String
                    let cargoUnit = list["cargo_unit"] as? String
                    if(cargoSize == nil || (cargoSize?.isEmpty)!){
                        cargoSize = ""
                    }else{
                        if(cargoUnit != nil && !(cargoUnit?.isEmpty)!){
                            cargoSize = cargoSize! + cargoUnit!
                        }
                    }
                    self.cargoSizeLabel.text = cargoSize
                    let userLogo = list["avatar"] as! String
                    if(userLogo != ""){
                        let urlStr = NSURL(string: userLogo)
                        let data = NSData(contentsOf: urlStr! as URL)
                        self.userLogoImage.image = UIImage(data: data! as Data)
                    }
                    self.userNameLabel.text = list["receiver_name"] as? String
                    
                    let userLogoAction = UITapGestureRecognizer(target:self,action:#selector(self.userMsgDetail(recognizer :)))
                    self.userLogoImage.addGestureRecognizer(userLogoAction)
                    self.userLogoImage.isUserInteractionEnabled = true
                    
                    let phoneAction = UITapGestureRecognizer(target:self,action:#selector(self.cellPhone(recognizer :)))
                    self.callPhone.addGestureRecognizer(phoneAction)
                    self.callPhone.isUserInteractionEnabled = true
                    self.phoneNum = list["receiver_phone"] as? String
                    self.userId = list["shipper_id"] as? String
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.tishi(st: info)
                }
            }
            print("JSON: \(results)")
        }
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
    @objc fileprivate func cellPhone(recognizer:UIPanGestureRecognizer) {
        if(phoneNum != nil && !(phoneNum?.isEmpty)!){
            if #available(iOS 10, *) {
                print("跳转电话界面")
                UIApplication.shared.open(URL(string: "tel://"+phoneNum!)!, options: [:], completionHandler: nil)
            }else{
                UIApplication.shared.openURL(URL(string: "tel://"+phoneNum!)!)
            }
        }
    }
    
    @objc fileprivate func userMsgDetail(recognizer:UIPanGestureRecognizer){
        let sb = UIStoryboard(name: "findCargoTable", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "findCargoUserDetailView") as! FindCargoUserDetailViewController
        vc.userId = userId
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func getAreaInfo(_ areaCode : String) ->[String : Any]{
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab' where CODE = '\(areaCode)'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        return resultDataArr![0]
        
    }
}
