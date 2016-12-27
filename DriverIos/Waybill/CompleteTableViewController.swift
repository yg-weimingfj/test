//
//  CompleteTableViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/12.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class CompleteTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var models = [Any]()
    let cellId = "waybillCell"
    @IBOutlet var UITable: UITableView!
    private let  defaulthttp = DefaultHttp()
    private var token = ""
    private var pageStart = 1
    private var pageNum = 10
    private var areamap:Dictionary<String,Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let xib = UINib(nibName: "WaybillCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.UITable.register(xib, forCellReuseIdentifier: cellId)
        
        self.UITable.separatorInset = UIEdgeInsets.zero
        
        self.UITable.tableFooterView = UIView(frame: CGRect.zero)
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.UITable.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            self?.pageStart = 1
            self?.WaybillInfo(ustoken:(self?.token)!)
        }
        _ = self.UITable.setUpFooterRefresh {  [weak self] in
            self?.pageStart+=1
            self?.WaybillInfo(ustoken:(self?.token)!)
        }
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
                self.WaybillInfo(ustoken: self.token)
            }
        }
        getAreaData()

    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 1)
    }
    func getAreaData(){
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        for dict in resultDataArr! {
            //            let mymodel = AreaModel(code: dict["CODE"] as! String, parentCode: dict["PARENT_CODE"] as! String, text: dict["TEXT"] as! String, pinYin: dict["PIN_YIN"] as! String, remark: dict["REMARK"] as! String , simpleText: dict["SIMPLE_TEXT"] as! String, province: dict["PROVINCE"] as! String, simpleCity: dict["SIMPLE_CITY"] as! String, areaLevel: dict["LEVEL"] as! String, isDirectlyUnder: dict["IS_DIRECTLY_UNDER"] as! String, fullText: dict["FULL_TEXT"] as! String, cityText: dict["CITY_TEXT"] as! String , lon: dict["LON"] as! String, lat: dict["LAT"] as! String)
            areamap[dict["CODE"] as! String] = dict
        }
    }
    
    
    private func WaybillInfo(ustoken:String) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.orders.list.get","time":strNowTime,"order_status":"6","page_start":String(pageStart),"page_num":String(pageNum)]
        
        defaulthttp.httopost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let obj = results["resultObj"]  as! [String:Any]
                    let list = obj["list"] as! [Any]
                    if self.pageStart == 1{
                        self.models = list
                        self.UITable.endHeaderRefreshing(delay: 0.5)
                        if list.count >= 10{
                            self.UITable.endFooterRefreshing()
                        }else{
                            self.UITable.endFooterRefreshingWithNoMoreData()
                        }
                    }else{
                        if list.count < 10 {
                            self.UITable.endFooterRefreshingWithNoMoreData()
                        }else{
                            self.models = self.models+list
                            self.UITable.endFooterRefreshing()
                        }
                        
                    }
                    
                    self.UITable.reloadData()
                    
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148.0
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! WaybillCell
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let placeMap = areamap[cellMap["s_code"] as! String!] as! [String:AnyObject]?
        let DestinationMap = areamap[cellMap["t_code"] as! String!] as! [String:AnyObject]?
        
        
        if placeMap != nil{
            cell.WayBillPlaceOfDeparture.text = placeMap!["TEXT"] as! String?
                }
        if placeMap != nil{
            cell.WaybillDestination.text = DestinationMap!["TEXT"] as! String?
                }
        cell.WayBillDistance.text = cellMap["estimated_distance"] as! String!+"公里"
        cell.WaybillGoodsType.text = cellMap["cargo_size"] as! String!+(cellMap["cargo_unit"] as! String!)
        cell.WaybillCarType.text = cellMap["vehicle_type"] as! String?
        cell.WaybillTime.text = cellMap["carrier_order_taking_time"] as! String?
        if let rab = cellMap["carrier_rating_to_shipper"]{
            print("\(rab)")
            cell.WaybillRatingBar.rating = CGFloat(Int(Double(rab as! String)!))
        }else{
            cell.WaybillRatingBar.rating = 0
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }



}
