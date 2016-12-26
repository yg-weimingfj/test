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
        btnSure.setTitle("确定", for: UIControlState.normal)
        viewPersonalAuth.isHidden = true
        viewCarAuth.isHidden = false
    }
    @IBOutlet weak var viewPersonalAuth: UIView!
    @IBOutlet weak var viewCarAuth: UIView!
    @IBOutlet weak var textIDCard: UITextField!
    @IBOutlet weak var imageIDCard: UIImageView!
    @IBOutlet weak var imageHead: UIImageView!
    @IBOutlet weak var btnSure: UIButton!
    
    var imagePicker: UIImagePickerController!
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
        btnSure.layer.cornerRadius = 6
        let imageIDCardUI = UITapGestureRecognizer(target: self, action: #selector(takePhoto))
        imageIDCard.addGestureRecognizer(imageIDCardUI)
        imageIDCard.isUserInteractionEnabled = true
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
