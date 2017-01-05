//
//  EmptyCarTableController.swift
//  DriverIos
//
//  Created by my on 2016/12/22.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarTableController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var pageStart = 1
    private var pageNum = 10
    private let  defaulthttp = DefaultHttp()
    private var dataAtrr = [Any]()
    private var token = ""
    @IBOutlet weak var emptyCarTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyCarTableView.delegate = self
        emptyCarTableView.dataSource = self
        let emptyCarNib=UINib(nibName: "EmptyCarCell",bundle: nil)
        self.emptyCarTableView.register(emptyCarNib, forCellReuseIdentifier: "emptyCarCell")
        let xib = UINib(nibName: "FindCargoCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.emptyCarTableView.register(xib, forCellReuseIdentifier: "findCargoCell")
        self.emptyCarTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.emptyCarTableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.emptyCarTableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            self?.pageStart = 1
            self?.CargoInfo(ustoken:(self?.token)!)
        }
        _ = self.emptyCarTableView.setUpFooterRefresh {  [weak self] in
            self?.pageStart+=1
            self?.CargoInfo(ustoken:(self?.token)!)
        }
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
                self.CargoInfo(ustoken:(self.token))
            }
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "findCargoPageChanged"), object: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func CargoInfo(ustoken:String) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.routes.match.cargos","time":strNowTime,"order_status":"3","page_start":String(pageStart),"page_num":String(pageNum)]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                   let list = results["resultObj"]  as! [Any]
                    if self.pageStart == 1{
                        self.dataAtrr = list
                        self.emptyCarTableView.endHeaderRefreshing(delay: 0.5)
                        if list.count >= 10{
                            self.emptyCarTableView.endFooterRefreshing()
                        }else{
                            self.emptyCarTableView.endFooterRefreshingWithNoMoreData()
                        }
                    }else{
                        if list.count < 10 {
                            self.emptyCarTableView.endFooterRefreshingWithNoMoreData()
                        }else{
                            self.dataAtrr = self.dataAtrr+list
                            self.emptyCarTableView.endFooterRefreshing()
                        }
                        
                    }
                    
                    self.emptyCarTableView.reloadData()
                    
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
    @objc fileprivate func cellPhone(recognizer:UIPanGestureRecognizer) {
        let phone = recognizer.view?.accessibilityValue 
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
        //        let index = recognizer.view?.tag
        //        let cellMap:Dictionary<String,Any> = self.models[index!] as! [String:Any]
        let sb = UIStoryboard(name: "findCargoTable", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "findCargoUserDetailView") as! FindCargoUserDetailViewController
        vc.userId = recognizer.view?.accessibilityValue
        self.present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataAtrr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rowDict = dataAtrr[section] as! NSDictionary
//        cell.myLabel.text = rowDict["name"] as? String
        let rowData = rowDict["match_cargos"] as! NSArray
        if(rowData.count == 0){
            return 0
        }else{
            return rowData.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 49
        }else{
           return 125
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell:EmptyCarCell! = tableView.dequeueReusableCell(withIdentifier: "emptyCarCell", for: indexPath) as? EmptyCarCell
            let sectionMap:Dictionary<String,Any> = self.dataAtrr[indexPath.section] as! [String:Any]
            cell.sourceAreaLabel.text = sectionMap["from_place"] as? String
            cell.destAreaLabel.text = sectionMap["to_place"] as? String
            return cell
        }else{
            print(indexPath.section)
            let cell:FindCargoCell! = tableView.dequeueReusableCell(withIdentifier: "findCargoCell", for: indexPath) as? FindCargoCell
            let sectionMap:Dictionary<String,Any> = self.dataAtrr[indexPath.section] as! [String:Any]
            let cellArray = sectionMap["match_cargos"] as! NSArray
            let cellMap = cellArray[indexPath.row-1] as! [String:Any]
            let userLogo = cellMap["pic_path"] as? String
            if(userLogo != nil && !(userLogo?.isEmpty)!){
                let urlStr = NSURL(string: userLogo!)
                let data = NSData(contentsOf: urlStr! as URL)
                cell.userLogoImage.image = UIImage(data: data! as Data)
                //                cell.userLogoImage.layer.cornerRadius = 32
            }
            cell.timeLabel.text = cellMap["create_time"] as? String
            cell.sourceAreaLabel.text = cellMap["from_place"] as? String
            cell.destAreaLabel.text = cellMap["to_place"] as? String
//            cell.distanceLabel.text = cellMap["estimated_distance"] as? String
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
            
            let userLogoAction = UITapGestureRecognizer(target:self,action:#selector(userMsgDetail(recognizer :)))
            cell.userLogoImage.addGestureRecognizer(userLogoAction)
            cell.userLogoImage.isUserInteractionEnabled = true
            cell.userLogoImage.accessibilityValue = cellMap["user_id"] as? String
            
            let phoneAction = UITapGestureRecognizer(target:self,action:#selector(cellPhone(recognizer :)))
            cell.phoneImage.addGestureRecognizer(phoneAction)
            cell.phoneImage.isUserInteractionEnabled = true
            cell.phoneImage.accessibilityValue = cellMap["con_phone"] as? String
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionMap:Dictionary<String,Any> = self.dataAtrr[indexPath.section] as! [String:Any]
        let cellArray = sectionMap["match_cargos"] as! NSArray
        let cellMap = cellArray[indexPath.row-1] as! [String:Any]
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "emptyCarTransportDetail") as! EmptyCarTransportDetail
        vc.transportId = cellMap["cargo_id"] as? String
        self.present(vc, animated: true, completion: nil)
    }
    
}
