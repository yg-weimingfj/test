//
//  EmptyCarCargoTable.swift
//  DriverIos
//  空车匹配货源列表
//  Created by my on 2016/12/29.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarCargoTable: UIViewController {
    fileprivate var models = [Any]()
    private let  defaulthttp = DefaultHttp()
    private var token = "D681CD4B984048C6B8FE785F82FD9ADA"
    @IBOutlet weak var tableView: UITableView!
    var index = 0
    var chooseTime : String = ""
    var sourceAreaCode : String! = ""
    var destAreaCode : String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.matchCargos(ustoken: self.token)
        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "FindCargoCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        
        self.tableView.register(xib, forCellReuseIdentifier: "findCargoCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            delay(1.5, closure: {
               self?.matchCargos(ustoken: (self?.token)!)
            })
        }
        self.tableView.beginHeaderRefreshing()
    }
    func matchCargos(ustoken:String){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.idlevechile.match.cargos","time":strNowTime,"load_date":chooseTime,"place_from_code":sourceAreaCode,"place_to_code":destAreaCode]
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let obj = results["resultObj"]  as! [String:Any]
                    let list = obj["match_cargos"] as! [Any]
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "emptyCarPageChange"), object: index)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension EmptyCarCargoTable :UITableViewDelegate,UITableViewDataSource{
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
        return 125
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findCargoCell", for: indexPath) as! FindCargoCell
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let userLogo = cellMap["pic_path"] as! String
        if(userLogo != ""){
            let urlStr = NSURL(string: userLogo)
            let data = NSData(contentsOf: urlStr! as URL)
            cell.userLogoImage.image = UIImage(data: data! as Data)
            //                cell.userLogoImage.layer.cornerRadius = 32
        }
        let matchPercent = String(describing: cellMap["match_percent"] as! Int)
        cell.timeLabel.text = "匹配度" + matchPercent + "%"
        cell.timeLabel.textColor = UIColor(red: 252/255, green: 94/255, blue: 105/255, alpha: 1)
        cell.sourceAreaLabel.text = cellMap["from_place"] as? String
        cell.destAreaLabel.text = cellMap["to_place"] as? String
        
        var weigthValue = ""
        let cargoType = cellMap["g_type"] as? String
        let cargoSize = cellMap["g_size"] as? String
        let cargoUnit = cellMap["g_size_type"] as? String
        if(!(cargoSize?.isEmpty)! && !(cargoUnit?.isEmpty)!){
            weigthValue += cargoSize!+cargoUnit!
        }
        if(!(cargoType?.isEmpty)!){
            weigthValue += cargoType!
        }
        var cartypeValue = ""
        let carLength = cellMap["c_length"] as? String
        let carType = cellMap["c_type"] as? String
        if(!(carLength?.isEmpty)!){
            cartypeValue += carLength! + "米"
        }
        if(!(carType?.isEmpty)!){
            cartypeValue += carType!
        }
        cell.weightLabel.text = weigthValue
        cell.carTypeLabel.text = cartypeValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "emptyCarTransportDetail") as! EmptyCarTransportDetail
        vc.transportId = cellMap["cargo_id"] as? String
        self.present(vc, animated: true, completion: nil)
    }
}
