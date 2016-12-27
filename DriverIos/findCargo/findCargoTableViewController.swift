//
//  findCargoTableViewController.swift
//  DriverIos
//
//  Created by my on 2016/12/20.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class findCargoTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let mainScreen = UIScreen.main.bounds.size
    let selectArr : [String] = ["出发地","目的地","车长","车型"]
    let conditionNum = 4
    var methodNum : Int!
    
    var sourceAreaCode : String!
    var sourceProvinceValue : String! = "省份"
    var sourceCityValue : String! = "城市"
    var sourceTownValue : String! = "区/镇"
    
    var destAreaCode : String!
    var destProvinceValue : String! = "省份"
    var destCityValue :String! = "城市"
    var destTownValue : String! = "区/镇"
    
    var areaView : AreaDropDownView!
    var dictView : DictDropDownView!
    let viewWidth = UIScreen.main.bounds.size.width-20
//    var sourceAreaDestView : AreaDropDownView!
    var alertController : UIAlertController!
    
    var carLengthValue : String!
    var carLengthId : String!
    
    var carTypeValue : String!
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
        let xib = UINib(nibName: "FindCargoCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        
        self.tableView.register(xib, forCellReuseIdentifier: "findCargoCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            delay(1.5, closure: {
//                self?.models = (self?.models.map({_ in Int(arc4random()%100)}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing()
            })
        }
        self.tableView.beginHeaderRefreshing()
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

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findCargoCell", for: indexPath) as! FindCargoCell
        let userLogoAction = UITapGestureRecognizer(target:self,action:#selector(userMsgDetail))
        cell.userLogoImage.addGestureRecognizer(userLogoAction)
        cell.userLogoImage.isUserInteractionEnabled = true
//        let messageListUI = UITapGestureRecognizer(target: self, action: #selector(messageListLinener))
//        messageList.addGestureRecognizer(messageListUI)
//        messageList.isUserInteractionEnabled = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let sb = UIStoryboard(name: "findCargoTable", bundle:nil)
//        let vc = sb.instantiateViewController(withIdentifier: "findCargoUserDetailView") as! FindCargoUserDetailViewController
//        self.present(vc, animated: true, completion: nil)
    }
    func userMsgDetail(){
        let sb = UIStoryboard(name: "findCargoTable", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "findCargoUserDetailView") as! FindCargoUserDetailViewController
        self.present(vc, animated: true, completion: nil)
    }
}

