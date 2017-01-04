//
//  UsedLineController.swift
//  DriverIos
//
//  Created by mac on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class UsedLineController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnDelete: UIButton!//删除按钮
    @IBOutlet weak var viewDelete: UIView!//删除状态底部按钮
    @IBOutlet weak var btnSure: UIButton!//确定
    @IBOutlet weak var btnCancel: UIButton!//取消
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addLineLisener(_ sender: UIBarButtonItem) {
        addUsedLine()
    }
    @IBAction func deleteLineLisener(_ sender: UIButton) {
        viewDelete.isHidden = false
        btnDelete.isHidden = true
        isDelete = true
        self.tableView.reloadData()
    }
    @IBAction func btnSureLisener(_ sender: UIButton) {
//        deleteUsedLine(oftenId: oftenId!,index: indexPath.row)
        viewDelete.isHidden = true
        btnDelete.isHidden = false
        isDelete = false
        self.tableView.reloadData()
    }
    @IBAction func btnCancelLisener(_ sender: UIButton) {
        viewDelete.isHidden = true
        btnDelete.isHidden = false
        isDelete = false
        self.tableView.reloadData()
    }

    
    private let cellId = "usedLineItemCell"
    private var token = ""
    private var isDelete = false
    private let defaulthttp = DefaultHttp()
    private var models = [Any]()
    private var areamap:Dictionary<String,Any> = [:]
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
        let xib = UINib(nibName: "UsedLineItemCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        tableView.register(xib, forCellReuseIdentifier: cellId)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let curveHeader = CurveRefreshHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        _ = tableView.setUpHeaderRefresh(curveHeader) { [weak self] in
            delay(1.5, closure: {
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(delay: 0.5)
            })
        }
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.token = obj.token!
                self.getUsedLine()
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
     * 获取常跑路线信息
     */
    func getUsedLine() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.routes.list.get","time":strNowTime]
        
        defaulthttp.httpPost(parame: params){results in
            print("JSON: \(results)")
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    var obj:[Any] = results["resultObj"] as! [Any]
                    let cellMap:Dictionary<String,String> = ["isDelete":"N"]
                    obj.append(cellMap)
                    self.models = obj
                    self.tableView.reloadData()
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.hint(hintCon: info)
                }
            }
        }
    }
    /**
     * 删除常跑路线
     */
    func deleteUsedLine(oftenId:String,index:Int) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.route.delete","time":strNowTime,"often_id":strNowTime]
        
        defaulthttp.httpPost(parame: params){results in
            print("JSON: \(results)")
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.models.remove(at: index)
                    self.tableView.reloadData()
                    self.hint(hintCon: "删除成功")
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.hint(hintCon: info)
                }
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
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! UsedLineItemCell
        if(isDelete){
            cell.ivDelete.isHidden = false
        }else{
            cell.ivDelete.isHidden = true
        }
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let depaMap = areamap[cellMap["place_from_code"] as! String!] as! [String:AnyObject]?
        let destMap = areamap[cellMap["place_to_code"] as! String!] as! [String:AnyObject]?
        if depaMap != nil{
            cell.labelDepa.text = depaMap!["TEXT"] as! String?
        }
        if destMap != nil{
            cell.labelDest.text = destMap!["TEXT"] as! String?
        }
        cell.labelDepaDetail.text = cellMap["from_place"] as! String!
        cell.labelDestDetail.text = cellMap["to_place"] as! String!
        cell.labelMile.text = cellMap["to_place"] as! String!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isDelete){
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! UsedLineItemCell
            var cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
            let isDelete = cellMap["isDelete"] as! String!
            if(isDelete == "Y"){
                cell.ivDelete.image = UIImage(named: "circle_default")
                cellMap["isDelete"] = "N"
            }else{
                cell.ivDelete.image = UIImage(named: "circle_selected")
                cellMap["isDelete"] = "Y"
            }
            self.models.append(cellMap)
            self.tableView.reloadData()
        }
//        tableView.deselectRow(at: indexPath, animated: true)
//        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
//        let oftenId = cellMap["often_id"] as! String!
//        deleteUsedLine(oftenId: oftenId!,index: indexPath.row)
    }
    /**
     * 添加常跑路线
     */
    func addUsedLine() {
        let sb = UIStoryboard(name: "UsedLine", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "addUsedLineController") as! AddUsedLineController
        self.present(vc, animated: true, completion: nil)
    }
}
