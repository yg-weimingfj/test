//
//  OrderAccountController.swift
//  DriverIos
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class OrderAccountController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var labelInCome: UILabel!//收入
    @IBOutlet weak var labelCost: UILabel!//支出
    @IBOutlet weak var labelBalance: UILabel!//结余
    @IBOutlet weak var tableView: UITableView!
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private var models = [Any]()
    private let cellId = "orderAccountCell"
    private var areamap:Dictionary<String,Any> = [:]
    private var orderMap:Dictionary<String,Any> = [:]
    private var token = ""
    private var orderId = ""
    private var pageStart = 1
    private var pageNum = 10
    private let defaulthttp = DefaultHttp()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 0)
        self.tableView.beginHeaderRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * 初始化
     */
    func initData() {
        let xib = UINib(nibName: "OrderAccountItemCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        tableView.register(xib, forCellReuseIdentifier: cellId)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let curveHeader = CurveRefreshHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        _ = tableView.setUpHeaderRefresh(curveHeader) { [weak self] in
            delay(1.5, closure: {
                self?.accountInfo()
                self?.getOrderList()
                self?.tableView.endHeaderRefreshing(delay: 0.5)
            })
        }
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.token = obj.token!
                self.tableView.beginHeaderRefreshing()
            }
        }
        getAreaData()
    }
    /**
     * 获取地区
     */
    func getAreaData(){
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab'"
        // 取出查询到的结果
        if let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL){
            for dict in resultDataArr{
                //            let mymodel = AreaModel(code: dict["CODE"] as! String, parentCode: dict["PARENT_CODE"] as! String, text: dict["TEXT"] as! String, pinYin: dict["PIN_YIN"] as! String, remark: dict["REMARK"] as! String , simpleText: dict["SIMPLE_TEXT"] as! String, province: dict["PROVINCE"] as! String, simpleCity: dict["SIMPLE_CITY"] as! String, areaLevel: dict["LEVEL"] as! String, isDirectlyUnder: dict["IS_DIRECTLY_UNDER"] as! String, fullText: dict["FULL_TEXT"] as! String, cityText: dict["CITY_TEXT"] as! String , lon: dict["LON"] as! String, lat: dict["LAT"] as! String)
                areamap[dict["CODE"] as! String] = dict
            }
        }
    }
    /**
     * 获取记账信息
     */
    func accountInfo() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.accounting.get","time":strNowTime]
        
        defaulthttp.httopost(parame: params){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let resultObj = results["resultObj"] as! Dictionary<String,Any>
                    var totalIncome = resultObj["total_income"] as! String!
                    var totalExpense = resultObj["total_expense"] as! String!
                    if(totalIncome?.isEmpty)!{
                        totalIncome = "0"
                    }
                    if(totalExpense?.isEmpty)!{
                        totalExpense = "0"
                    }
                    self.labelInCome.text = "+"+totalIncome!
                    self.labelCost.text = "-"+totalExpense!
                    let balance = Double(totalIncome!)! - Double(totalExpense!)!
                    if(balance > 0){
                        self.labelBalance.text = "+"+String(balance)
                    }else if(balance < 0){
                        self.labelBalance.text = "-"+String(balance)
                    }else{
                        self.labelBalance.text = "0"
                    }
                    
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.hint(hintCon: info)
                }
            }
            print("JSON: \(results)")
            
        }
    }
    /**
     * 获取运单信息
     */
    private func getOrderList() {
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
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! OrderAccountItemCell
        var cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let placeMap = areamap[cellMap["s_code"] as! String!] as! [String:AnyObject]?
        let DestinationMap = areamap[cellMap["t_code"] as! String!] as! [String:AnyObject]?
        
        if placeMap != nil{
            cell.labelDepa.text = placeMap!["TEXT"] as! String?
            cellMap["depa"] = placeMap!["TEXT"] as! String?
        }
        if placeMap != nil{
            cell.labelDest.text = DestinationMap!["TEXT"] as! String?
            cellMap["dest"] = DestinationMap!["TEXT"] as! String?
        }
        self.models[indexPath.row] = cellMap
        cell.labelMile.text = cellMap["estimated_distance"] as! String!
        cell.labelOrderNo.text = cellMap["order_no"] as! String?
        cell.labelFinishDate.text = cellMap["carrier_order_taking_time"] as! String?
        let inCome = cellMap["bk_income"] as! String!
        let cost = cellMap["bk_payment"] as! String!
        cell.labelInCome.text = "+"+inCome!
        cell.labelCost.text = "-"+cost!
        orderId = (cellMap["order_id"] as! String?)!
        let takeAccountUI = UITapGestureRecognizer(target: self, action: #selector(takeAccountLinener))
        cell.viewAccount.addGestureRecognizer(takeAccountUI)
        cell.viewAccount.isUserInteractionEnabled = true
                
        if((inCome?.isEmpty)! && (cost?.isEmpty)!){
            cell.viewMoney.isHidden = true
            cell.viewAccount.isHidden = false
        }else{
            cell.viewMoney.isHidden = false
            cell.viewAccount.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        orderMap = cellMap
        orderId = (cellMap["order_id"] as! String?)!
        accountInfoLinener()
    }
    /**
     * 记一记
     */
    func takeAccountLinener() {

        let sb = UIStoryboard(name: "OrderAccount", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "takeAccountController") as! TakeAccountController
        vc.orderId = orderId
        self.present(vc, animated: true, completion: nil)
    }
    /**
     * 记账详情
     */
    func accountInfoLinener() {
        
        let sb = UIStoryboard(name: "OrderAccount", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "accountInfoController") as! AccountInfoController
        vc.orderId = orderId
        vc.orderMap = orderMap
        self.present(vc, animated: true, completion: nil)
    }

}
