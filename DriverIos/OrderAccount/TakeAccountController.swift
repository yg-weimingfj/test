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
        accountInto()
    }
    @IBOutlet weak var viewInCome: UIView!//收入
    @IBOutlet weak var textCash: UITextField!//收入现金
    @IBOutlet weak var textOilCard: UITextField!//收入油卡
    @IBOutlet weak var textRemark: UITextField!//收入备注
    @IBOutlet weak var btnSave: UIButton!//收入--保存
    //支出
    @IBOutlet weak var viewCost: UIView!//支出
    @IBOutlet weak var textOutCash: UITextField!//支出现金
    @IBOutlet weak var labelOilFee: UILabel!//支出类型--加油费
    @IBOutlet weak var labelPassFee: UILabel!//支出类型--过路费
    @IBOutlet weak var labelEatFee: UILabel!//支出类型--食宿
    @IBOutlet weak var labelFine: UILabel!//支出类型--罚款
    @IBOutlet weak var labelOther: UILabel!//支出类型--其他
    @IBOutlet weak var btnSaveOut: UIButton!//支出
    @IBAction func btnSaveOutlisener(_ sender: AnyObject) {
        accountCost()
    }
    var orderId :String = ""
    private var labels :[UILabel] = [UILabel]()
    private var token = ""
    private var costType = ""
    private let defaulthttp = DefaultHttp()
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    
    /**
     * 初始化
     */
    func initData() {
        btnSave.layer.cornerRadius = 6
        btnSaveOut.layer.cornerRadius = 6
        labels.append(labelOilFee)
        labels.append(labelPassFee)
        labels.append(labelEatFee)
        labels.append(labelFine)
        labels.append(labelOther)
        selectItem(selectPosition: 0)
        
        
        let viewLabelOilFee = UITapGestureRecognizer(target: self, action: #selector(labelOilFeeLisener))
        labelOilFee.addGestureRecognizer(viewLabelOilFee)
        labelOilFee.isUserInteractionEnabled = true
        
        let viewLabelPassFee = UITapGestureRecognizer(target: self, action: #selector(labelPassFeeLisener))
        labelPassFee.addGestureRecognizer(viewLabelPassFee)
        labelPassFee.isUserInteractionEnabled = true
        
        let viewLabelEatFee = UITapGestureRecognizer(target: self, action: #selector(labelEatFeeLisener))
        labelEatFee.addGestureRecognizer(viewLabelEatFee)
        labelEatFee.isUserInteractionEnabled = true
        
        let viewLabelFine = UITapGestureRecognizer(target: self, action: #selector(labelFineLisener))
        labelFine.addGestureRecognizer(viewLabelFine)
        labelFine.isUserInteractionEnabled = true
        
        let viewLabelOther = UITapGestureRecognizer(target: self, action: #selector(labelOtherLisener))
        labelOther.addGestureRecognizer(viewLabelOther)
        labelOther.isUserInteractionEnabled = true
        
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.token = obj.token!
            }
        }
    }
    func labelOilFeeLisener()  {
        selectItem(selectPosition: 0)
    }
    func labelPassFeeLisener()  {
        selectItem(selectPosition: 1)
    }
    func labelEatFeeLisener()  {
        selectItem(selectPosition: 2)
    }
    func labelFineLisener()  {
        selectItem(selectPosition: 3)
    }
    func labelOtherLisener()  {
        selectItem(selectPosition: 4)
    }
    /**
     * 选中的支出类型
     */
    func selectItem(selectPosition : Int) {
        for i in 0..<labels.count {
            let label = labels[i]
            label.layer.borderWidth = 1;
            label.layer.masksToBounds = true;
            if(i == selectPosition){
                label.textColor = UIColor.rgb(red: 51, green: 145, blue: 252)
                label.layer.borderColor = UIColor.rgb(red: 51, green: 145, blue: 252).cgColor
            }else{
                label.textColor = UIColor.rgb(red: 102 , green: 102, blue: 102)
                label.layer.borderColor = UIColor.rgb(red: 102 , green: 102, blue: 102).cgColor
            }
        }
    }
    /**
     * 记一记--收入
     */
    func accountInto() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let cash = textCash.text! as String
        let oilCard = textOilCard.text! as String
        let remark = textRemark.text! as String
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.accounting.income.update","time":strNowTime,"order_id":orderId,"income_cash":cash,"income_petrol":oilCard,"income_comment":remark]
        
        defaulthttp.httopost(parame: params){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.hint(hintCon: "记账成功")
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.hint(hintCon: info)
                }
            }
            print("JSON: \(results)")
        }
    }
    /**
     * 记一记--支出
     */
    func accountCost() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let orderId = "012f3d64-e79b-4637-80bf-3fcb0b963d09"
        let cash = textOutCash.text! as String
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.accounting.expense.update","time":strNowTime,"order_id":orderId,"expense_cash":cash,"expense_type":costType]
        
        defaulthttp.httopost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.hint(hintCon: "记账成功")
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.hint(hintCon: info)
                }
            }
            print("JSON: \(results)")
        }
    }
    /**
     * 错误提示
     */
    func hint(hintCon: String){
        let alertController = UIAlertController(title: hintCon,message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //1秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    /**
     * 监听键盘
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textCash.resignFirstResponder()
        self.textOilCard.resignFirstResponder()
        self.textRemark.resignFirstResponder()
        self.textOutCash.resignFirstResponder()
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
