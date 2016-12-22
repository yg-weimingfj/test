//
//  TakeAccountController.swift
//  DriverIos
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class TakeAccountController: UIViewController {

    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tabChangeLisener(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewInCome.isHidden = false
            viewCost.isHidden = true
        case 1:
            viewInCome.isHidden = true
            viewCost.isHidden = false
        default:
            break
        }

    }
    //收入
    @IBAction func btnSaveLisener(_ sender: UIButton) {
        print("in********")
    }
    @IBOutlet weak var viewInCome: UIView!//收入
    @IBOutlet weak var textCash: UITextField!//收入现金
    @IBOutlet weak var textOilCard: UITextField!//收入油卡
    @IBOutlet weak var textRemark: UITextField!//收入备注
    @IBOutlet weak var btnSave: UIButton!//保存
    //支出
    @IBOutlet weak var viewCost: UIView!//支出
    @IBOutlet weak var textOutCash: UITextField!//支出现金
    @IBOutlet weak var labelOilFee: UILabel!//支出类型--加油费
    @IBOutlet weak var labelPassFee: UILabel!//支出类型--过路费
    @IBOutlet weak var labelEatFee: UILabel!//支出类型--食宿
    @IBOutlet weak var labelFine: UILabel!//支出类型--罚款
    @IBOutlet weak var labelOther: UILabel!//支出类型--其他
    @IBAction func btnSaveOutlisener(_ sender: AnyObject) {
        print("out********")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    /**
     * 初始化
     */
    func initData() {
        btnSave.layer.cornerRadius = 6
//        labelOilFee.backgroundColor = UIColor.rgb;
//        labelOilFee.layer.borderColor = [[UIColor grayColor]CGColor];
//        labelOilFee.layer.borderWidth = 0.5f;
//        labelOilFee.layer.masksToBounds = YES;
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
