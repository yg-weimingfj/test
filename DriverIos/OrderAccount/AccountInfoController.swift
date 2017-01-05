//
//  AccountInfoController.swift
//  DriverIos
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class AccountInfoController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var labelOrderNo: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelMile: UILabel!
    @IBOutlet weak var labelDepa: UILabel!
    @IBOutlet weak var labelDest: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let cellId = "accountInfoCell"
    var orderId :String = ""
    var orderMap:Dictionary<String,Any> = [:]
    private var models = [Any]()
    private let defaulthttp = DefaultHttp()
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
        let xib = UINib(nibName: "AccountInfoCell", bundle: nil) //nibName指的是我们创建的Cell文件名
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
                self.accountInfo(token: obj.token!)
            }
        }
        
        labelMile.text = orderMap["estimated_distance"] as! String!
        labelOrderNo.text = orderMap["order_no"] as! String?
        labelDepa.text = orderMap["depa"] as! String?
        labelDest.text = orderMap["dest"] as! String?
        labelDate.text = orderMap["carrier_order_taking_time"] as! String?

    }
    /**
     * 获取运单账单信息
     */
    private func accountInfo(token:String) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.accounting.new.bill.list","time":strNowTime,"order_id":orderId]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let obj = results["resultObj"]  as! [Any]
                    self.models = obj
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
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! AccountInfoCell
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        var type = cellMap["bkd_type"] as! String!
        if(type == "0"){
            type = "收入"
        }else{
            type = "支出"
        }
        cell.labelDate.text = cellMap["action_date"] as! String!
        cell.labelType.text = type
        cell.labelCash.text = cellMap["expense_cash"] as! String!
        cell.labelCashType.text = cellMap["expense_type_desc"] as! String!
        cell.labelCashType.text = cellMap["expense_type_desc"] as! String!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
