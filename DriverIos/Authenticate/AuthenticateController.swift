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
            authName()
        }else{
            auth()
        }
    }
    @IBOutlet weak var viewPersonalAuth: UIView!//实名认证
    @IBOutlet weak var viewCarAuth: UIView!//车辆认证
    @IBOutlet weak var textIDCard: UITextField!//身份证号
    @IBOutlet weak var imageIDCard: UIImageView!//身份证照片
    @IBOutlet weak var imageHead: UIImageView!//头像照片
    @IBOutlet weak var imageCar: UIImageView!//车辆照片
    @IBOutlet weak var btnSure: UIButton!//确认按钮
    
    private var imagePicker: UIImagePickerController!//相机
    private var photoPicker: UIImagePickerController!//相册
    private var token = ""
    private var idCardImg = ""
    private var headImg = ""
    private var carImg = ""
    private var imageType = "iDCard"//图片类型，默认身份证
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
        
        let imageIDCardUI = UITapGestureRecognizer(target: self, action: #selector(idCardPopupView))
        imageIDCard.addGestureRecognizer(imageIDCardUI)
        imageIDCard.isUserInteractionEnabled = true
        
        let imageHeadUI = UITapGestureRecognizer(target: self, action: #selector(headPopupView))
        imageHead.addGestureRecognizer(imageHeadUI)
        imageHead.isUserInteractionEnabled = true
        
        let imageCarUI = UITapGestureRecognizer(target: self, action: #selector(carPopupView))
        imageCar.addGestureRecognizer(imageCarUI)
        imageCar.isUserInteractionEnabled = true
        
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
    func selectPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            photoPicker =  UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            self.present(photoPicker, animated: true, completion: nil)
        } else {
            print("can't find camera")
        }
    }
    /**
     * 实名认证
     */
    func authName() {
        if(textIDCard.text?.isEmpty)!{
            self.hint(hintCon: "请输入身份证号")
        }else if(idCardImg.isEmpty){
            self.hint(hintCon: "请选择身份证照片")
        }else if(headImg.isEmpty){
            self.hint(hintCon: "请选择头像照片")
        }else{
            btnSure.tag = 1
            btnSure.setTitle("确定", for: UIControlState.normal)
            viewPersonalAuth.isHidden = true
            viewCarAuth.isHidden = false
        }
    }
    /**
     * 上传图片
     */
    func upLoadImage(imgPath: String) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        let params : Dictionary<String,Any> = ["token":token,"method":"yunba.common.v1.upload.image.base64","time":strNowTime,"imgname":imageType]
        
        defaulthttp.httpPostImage(parame: params,image:UIImage(named: imgPath)!){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.hint(hintCon: "图片上传成功")
                    if(self.imageType == "iDCard"){
                        self.idCardImg = (results["resultObj"] as! String?)!
                    }else if(self.imageType == "head"){
                        self.headImg = (results["resultObj"] as! String?)!
                    }else if(self.imageType == "car"){
                        self.carImg = (results["resultObj"] as! String?)!
                    }
                }else{
                    let info:String = results["resultInfo"] as! String!
                    self.hint(hintCon: info)
                }
            }
            print("JSON: \(results)")
        }
    }
    /**
     * 认证
     */
    func auth() {
        if(carImg.isEmpty){
            self.hint(hintCon: "请选择车辆照片")
        }else{
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            let idNo = textIDCard.text! as String
            let params : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.user.auth.update","time":strNowTime,"id_no":idNo,"verification_avatar":headImg,"id_photo":idCardImg,"driver_license_photo":carImg]
            
            defaulthttp.httpPost(parame: params){results in
                if let result:String = results["result"] as! String?{
                    if result == "1"{
                        surePopupView(hintCon: "申请认证成功")
                    }else{
                        let info:String = results["resultInfo"] as! String!
                        self.hint(hintCon: info)
                    }
                }
                print("JSON: \(results)")
            }
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
     * 身份证拍照弹窗
     */
    func idCardPopupView(){
        imageType = "iDCard"
        var alert: UIAlertController!
//        alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert = UIAlertController()
        let cleanAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil)
        let photoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.takePhoto()
        }
        let choseAction = UIAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.selectPhoto()
        }
        
        alert.addAction(cleanAction)
        alert.addAction(photoAction)
        alert.addAction(choseAction)
        self.present(alert, animated: true, completion: nil)
    }
    /**
     * 头像拍照弹窗
     */
    func headPopupView(){
        imageType = "head"
        var alert: UIAlertController!
        //        alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert = UIAlertController()
        let cleanAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil)
        let photoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.takePhoto()
        }
        let choseAction = UIAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.selectPhoto()
        }
        
        alert.addAction(cleanAction)
        alert.addAction(photoAction)
        alert.addAction(choseAction)
        self.present(alert, animated: true, completion: nil)
    }
    /**
     * 车辆拍照弹窗
     */
    func carPopupView(){
        imageType = "car"
        var alert: UIAlertController!
        //        alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert = UIAlertController()
        let cleanAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil)
        let photoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.takePhoto()
        }
        let choseAction = UIAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.selectPhoto()
        }
        
        alert.addAction(cleanAction)
        alert.addAction(photoAction)
        alert.addAction(choseAction)
        self.present(alert, animated: true, completion: nil)
    }
    /**
     * 确认弹窗
     */
    func surePopupView(hintCon: String){
        var alert: UIAlertController!
        alert = UIAlertController(title: hintCon, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.back()
        }
        alert.addAction(sureAction)
        self.present(alert, animated: true, completion: nil)
    }
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    /**
     * 监听键盘
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textIDCard.resignFirstResponder()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        //获得照片
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        if type == "public.image"{
            if(imageType == "iDCard"){
                imageIDCard.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
            }else if(imageType == "head"){
                imageHead.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
            }else if(imageType == "car"){
                imageCar.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
            }
            //修正图片的位置
//            let image = self.fixOrientation(aImage: (info[UIImagePickerControllerOriginalImage] as! UIImage))
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            //先把图片转成NSData
            let data = UIImageJPEGRepresentation(image, 0.5)
            
            //Home目录
            let fileManager = FileManager.default
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents"
            //文件管理器
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            try! fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            fileManager.createFile(atPath: documentPath+"/image.png", contents: data, attributes: nil)
            //得到选择后沙盒中图片的完整路径
            let filePath: String = String(format: "%@%@", documentPath, "/image.png")
            upLoadImage(imgPath: filePath)
        }
        
        
    }
    
    func fixOrientation(aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation == .up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        //这里需要注意下CGImageGetBitmapInfo，它的类型是Int32的，CGImageGetBitmapInfo(aImage.CGImage).rawValue，这样写才不会报错
        let ctx: CGContext = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored: break
            // Grr...
            
//            CGContextDrawImage(ctx, CGRect(0, 0, aImage.size.height, aImage.size.width), aImage.cgImage)
        default: break
//            CGContextDrawImage(ctx, CGRect(0, 0, aImage.size.width, aImage.size.height), aImage.cgImage)
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        imageIDCard.image = image // 保存拍摄（编辑）后的图片到我们的imageView展示
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // 将图片保存到相册
//        picker.dismiss(animated: true, completion: nil) // 退出相机界面
//    }
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
