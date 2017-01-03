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
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addLineLisener(_ sender: UIBarButtonItem) {
        addUsedLine()
    }
    
    private let cellId = "usedLineItemCell"
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
                self.getUsedLine(token: obj.token!)
            }
        }
    }
    /**
     * 获取常跑路线信息
     */
    func getUsedLine(token:String) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.routes.list.get","time":strNowTime]
        
        defaulthttp.httopost(parame: params){results in
            print("JSON: \(results)")
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let obj:[Any] = results["resultObj"] as! [Any]
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
        tableView.deselectRow(at: indexPath, animated: true)
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
