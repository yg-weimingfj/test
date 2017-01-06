//
//  findCargoTableViewController.swift
//  DriverIos
//
//  Created by my on 2016/12/20.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class findCargoTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    private var models = [Any]()
    private let  defaulthttp = DefaultHttp()
    private var token = ""
    private var pageStart = 1
    private var pageNum = 10
    
    let mainScreen = UIScreen.main.bounds.size
    let selectArr : [String] = ["出发地","目的地","车长","车型"]
    let conditionNum = 4
    var methodNum : Int!
    
    var sourceAreaCode : String! = ""
    var sourceProvinceValue : String! = "省份"
    var sourceCityValue : String! = "城市"
    var sourceTownValue : String! = "区/镇"
    
    var destAreaCode : String! = ""
    var destProvinceValue : String! = "省份"
    var destCityValue :String! = "城市"
    var destTownValue : String! = "区/镇"
    
    var areaView : AreaDropDownView!
    var dictView : DictDropDownView!
    let viewWidth = UIScreen.main.bounds.size.width-20
//    var sourceAreaDestView : AreaDropDownView!
    var alertController : UIAlertController!
    
    var carLengthValue : String! = ""
    var carLengthId : String!
    
    var carTypeValue : String! = ""
    var carTypeId : String!
    
    var sourceAreaLabel : UILabel!
    var destAreaLabel : UILabel!
    var carTypeLabel : UILabel!
    var carLengthLabel : UILabel!
    var dictArr : Array<AnyObject> = []
    
    @IBOutlet weak var findCargoSelectedView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        allCargoSelect()
        let empty = UINib(nibName: "EmptyCell", bundle: nil)
        self.tableView.register(empty, forCellReuseIdentifier: "emptyCell")
        let xib = UINib(nibName: "FindCargoCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        
        self.tableView.register(xib, forCellReuseIdentifier: "findCargoCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in

                self?.pageStart = 1
                self?.findCargoInfo(ustoken:(self?.token)!)
           
        }
        _ = self.tableView.setUpFooterRefresh {  [weak self] in
            self?.pageStart+=1
            self?.findCargoInfo(ustoken:(self?.token)!)
        }
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
                self.findCargoInfo(ustoken:(self.token))
            }
        }
    }
    func findCargoInfo(ustoken:String) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.cargos.list.get","time":strNowTime,"order_status":"3","place_from_code":sourceAreaCode,"place_to_code":destAreaCode,"vehicle_type":carTypeValue,"vehicle_length":carLengthValue,"page_start":String(pageStart),"page_num":String(pageNum)]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let list = results["resultObj"]  as! [Any]
