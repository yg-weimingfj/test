//
//  EmptyCarCargoTable.swift
//  DriverIos
//
//  Created by my on 2016/12/29.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarCargoTable: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        allCargoSelect()
        let xib = UINib(nibName: "FindCargoCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        
        self.tableView.register(xib, forCellReuseIdentifier: "findCargoCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            delay(1.5, closure: {
                //                self?.models = (self?.models.map({_ in Int(arc4random()%100)}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing()
            })
        }
        self.tableView.beginHeaderRefreshing()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findCargoCell", for: indexPath) as! FindCargoCell
//        let userLogoAction = UITapGestureRecognizer(target:self,action:#selector(userMsgDetail))
//        cell.userLogoImage.addGestureRecognizer(userLogoAction)
//        cell.userLogoImage.isUserInteractionEnabled = true
        //        let messageListUI = UITapGestureRecognizer(target: self, action: #selector(messageListLinener))
        //        messageList.addGestureRecognizer(messageListUI)
        //        messageList.isUserInteractionEnabled = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "emptyCarTransportDetail") as! EmptyCarTransportDetail
        self.present(vc, animated: true, completion: nil)
    }
}
