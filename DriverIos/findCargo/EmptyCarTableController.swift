//
//  EmptyCarTableController.swift
//  DriverIos
//
//  Created by my on 2016/12/22.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarTableController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let  a = [["a":"123","b":["123","12321"]],["a":"123123","b":["123","12312","12312312"]]]
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
            delay(1.5, closure: {
                //                self?.models = (self?.models.map({_ in Int(arc4random()%100)}))!
                self?.emptyCarTableView.reloadData()
                self?.emptyCarTableView.endHeaderRefreshing()
            })
        }
        self.emptyCarTableView.beginHeaderRefreshing()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return a.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rowDict = a[section] as NSDictionary
//        cell.myLabel.text = rowDict["name"] as? String
        let rowData = rowDict["b"] as! NSArray
        return rowData.count+1
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
            return cell
        }else{
            let cell:FindCargoCell! = tableView.dequeueReusableCell(withIdentifier: "findCargoCell", for: indexPath) as? FindCargoCell
            
            // Configure the cell...
            
            return cell
        }
    }

}
