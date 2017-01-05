//
//  EmptyCarListViewController.swift
//  DriverIos
//  空车列表
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarListViewController: UIViewController {
    fileprivate var models = [Any]()
    
    private let  defaulthttp = DefaultHttp()
    private var token = "D681CD4B984048C6B8FE785F82FD9ADA"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyCargoInfo(ustoken:(self.token))
        tableView.delegate = self
        tableView.dataSource = self
        let buttonXib  = UINib(nibName : "EmptyCarUpload",bundle: nil)
        self.tableView.register(buttonXib,forCellReuseIdentifier: "emptyCarUpload")
        
        let xib = UINib(nibName: "EmptyCarRecordCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(xib, forCellReuseIdentifier: "emptyCarRecordCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            self?.emptyCargoInfo(ustoken:(self?.token)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadEmptyCarRecordList(_ sender: Any) {
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "emptyCarUploadRecordList") as! EmptyCarUploadRecordList
        self.present(vc, animated: true, completion: nil)
    }
    func UploadEmptyCar() {
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "emptyCarUpload") as! EmptyCarController
        vc.parentController = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func emptyCargoInfo(ustoken:String){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.idlevechiles.list.get","time":strNowTime]
        defaulthttp.httopost(parame: des){results in
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
    

}
extension EmptyCarListViewController : UITableViewDataSource,UITableViewDelegate{
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count+1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == models.count){
            return 114
        }else{
          return 44
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == models.count){
            let cell = tableView.dequeueReusableCell(withIdentifier:"emptyCarUpload",for: indexPath) as! EmptyCarUpload
            cell.uploadButton.addTarget(self,action:#selector(EmptyCarListViewController.UploadEmptyCar),for:UIControlEvents.touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCarRecordCell", for: indexPath) as! EmptyCarRecordCell
            let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
            cell.sourceAreaLabel.text = cellMap["from_place"] as! String?
            cell.sourceAreaLabel.sizeToFit()
            var fromIamgeFrame = cell.fromImageView.frame
            fromIamgeFrame.origin.x = cell.sourceAreaLabel.frame.size.width + 15
            cell.fromImageView.frame = fromIamgeFrame
            var destAreaFrame = cell.destAreaLabel.frame
            destAreaFrame.origin.x = fromIamgeFrame.origin.x + fromIamgeFrame.size.width + 5
            cell.destAreaLabel.frame = destAreaFrame
            cell.destAreaLabel.text = cellMap["to_place"] as! String?
            cell.destAreaLabel.sizeToFit()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != models.count){
            let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
            tableView.deselectRow(at: indexPath, animated: true)
            let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "emptyCarTableListView") as! EmptyCarTableListView
            vc.sourceAreaCode = cellMap["place_from_code"] as! String?
            vc.destAreaCode = cellMap["place_to_code"] as! String?
            vc.sourceAreaValue = cellMap["from_place"] as! String?
            vc.destAreaValue = cellMap["to_place"] as! String?
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
