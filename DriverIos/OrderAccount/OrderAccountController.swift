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
    
    var models = [1,2,3,4,5,6,7,8,9,10]
    let cellId = "orderAccountCell"
    let defaulthttp = DefaultHttp()
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 0)
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
                self?.models = (self?.models.map({_ in Int(arc4random()%100)}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(delay: 0.5)
            })
        }
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.accountInfo(token: obj.token!)
            }
        }
    }
    /**
     * 获取记账信息
     */
    func accountInfo(token:String) {
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
                    let balance = Double(totalIncome!)! + Double(totalExpense!)!
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
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! OrderAccountItemCell
        cell.labelDepa.text = "福州仓山万达"
        cell.labelDest.text = "厦门鼓浪屿"
        let takeAccountUI = UITapGestureRecognizer(target: self, action: #selector(takeAccountLinener))
        cell.viewAccount.addGestureRecognizer(takeAccountUI)
        cell.viewAccount.isUserInteractionEnabled = true
        
        let accountInfoUI = UITapGestureRecognizer(target: self, action: #selector(accountInfoLinener))
        cell.viewItem.addGestureRecognizer(accountInfoUI)
        cell.viewItem.isUserInteractionEnabled = true
        
        if(indexPath.row%2 == 0){
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
    }
    /**
     * 记一记
     */
    func takeAccountLinener() {
        let sb = UIStoryboard(name: "OrderAccount", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "takeAccountController") as! TakeAccountController
        self.present(vc, animated: true, completion: nil)
    }
    /**
     * 记账详情
     */
    func accountInfoLinener() {
        let sb = UIStoryboard(name: "OrderAccount", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "accountInfoController") as! AccountInfoController
        self.present(vc, animated: true, completion: nil)
    }

}
