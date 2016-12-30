//
//  AddUsedLineController.swift
//  DriverIos
//
//  Created by mac on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class AddUsedLineController: UIViewController {

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addLineLisener(_ sender: UIButton) {
        addUsedLine()
    }
    
    @IBOutlet weak var viewDepa: UIView!//出发地
    @IBOutlet weak var viewDest: UIView!//目的地
    @IBOutlet weak var viewAddLine: UIView!//添加返程路线
    @IBOutlet weak var labelDepa: UILabel!//出发地
    @IBOutlet weak var labelDest: UILabel!//目的地
    @IBOutlet weak var ivAddLine: UIImageView!//添加返程路线图标
    @IBOutlet weak var btnAddLine: UIButton!//添加返程路线按钮
    
    private var sourceAreaCode : String!
    private var sourceProvinceValue : String! = "省份"
    private var sourceCityValue : String! = "城市"
    private var sourceTownValue : String! = "区/镇"
    
    private var destAreaCode : String!
    private var destProvinceValue : String! = "省份"
    private var destCityValue :String! = "城市"
    private var destTownValue : String! = "区/镇"
    
    private var areaView : AreaDropDownView!
    private var dictView : DictDropDownView!
    private let viewWidth = UIScreen.main.bounds.size.width-20
    //    var sourceAreaDestView : AreaDropDownView!
    private var alertController : UIAlertController!
    private var isAddBackLine = false
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
        btnAddLine.layer.cornerRadius = 6
        
        let depaUI =  UITapGestureRecognizer(target: self, action: #selector(sourceAreaConditionChange))
        viewDepa.addGestureRecognizer(depaUI)
        viewDepa.isUserInteractionEnabled = true
        
        let destUI = UITapGestureRecognizer(target:self,action:#selector(destAreaConditionChange))
        viewDest.addGestureRecognizer(destUI)
        viewDest.isUserInteractionEnabled = true
        
        let addLineUI = UITapGestureRecognizer(target:self,action:#selector(addBackLine))
        viewAddLine.addGestureRecognizer(addLineUI)
        viewAddLine.isUserInteractionEnabled = true
    
        labelDepa.text = "请选择出发地"
        labelDest.text = "请选择目的地"
        
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.token = obj.token!
            }
        }
    }
    /**
     * 添加返程路线
     */
    func addBackLine(){
        if(isAddBackLine){
            ivAddLine.image = UIImage(named: "circle_default")
        }else{
            ivAddLine.image = UIImage(named: "circle_selected")
        }
        isAddBackLine = !isAddBackLine
    }
    /**
     * 添加常跑路线
     */
    func addUsedLine() {
        if((labelDepa.text?.isEmpty)! || labelDepa.text == "请选择出发地"){
            self.hint(hintCon: "请选择出发地")
        }else if((labelDest.text?.isEmpty)! || labelDest.text == "请选择目的地"){
            self.hint(hintCon: "请选择目的地")
        }else{
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            
            let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.route.add","time":strNowTime,"place_from_code":self.sourceAreaCode,"place_to_code":self.destAreaCode]
            
            defaulthttp.httopost(parame: des){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        self.hint(hintCon: "添加成功")
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.hint(hintCon: info)
                    }
                }
                print("JSON: \(results)")
                
            }
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
    func sourceAreaConditionChange (){
        alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,preferredStyle: .actionSheet)
        areaView = AreaDropDownView(frame:  CGRect(x: 0, y: 8, width: viewWidth, height: 400))
        //AreaDropDownView = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.8)
        alertController.view.addSubview(areaView)
        areaView.alertController = alertController
        areaView.areaCode = sourceAreaCode
        areaView.provinceValue = sourceProvinceValue
        areaView.cityValue = sourceCityValue
        areaView.townValue = sourceTownValue
        areaView.areaLabel = labelDepa
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
    
    func destAreaConditionChange(){
        alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,preferredStyle: .actionSheet)
        areaView = AreaDropDownView(frame:  CGRect(x: 0, y: 8, width: viewWidth, height: 400))
        //AreaDropDownView = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.8)
        alertController.view.addSubview(areaView)
        areaView.alertController = alertController
        areaView.areaCode = destAreaCode
        areaView.provinceValue = destProvinceValue
        areaView.areaLabel = labelDest
        areaView.cityValue = destCityValue
        areaView.townValue = destTownValue
        areaView.title = "请选择目的地"
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

}
