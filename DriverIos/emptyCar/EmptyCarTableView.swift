//
//  EmptyCarTableView.swift
//  DriverIos
//  空车历史上报列表
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate var models = [Any]()
    private let  defaulthttp = DefaultHttp()
    private var token = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "EmptyCarRecordCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        
        self.tableView.register(xib, forCellReuseIdentifier: "emptyCarRecordCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            self?.emptyCargoHistoryInfo(ustoken:(self?.token)!)
        }
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
                self.emptyCargoHistoryInfo(ustoken:(self.token))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func emptyCargoHistoryInfo(ustoken:String){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.idlevechiles.list.history.get","time":strNowTime]
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let obj = results["resultObj"]  as! [String:Any]
                    let list = obj["vehicle_idle"] as! [Any]
                    self.models = list
                    self.tableView.reloadData()
                    self.tableView.endHeaderRefreshing(delay: 0.5)
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.tishi(st: info)
                }
            }
            print("JSON: \(results)")
            
        }
    }
    private func tishi(st:String){
        let alertController = UIAlertController(title: st,
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //1秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCarRecordCell", for: indexPath) as! EmptyCarRecordCell
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        cell.sourceAreaLabel.text = cellMap["from_place"] as! String?
        cell.sourceAreaLabel.sizeToFit()
        var fromIamgeFrame = cell.fromImageView.frame
        fromIamgeFrame.origin.x = cell.sourceAreaLabel.frame.size.width + cell.sourceAreaLabel.frame.origin.x
        cell.fromImageView.frame = fromIamgeFrame
        var destAreaFrame = cell.destAreaLabel.frame
        destAreaFrame.origin.x = fromIamgeFrame.origin.x + fromIamgeFrame.size.width + 5
        cell.destAreaLabel.frame = destAreaFrame
        cell.destAreaLabel.text = cellMap["to_place"] as! String?
        cell.destAreaLabel.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        let sb = UIStoryboard(name: "findCargoTable", bundle:nil)
        //        let vc = sb.instantiateViewController(withIdentifier: "findCargoUserDetailView") as! FindCargoUserDetailViewController
        //        self.present(vc, animated: true, completion: nil)
    }
}
