//
//  UnderWayTableViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/12.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class UnderWayTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var UITable: UITableView!
    var models = [1,2,3,4,5,6,7,8,9,10]
    let cellId = "waybillCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xib = UINib(nibName: "WaybillCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.UITable.register(xib, forCellReuseIdentifier: cellId)
        
        self.UITable.separatorInset = UIEdgeInsets.zero
        
        self.UITable.tableFooterView = UIView(frame: CGRect.zero)
        
        let curveHeader = CurveRefreshHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        _ = self.UITable.setUpHeaderRefresh(curveHeader) { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in Int(arc4random()%100)}))!
                self?.UITable.reloadData()
                self?.UITable.endHeaderRefreshing(delay: 0.5)
            })
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 0)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148.0-42
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
 
        var cell = tableView.dequeueReusableCell(withIdentifier: "uncell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "uncell")
        }
        cell?.textLabel?.text = "\(models[(indexPath as NSIndexPath).row])"
 */
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! WaybillCell
        cell.WaybillBottomView.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
    }
}
