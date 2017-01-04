//
//  EditEmtpyCarRecordView.swift
//  DriverIos
//  空车编辑列表
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EditEmtpyCarRecordView: UIViewController {
    
    var emptyId : String! = ""
    
    private let  defaulthttp = DefaultHttp()
    
    private var token = "D681CD4B984048C6B8FE785F82FD9ADA"
    
    var editEmptyTable : EditEmptyCarRecordTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteEmptyCar(_ sender: Any) {
        if(emptyId == nil || emptyId.isEmpty){
            alertMsg(st: "请选中一条空车记录")
        }else{
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            
            let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.idlevechile.delete","time":strNowTime,"report_id":emptyId]
            
            defaulthttp.httopost(parame: des){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                       self.editEmptyTable.viewDidLoad()
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.alertMsg(st: info)
                    }
                }
                print("JSON: \(results)")
            }
        }
    }
    private func alertMsg(st:String){
        let alertController = UIAlertController(title: st,message: nil, preferredStyle: .alert)
        
        let timeAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(timeAction)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        editEmptyTable=segue.destination as! EditEmptyCarRecordTableView

        //segue 在sb 中的传值
        
        editEmptyTable.valueChange = {(emptyId:String) in
            self.emptyId = emptyId
        }
    }
}
