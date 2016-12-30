//
//  EmptyCarListViewController.swift
//  DriverIos
//
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarListViewController: UIViewController {
    let models = ["1","2","3","4"]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let buttonXib  = UINib(nibName : "EmptyCarUpload",bundle: nil)
        self.tableView.register(buttonXib,forCellReuseIdentifier: "emptyCarUpload")
        
        let xib = UINib(nibName: "EmptyCarRecordCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(xib, forCellReuseIdentifier: "emptyCarRecordCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
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
        self.present(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
            cell.sourceAreaLabel.text = "内蒙古 呼和浩特"
            cell.sourceAreaLabel.sizeToFit()
            var fromIamgeFrame = cell.fromImageView.frame
            fromIamgeFrame.origin.x = cell.sourceAreaLabel.frame.size.width + 15
            cell.fromImageView.frame = fromIamgeFrame
            var destAreaFrame = cell.destAreaLabel.frame
            destAreaFrame.origin.x = fromIamgeFrame.origin.x + fromIamgeFrame.size.width + 5
            cell.destAreaLabel.frame = destAreaFrame
            cell.destAreaLabel.text = "内蒙古 呼和浩特"
            cell.destAreaLabel.sizeToFit()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != models.count){
            tableView.deselectRow(at: indexPath, animated: true)
            let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "emptyCarTableListView") as! EmptyCarTableListView
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
