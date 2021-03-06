//
//  EmptyCarController.swift
//  DriverIos
//  空车上报页面
//  Created by my on 2016/12/7.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit


class EmptyCarController: UIViewController {
    
    private let  defaulthttp = DefaultHttp()

    private var token = ""
    
    var parentController: EmptyCarListViewController!
    
    @IBOutlet weak var sourceAreaLabel: UILabel!
    @IBOutlet weak var destAreaLabel: UILabel!
    var datePickView : UIDatePicker!
    var contentView : UIView!

    var pickView: UIView!
    
    var sourceAreaCode : String!
    var sourceProvinceValue : String! = "省份"
    var sourceCityValue : String! = "城市"
    var sourceTownValue : String! = "区/镇"
    
    var destAreaCode : String!
    var destProvinceValue : String! = "省份"
    var destCityValue :String! = "城市"
    var destTownValue : String! = "区/镇"

    var timeValue : String! = ""
    
    var alertController : UIAlertController!
    var areaView : AreaDropDownView!
    
    let viewWidth = UIScreen.main.bounds.size.width-20
    
    @IBOutlet weak var sourceAreaView: UIView!
    @IBOutlet weak var emptyCarButton: UIButton!
    @IBOutlet weak var destAreaView: UIView!


    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var emptyCarTimeView: UIView!
    
    //变量初始化
    var provinceCode : String!
    var cityCode : String!
    var townCode : String!
    var areaCode : String!
    var areaText : String!
    var selectedAreaCode : String!
    
    var allArea : NSArray!
    var areaArr : Array<AnyObject> = []
    
