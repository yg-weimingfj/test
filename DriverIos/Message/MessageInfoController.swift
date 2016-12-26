//
//  MessageInfoController.swift
//  DriverIos
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class MessageInfoController: UIViewController {

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var barTitle: UINavigationBar!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelCon: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        registerData()
    }
    /**
     * 初始化
     */
    func initData() {
        labelType.layer.borderWidth = 1;
        labelType.layer.cornerRadius = 4;
        labelType.layer.masksToBounds = true;
        labelType.textColor = UIColor.rgb(red: 254, green: 69, blue: 81)
        labelType.layer.borderColor = UIColor.rgb(red: 254, green: 69, blue: 81).cgColor
    }
    /**
     * 加载数据
     */
    func registerData() {
        labelTitle.text = "感觉四个好似供货商公司高级回收公司"
        labelCon.text = "感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素感觉四个好似供货商公司高级回收公司似乎死 u 和 v 死 u 和 i 素"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
