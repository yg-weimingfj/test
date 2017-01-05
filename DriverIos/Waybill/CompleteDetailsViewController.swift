//
//  CompleteDetailsViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class CompleteDetailsViewController: UIViewController {
    var orderId:String = ""
    @IBOutlet var ratingHeight: NSLayoutConstraint!
    @IBOutlet var buttonHeight: NSLayoutConstraint!
    @IBOutlet var buttonTopSpacing: NSLayoutConstraint!
    @IBOutlet var buttonBottomSpacing: NSLayoutConstraint!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var distanceText: UILabel!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var shipperName: UILabel!
    @IBOutlet var placeOfDeparture: UILabel!
    @IBOutlet var destination: UILabel!
    @IBOutlet var goodsType: UILabel!
    @IBOutlet var carLength: UILabel!
    @IBOutlet var orderCode: UILabel!
    @IBOutlet var companyAddress: UILabel!
    @IBOutlet var carrierName: UILabel!
    @IBOutlet var carNo: UILabel!
    @IBOutlet var carrierTel: UILabel!
    @IBOutlet var deliverGoodsTime: UILabel!
    @IBOutlet var arrivalTime: UILabel!
    @IBOutlet var shipperRating: RatingBar!
    @IBOutlet var myRating: RatingBar!
    @IBOutlet var shipperRatingText: UILabel!
    @IBOutlet var myRatingText: UILabel!
    @IBOutlet var receiptImage: UIImageView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var detailsScroll: UIScrollView!
    @IBOutlet var ratingNum: RatingBar!
    private var token = ""
    private let  defaulthttp = DefaultHttp()
    private var areamap:Dictionary<String,Any> = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsScroll.isHidden = true
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 5
        
        completeButton.layer.masksToBounds = true
        completeButton.layer.cornerRadius = 5
        
        activityIndicator.startAnimating()
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
                self.WaybillInfo()
            }
        }
        getAreaData()
        // Do any additional setup after loading the view.
    }
    @IBAction func submitButton(_ sender: UIButton) {
        WaybillRating()
    }
    private func getAreaData(){
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        for dict in resultDataArr! {
            areamap[dict["CODE"] as! String] = dict
        }
    }
    private func WaybillRating() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.rating.update","time":strNowTime,"order_id":orderId,"shipper_rating_to_carrier":String(describing: ratingNum.rating)]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.WaybillInfo()
                    
                }else{
                    //                    let info:String = results["resultInfo"] as! String!
                }
            }
            print("JSON: \(results)")
            
        }
    }
    private func WaybillInfo() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.order.get","time":strNowTime,"order_id":orderId]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                if result == "1"{
                    let obj = results["resultObj"]  as! [String:Any]
                    self.detailsScroll.isHidden = false
                    self.detailsInfo(obj: obj)
                    
                }else{
                    //                    let info:String = results["resultInfo"] as! String!
                }
            }
            print("JSON: \(results)")
            
        }
    }
    private func detailsInfo(obj:Dictionary<String,Any>){
        let placeMap = areamap[obj["s_code"] as! String!] as! [String:AnyObject]?
        let DestinationMap = areamap[obj["t_code"] as! String!] as! [String:AnyObject]?
        
        
        if placeMap != nil{
            placeOfDeparture.text = placeMap!["TEXT"] as! String?
            destination.text = DestinationMap!["TEXT"] as! String?
        }
        distanceText.text = obj["estimated_distance"] as! String?
        shipperName.text = obj["shipper_name"] as! String?
        if obj["cargo_size"] != nil && obj["cargo_unit"] != nil{
            goodsType.text = (obj["cargo_size"] as! String) + (obj["cargo_unit"] as! String)
        }
        carLength.text = obj["vehicle_length"] as! String?
        orderCode.text = obj["order_no"] as! String?
        companyAddress.text = obj["order_no"] as! String?
        carrierName.text = obj["carrier_name"] as! String?
        carNo.text = obj["number_plate"] as! String?
        carrierTel.text = "没有司机电话号码"
        deliverGoodsTime.text = obj["post_time"] as! String?
        arrivalTime.text = obj["arrive_time"] as! String?
        
        
        
        if  obj["carrier_rating_to_shipper"] == nil||(obj["carrier_rating_to_shipper"] as! String) == ""{
            shipperRatingText.isHidden = false
            shipperRating.isHidden = true
        }else{
            shipperRatingText.isHidden = true
            shipperRating.isHidden = false
            let RBNum = Int(Double(obj["carrier_rating_to_shipper"] as! String)!)
            shipperRating.rating = CGFloat(RBNum)
        }
        if  obj["shipper_rating_to_carrier"] == nil||(obj["shipper_rating_to_carrier"] as! String) == ""{
            myRatingText.isHidden = false
            myRating.isHidden = true
            completeButton.isHidden = true
            buttonHeight.constant = 0
            buttonTopSpacing.constant = 0
            buttonBottomSpacing.constant = 0
        }else{
            myRatingText.isHidden = true
            myRating.isHidden = false
            let RBNum = Int(Double(obj["shipper_rating_to_carrier"] as! String)!)
            myRating.rating = CGFloat(RBNum)
            ratingView.isHidden = true
            ratingHeight.constant = 0
        }
        
        //        receiptImage／／回单图片
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
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