    let buttonColor = UIColor(red: 51/255, green: 142/255, blue: 255/255, alpha: 0.5)
    
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
            }
        }
        // Do any additional setup after loading the view.
        let sourceAreaViewUI = UITapGestureRecognizer(target: self, action: #selector(sourceAreaPickViewShow))
        sourceAreaView.addGestureRecognizer(sourceAreaViewUI)
        sourceAreaView.isUserInteractionEnabled = true
        
        let destAreaViewAction = UITapGestureRecognizer(target: self, action: #selector(destAreaPickViewShow))
        destAreaView.addGestureRecognizer(destAreaViewAction)
        destAreaView.isUserInteractionEnabled = true
        
        let emptyCarTimeViewUI = UITapGestureRecognizer(target: self, action: #selector(timePickViewShow))
        emptyCarTimeView.addGestureRecognizer(emptyCarTimeViewUI)
        emptyCarTimeView.isUserInteractionEnabled = true
        
        emptyCarButton.layer.masksToBounds = true
        emptyCarButton.layer.cornerRadius = 10

        pickView = UIView(frame: CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height))
        
        let closeView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height/3))
        closeView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
        pickView.addSubview(closeView)
        let pickViewAction = UITapGestureRecognizer(target: self, action: #selector(cancel))
        closeView.addGestureRecognizer(pickViewAction)
        closeView.isUserInteractionEnabled = true
    }
    
    func timePickViewShow() {//时间选择显示
        
        if contentView != nil{
            contentView.removeFromSuperview()
        }
        let contentViewWidth = screenSize.width
        let contentViewHeight = screenSize.height/3*2
        contentView = UIView(frame: CGRect(x: 0, y: screenSize.height/3, width: contentViewWidth, height: contentViewWidth))
        contentView.backgroundColor = UIColor.white
        pickView.addSubview(contentView)
        
        let cancelButton = UIButton(frame: CGRect(x: 10, y: 10, width: 60, height: 20))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = buttonColor
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 3
        contentView.addSubview(cancelButton)
        
        let timeOkButton = UIButton(frame: CGRect(x: contentViewWidth-70, y: 10, width: 60, height: 20))
        timeOkButton.setTitle("确定", for: .normal)
        timeOkButton.setTitleColor(UIColor.white, for: .normal)
        timeOkButton.backgroundColor = buttonColor
        timeOkButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        timeOkButton.layer.masksToBounds = true
        timeOkButton.layer.cornerRadius = 3
        contentView.addSubview(timeOkButton)
        
        datePickView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: contentViewWidth, height: contentViewHeight-40))
        datePickView.locale = Locale.init(identifier: "zh_CN")
        contentView.addSubview(datePickView)
        if timeLabel.text?.isEmpty == false{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: timeLabel.text!)
            datePickView.setDate(date!, animated: true)
        }
        let timeOkButtonView = UITapGestureRecognizer(target: self, action: #selector(timeOk))
        timeOkButton.addGestureRecognizer(timeOkButtonView)
        timeOkButton.isUserInteractionEnabled = true
        
        let cancelButtonUI = UITapGestureRecognizer(target: self, action: #selector(cancel))
        cancelButton.addGestureRecognizer(cancelButtonUI)
        cancelButton.isUserInteractionEnabled = true
        pickOpen()
    }
    
    func pickOpen(){//弹出层显示
        UIApplication.shared.windows[0].addSubview(pickView)//将view加入window中准备显示
        var frame = pickView.frame
        frame.origin.y = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
        }) { (Bool) in
            UIView .animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.pickView.frame = frame
            }, completion: { (Bool) in})
        }
    }
    
    func timeOk(){//时间确定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        timeLabel.text = dateFormatter.string(from: datePickView.date)
        dateFormatter.dateFormat = "YYYY-MM-dd aa"
        timeValue = dateFormatter.string(from:datePickView.date)
        timeValue = timeValue.replacingOccurrences(of: "AM", with: "上午").replacingOccurrences(of: "PM", with: "下午")
        contentView.removeFromSuperview()
        cancel()
    }
    func cancel(){//关闭事件
            var frame = pickView.frame
            frame.origin.y += pickView.frame.size.height
            
            UIView.animate(withDuration: 0.3, animations: {
                self.pickView.frame = frame
            }) { (Bool) in
                UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                }, completion: { (Bool) in
                    // 移除
                    self.pickView.removeFromSuperview()
                })
            }
        
        contentView.removeFromSuperview()
    }
    func sourceAreaPickViewShow(){
        alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,preferredStyle: .actionSheet)
        areaView = AreaDropDownView(frame:  CGRect(x: 0, y: 8, width: viewWidth, height: 400))
        //AreaDropDownView = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.8)
        alertController.view.addSubview(areaView)
        areaView.alertController = alertController
        areaView.areaCode = sourceAreaCode
        areaView.provinceValue = sourceProvinceValue
        areaView.cityValue = sourceCityValue
        areaView.townValue = sourceTownValue
        areaView.areaLabel = sourceAreaLabel
        areaView.showLevel = "2"
        areaView.createAreaView()
        areaView.bbchange = { (areaCode:String,proviceValue:String,cityValue : String,townValue : String) in
            
            self.sourceAreaCode = areaCode
            self.sourceProvinceValue = proviceValue
            self.sourceCityValue = cityValue
            self.sourceTownValue = townValue
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func destAreaPickViewShow(){
        alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,preferredStyle: .actionSheet)
        areaView = AreaDropDownView(frame:  CGRect(x: 0, y: 8, width: viewWidth, height: 400))
        //AreaDropDownView = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.8)
        alertController.view.addSubview(areaView)
        areaView.alertController = alertController
        areaView.areaCode = destAreaCode
        areaView.provinceValue = destProvinceValue
        areaView.cityValue = destCityValue
        areaView.townValue = destTownValue
        areaView.areaLabel = destAreaLabel
        areaView.showLevel = "2"
        areaView.createAreaView()
        areaView.bbchange = { (areaCode:String,proviceValue:String,cityValue : String,townValue : String) in
            
            self.destAreaCode = areaCode
            self.destProvinceValue = proviceValue
            self.destCityValue = cityValue
            self.destTownValue = townValue
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    @IBAction func uploadEmptyCarRecord(_ sender: Any) {
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "emptyCarUploadRecordList") as! EmptyCarUploadRecordList
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func emptyCarUpload(_ sender: Any) {
        if(self.sourceAreaCode == nil || self.sourceAreaCode.isEmpty){
            alertMsg(st: "出发地不能为空")
        }else if(self.destAreaCode == nil || self.destAreaCode.isEmpty){
            alertMsg(st: "目的地不能为空")
        }else{
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            
            let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.idlevechile.add","time":strNowTime,"lng":self.getAreaInfo((self.sourceAreaCode)!)["LON"] as! String,"lat":self.getAreaInfo((self.sourceAreaCode)!)["LAT"] as! String,"addr":self.getAreaInfo((self.sourceAreaCode)!)["FULL_TEXT"] as! String,"idle_time":self.timeValue,"from_place":self.sourceAreaLabel.text! as String,"place_from_code":self.sourceAreaCode,"tareas":self.destAreaLabel.text! as String,"tcodes":self.destAreaCode]
            
            defaulthttp.httpPost(parame: des){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        self.dismiss(animated: true, completion: nil)
                        if(self.parentController != nil){
                            self.parentController.emptyCargoInfo(ustoken: self.token)
                        }
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.alertMsg(st: info)
                    }
                }
                print("JSON: \(results)")
            }
         
        }
    }
   private func alertMsg(st:String){
        let alertController = UIAlertController(title: st,message: nil, preferredStyle: .alert)
        
        let timeAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(timeAction)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    private func getAreaInfo(_ areaCode : String) ->[String : Any]{
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab' where CODE = '\(areaCode)'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        return resultDataArr![0]
        
    }
    @IBAction func emptyCarBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
