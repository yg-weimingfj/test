//
//  AuthenticateController.swift
//  DriverIos
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class AuthenticateController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSureLisener(_ sender: UIButton) {
        if(btnSure.tag == 0){
            btnSure.tag = 1
            btnSure.setTitle("确定", for: UIControlState.normal)
            viewPersonalAuth.isHidden = true
            viewCarAuth.isHidden = false
        }else{
            auth()
        }
    }
    @IBOutlet weak var viewPersonalAuth: UIView!//实名认证
    @IBOutlet weak var viewCarAuth: UIView!//车辆认证
    @IBOutlet weak var textIDCard: UITextField!//身份证号
    @IBOutlet weak var imageIDCard: UIImageView!//身份证照片
    @IBOutlet weak var imageHead: UIImageView!//头像照片
    @IBOutlet weak var btnSure: UIButton!//确认按钮
    
    private var imagePicker: UIImagePickerController!
    private var token = ""
    private var idCardImg = ""
    private var headImg = ""
    private var carImg = ""
    private let defaulthttp = DefaultHttp()
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     * 初始化
     */
    func initData() {
        btnSure.tag = 0
        btnSure.layer.cornerRadius = 6
        let imageIDCardUI = UITapGestureRecognizer(target: self, action: #selector(takePhoto))
        imageIDCard.addGestureRecognizer(imageIDCardUI)
        imageIDCard.isUserInteractionEnabled = true
        
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                self.token = obj.token!
            }
        }
    }
    func takePhoto() {
        // 先要判断相机是否可用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("can't find camera")
        }
    }
    /**
     * 认证
     */
    func auth() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let idNo = textIDCard.text! as String
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.user.auth.update","time":strNowTime,"id_no":idNo,"verification_avatar":headImg,"id_photo":idCardImg,"driver_license_photo":carImg]
        
        defaulthttp.httopost(parame: params){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.hint(hintCon: "申请成功")
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
        self.textIDCard.resignFirstResponder()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageIDCard.image = image // 保存拍摄（编辑）后的图片到我们的imageView展示
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // 将图片保存到相册
        picker.dismiss(animated: true, completion: nil) // 退出相机界面
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
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
