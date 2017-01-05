//
//  EditEmptyCarRecordTableView.swift
//  DriverIos
//
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EditEmptyCarRecordTableView: UIViewController {
    
    var valueChange :((_ emptyId:String)->Void)?
    fileprivate var models = [Any]()
    private let  defaulthttp = DefaultHttp()
    private var token = "D681CD4B984048C6B8FE785F82FD9ADA"
    var checkArray : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editEmptyCarRecord(ustoken:(self.token))
        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "EditEmptyCarCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        
        self.tableView.register(xib, forCellReuseIdentifier: "editEmptyCarCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            self?.editEmptyCarRecord(ustoken:(self?.token)!)
        }
    }
    func editEmptyCarRecord(ustoken:String){
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
                    var cellList:[Any] = []
                    for map in list{
                        var cellMap:Dictionary<String,Any> = map as! [String:Any]
                        cellMap["isCheck"] = "N"
                        cellList.append(cellMap)
                    }
                    self.models = cellList
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension EditEmptyCarRecordTableView : UITableViewDelegate,UITableViewDataSource{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "editEmptyCarCell", for: indexPath) as! EditEmptyCarCell
        let cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let isCheck = (cellMap["isCheck"] as? String!)!
        if("N" == isCheck){
            cell.checkImageView.image = UIImage(named:"no_check")
        }else if("Y" == isCheck){
            cell.checkImageView.image = UIImage(named:"check")
        }
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
        let cell = tableView.cellForRow(at: indexPath) as! EditEmptyCarCell
        var cellMap:Dictionary<String,Any> = self.models[indexPath.row] as! [String:Any]
        let reportId = (cellMap["report_id"] as? String!)!
        let isCheck = cellMap["isCheck"] as? String!
        if(isCheck == "N"){
            checkArray.append(reportId!)
            cell.checkImageView.image = UIImage(named:"check")
            cellMap["isCheck"] = "Y"
        }else if(isCheck == "Y"){
            for i in 0..<checkArray.count{
                if(reportId == checkArray[i]){
                    checkArray.remove(at: i)
                    break
                }
            }
            cell.checkImageView.image = UIImage(named:"no_check")
            cellMap["isCheck"] = "N"
        }
        self.models[indexPath.row] = cellMap
        valueChange?(checkArray.joined(separator: ","))
    }
}
