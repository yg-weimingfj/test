//
//  EmptyCarTableView.swift
//  DriverIos
//
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dataAttr  : Array<AnyObject> = ["1" as AnyObject]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "EmptyCarRecordCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        
        self.tableView.register(xib, forCellReuseIdentifier: "emptyCarRecordCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCarRecordCell", for: indexPath) as! EmptyCarRecordCell
        cell.sourceAreaLabel.text = "内蒙古 呼和浩特"
        cell.sourceAreaLabel.sizeToFit()
        var fromIamgeFrame = cell.fromImageView.frame
        fromIamgeFrame.origin.x = cell.sourceAreaLabel.frame.size.width + cell.sourceAreaLabel.frame.origin.x
        cell.fromImageView.frame = fromIamgeFrame
        var destAreaFrame = cell.destAreaLabel.frame
        destAreaFrame.origin.x = fromIamgeFrame.origin.x + fromIamgeFrame.size.width + 5
        cell.destAreaLabel.frame = destAreaFrame
        cell.destAreaLabel.text = "内蒙古 呼和浩特"
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
