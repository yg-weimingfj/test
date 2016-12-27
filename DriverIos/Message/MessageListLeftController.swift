//
//  MessageListLiftController.swift
//  DriverIos
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class MessageListLeftController: UITableViewController {

    
    
    let cellId = "messageListItemCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    /**
     * 初始化
     */
    func initData() {
        let xib = UINib(nibName: "MessageListItemCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(xib, forCellReuseIdentifier: cellId)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        let curveHeader = CurveRefreshHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        _ = self.tableView.setUpHeaderRefresh(curveHeader) { [weak self] in
            delay(1.5, closure: {
                //                self?.models = (self?.models.map({_ in Int(arc4random()%100)}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(delay: 0.5)
            })
        }
    }
    /**
     * 跳转到消息详情
     */
    func gotoMessageInfo() {
        let sb = UIStoryboard(name: "Message", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "messageInfoController") as! MessageInfoController
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageListChanged"), object: 0)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! MessageListItemCell
        if(indexPath.row == 0){
            cell.viewNormalMsg.isHidden = true
            cell.viewSystemMsg.isHidden = false
        }else{
            cell.viewNormalMsg.isHidden = false
            cell.viewSystemMsg.isHidden = true
        }
        let takeAccountUI = UITapGestureRecognizer(target: self, action: #selector(gotoMessageInfo))
        cell.viewNormalMsg.addGestureRecognizer(takeAccountUI)
        cell.viewNormalMsg.isUserInteractionEnabled = true
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