//                    let list = obj["list"] as! [Any]
                    if self.pageStart == 1{
                        self.models = list
                        self.tableView.endHeaderRefreshing(delay: 0.5)
                        if list.count >= 10{
                            self.tableView.endFooterRefreshing()
                        }else{
                            self.tableView.endFooterRefreshingWithNoMoreData()
                        }
                    }else{
                        if list.count < 10 {
                            self.tableView.endFooterRefreshingWithNoMoreData()
                        }else{
                            self.models = self.models+list
                            self.tableView.endFooterRefreshing()
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
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
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "findCargoPageChanged"), object: 0)
    }
    func allCargoSelect(){
        for i in 0 ..< conditionNum {
            let conditionWidth = Int(mainScreen.width)/conditionNum
            let conditionView = UIView(frame : CGRect(x:conditionWidth*i,y:0,width:conditionWidth,height:42))
            var conditionViewAction = UITapGestureRecognizer(target: self, action: nil)
            let conditionImage = UIImageView(frame:CGRect(x: conditionWidth-26, y: 19, width: 11, height: 6))
            conditionImage.image = UIImage(named: "findCargoConditionSelect")
            conditionView.addSubview(conditionImage)
            if i == 0 {
                sourceAreaLabel = UILabel(frame: CGRect(x: 0, y: 12, width: conditionWidth-26, height: 20))
                sourceAreaLabel.text = selectArr[i]
                sourceAreaLabel.font = UIFont.systemFont(ofSize: 13)
                sourceAreaLabel.textAlignment = NSTextAlignment.right
                conditionView.addSubview(sourceAreaLabel)
                conditionViewAction =  UITapGestureRecognizer(target: self, action: #selector(sourceAreaConditionChange))
            }else if i == 1 {
                destAreaLabel = UILabel(frame: CGRect(x: 0, y: 12, width: conditionWidth-26, height: 20))
                destAreaLabel.text = selectArr[i]
                destAreaLabel.font = UIFont.systemFont(ofSize: 13)
                destAreaLabel.textAlignment = NSTextAlignment.right
                conditionView.addSubview(destAreaLabel)
                conditionViewAction = UITapGestureRecognizer(target:self,action:#selector(destAreaConditionChange))
            }else if i == 2{
                carLengthLabel = UILabel(frame: CGRect(x: 0, y: 12, width: conditionWidth-26, height: 20))
                carLengthLabel.text = selectArr[i]
                carLengthLabel.font = UIFont.systemFont(ofSize: 13)
                carLengthLabel.textAlignment = NSTextAlignment.right
                conditionView.addSubview(carLengthLabel)
                conditionViewAction = UITapGestureRecognizer(target:self,action:#selector(carLengthConditionChange))
            }else if i == 3 {
                carTypeLabel = UILabel(frame: CGRect(x: 0, y: 12, width: conditionWidth-26, height: 20))
                carTypeLabel.text = selectArr[i]
                carTypeLabel.font = UIFont.systemFont(ofSize: 13)
                carTypeLabel.textAlignment = NSTextAlignment.right
                conditionView.addSubview(carTypeLabel)
                conditionViewAction = UITapGestureRecognizer(target:self,action:#selector(carTypeConditonChange))
            }
            conditionView.addGestureRecognizer(conditionViewAction)
            conditionView.isUserInteractionEnabled = true
            findCargoSelectedView.addSubview(conditionView)
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
        areaView.areaLabel = sourceAreaLabel
        areaView.title = "请选择出发地"
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
        areaView.cityValue = destCityValue
        areaView.townValue = destTownValue
        areaView.areaLabel = destAreaLabel
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
    func carLengthConditionChange(){
        alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,preferredStyle: .actionSheet)
        setDictData("TRUCK_LENGTH")
        dictView = DictDropDownView(frame:  CGRect(x: 0, y: 8, width: viewWidth, height: 400))
        dictView.titleValue = "选择车长"
        dictView.dictArr = dictArr
        dictView.dictLabel = carLengthLabel
        dictView.alertController = alertController
        dictView.dictValue = carLengthId
        dictView.createView()
        dictView.bbchange = {(id :String,text :String) in
            self.carLengthId = id
            self.carLengthValue = text
        }
        alertController.view.addSubview(dictView)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func carTypeConditonChange(){
        alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,preferredStyle: .actionSheet)
        setDictData("TRUCK_TYPE")
        dictView = DictDropDownView(frame:  CGRect(x: 0, y: 8, width: viewWidth, height: 500))
        dictView.titleValue = "选择车辆类型"
        dictView.dictArr = dictArr
        dictView.dictLabel = carTypeLabel
        dictView.alertController = alertController
        dictView.dictValue = carTypeId
        dictView.createView()
        dictView.bbchange = {(id :String,text :String) in
            self.carTypeId = id
            self.carTypeValue = text
        }
        alertController.view.addSubview(dictView)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func setDictData(_ str : String){
        let querySQL = "SELECT ID,TYPE,CODE,TEXT FROM 'sys_dict_tab' where type = '\(str)' order by seq desc"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        dictArr = []
        dictArr.append(DictModel(dictId: "", dictType: "", dictCode: "", dictText: "不限"))
        for dict in resultDataArr! {
            let dictmodel = DictModel(dictId: dict["id"] as! String, dictType: dict["type"] as! String, dictCode: dict["code"] as! String, dictText: dict["text"] as! String )
            dictArr.append(dictmodel)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc fileprivate func cellPhone(recognizer:UIPanGestureRecognizer) {
        let index = recognizer.view?.tag
        let cellMap:Dictionary<String,Any> = self.models[index!] as! [String:Any]
        let phone = cellMap["receiver_phone"] as! String?
        if(phone != nil && !(phone?.isEmpty)!){
            let alertController = UIAlertController(title: phone,
                                                    message: nil, preferredStyle: .alert)
            let alertCancelAction = UIAlertAction(title:"取消",style: .cancel,handler: nil)
            let alertActionOK = UIAlertAction(title: "拨打", style: .default, handler: {
                action in
                if #available(iOS 10, *) {
                    print("跳转电话界面")
                    UIApplication.shared.open(URL(string: "tel://"+phone!)!, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(URL(string: "tel://"+phone!)!)
                }
            })
            alertController.addAction(alertCancelAction)
            alertController.addAction(alertActionOK)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func userMsgDetail(recognizer:UIPanGestureRecognizer){
        let index = recognizer.view?.tag
        let cellMap:Dictionary<String,Any> = self.models[index!] as! [String:Any]
        let sb = UIStoryboard(name: "findCargoTable", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "findCargoUserDetailView") as! FindCargoUserDetailViewController
        vc.userId = cellMap["shipper_id"] as! String?
        self.present(vc, animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row%6 == 0){
            return 0
        }else{
           return 125
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row%6 == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as! EmptyCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "findCargoCell", for: indexPath) as! FindCargoCell
            let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
            let userLogo = cellMap["avatar"] as! String
            if(userLogo != ""){
                let urlStr = NSURL(string: cellMap["avatar"] as! String)
                let data = NSData(contentsOf: urlStr! as URL)
                cell.userLogoImage.image = UIImage(data: data! as Data)
//                cell.userLogoImage.layer.cornerRadius = 32
            }
            
            cell.timeLabel.text = cellMap["post_time"] as? String
            cell.sourceAreaLabel.text = getAreaInfo((cellMap["place_from_code"] as? String)!)["TEXT"] as! String?
            cell.destAreaLabel.text =  getAreaInfo((cellMap["place_to_code"] as? String)!)["TEXT"] as! String?
            cell.distanceLabel.text = cellMap["estimated_distance"] as? String
            var weigthValue = ""
            let cargoType = cellMap["cargo_type"] as? String
            let cargoSize = cellMap["cargo_size"] as? String
            let cargoUnit = cellMap["cargo_unit"] as? String
            if(!(cargoSize?.isEmpty)! && !(cargoUnit?.isEmpty)!){
                weigthValue += cargoSize!+cargoUnit!
            }
            if(!(cargoType?.isEmpty)!){
                weigthValue += cargoType!
            }
            var cartypeValue = ""
            let carLength = cellMap["vehicle_length"] as? String
            let carType = cellMap["vehicle_type"] as? String
            if(!(carLength?.isEmpty)!){
                cartypeValue += carLength! + "米"
            }
            if(!(carType?.isEmpty)!){
                cartypeValue += carType!
            }
            cell.weightLabel.text = weigthValue
            cell.carTypeLabel.text = cartypeValue
            
            let userLogoAction = UITapGestureRecognizer(target:self,action:#selector(userMsgDetail(recognizer :)))
            cell.userLogoImage.addGestureRecognizer(userLogoAction)
            cell.userLogoImage.isUserInteractionEnabled = true
            cell.userLogoImage.tag = indexPath.row
            
            let phoneAction = UITapGestureRecognizer(target:self,action:#selector(cellPhone(recognizer :)))
            cell.phoneImage.addGestureRecognizer(phoneAction)
            cell.phoneImage.isUserInteractionEnabled = true
            cell.phoneImage.tag = indexPath.row
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "emptyCarTransportDetail") as! EmptyCarTransportDetail
        vc.transportId = cellMap["cargo_id"] as? String
        self.present(vc, animated: true, completion: nil)
    }
    private func getAreaInfo(_ areaCode : String) ->[String : Any]{
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab' where CODE = '\(areaCode)'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        return resultDataArr![0]
        
    }
}
