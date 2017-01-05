//
//  UnderDetailsViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class UnderDetailsViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    var orderId:String = ""

    private let  defaulthttp = DefaultHttp()
    @IBOutlet var serviceButton: UIButton!
    @IBOutlet weak var NavigationBar: UINavigationBar!
    @IBOutlet var QRImage: UIImageView!
    @IBOutlet var QRLabel: UILabel!
    @IBOutlet var detailsDistance: UILabel!
    @IBOutlet var PlaceOfDeparture: UILabel!
    @IBOutlet var Destination: UILabel!
    @IBOutlet var waybillCode: UILabel!
    @IBOutlet var waybillTime: UILabel!
    @IBOutlet var carType: UILabel!
    @IBOutlet var carLength: UILabel!
    @IBOutlet var goodsType: UILabel!
    @IBOutlet var goodsWeight: UILabel!
    @IBOutlet var HeadPortrait: UIImageView!
    @IBOutlet var shipperName: UILabel!
    @IBOutlet var callPhone: UIImageView!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyAddress: UILabel!
    @IBOutlet var receiptImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var detailsScroll: UIScrollView!
    private var areamap:Dictionary<String,Any> = [:]
    private var tel = ""
    private var token = ""
    var strNowTime = ""
    var imagePickerController:UIImagePickerController!
    var uploadAlertController:UIAlertController!
    private var receiptUrl = ""{
        willSet{
            if newValue != ""{
                serviceButton.backgroundColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1)
                serviceButton.isEnabled = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsScroll.isHidden = true
        serviceButton.layer.masksToBounds = true
        serviceButton.layer.cornerRadius = 5

        serviceButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        serviceButton.isEnabled = false
        print("orserid------\(orderId)")

        // Do any additional setup after loading the view.
        
        carType.layer.masksToBounds = true
        carType.layer.cornerRadius = 10
        
        carType.layer.borderWidth = 1
        carType.layer.borderColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1).cgColor
        
        goodsType.layer.masksToBounds = true
        goodsType.layer.cornerRadius = 10
        
        goodsType.layer.borderWidth = 1

        goodsType.layer.borderColor = UIColor(red: 255/255, green: 192/255, blue: 0/255, alpha: 1).cgColor
        
        initAlertController()
        initImagePickerController()
        
        let CellUI = UITapGestureRecognizer(target: self, action: #selector(cellPhone))
        callPhone.addGestureRecognizer(CellUI)
        callPhone.isUserInteractionEnabled = true
        
        let receiptOpen = UITapGestureRecognizer(target: self, action: #selector(presentUpload))
        receiptImage.addGestureRecognizer(receiptOpen)
        receiptImage.isUserInteractionEnabled = true
        
        activityIndicator.startAnimating()
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
                self.WaybillInfo()
            }
        }
        getAreaData()
        
    }
    @IBAction func serviceButton(_ sender: UIButton) {
        wallbillReach()
        
    }
    private func wallbillReach(){
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.order.finish","time":strNowTime,"order_id":orderId]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    self.serviceButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                    self.serviceButton.isEnabled = false
                    self.receiptImage.isUserInteractionEnabled = false
                    
                }else{
                    //                    let info:String = results["resultInfo"] as! String!
                }
            }
            print("JSON: \(results)")
            
        }

    }
    private func getAreaData(){
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        for dict in resultDataArr! {
            areamap[dict["CODE"] as! String] = dict
        }
    }

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func WaybillInfo() {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        strNowTime = timeFormatter.string(from: date) as String
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.order.get","time":strNowTime,"order_id":orderId]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                if result == "1"{
                    let obj = results["resultObj"]  as! [String:Any]
                    self.detailsScroll.isHidden = false
                    self.detailsInfo(obj: obj)
                    
                }else{
//                    let info:String = results["resultInfo"] as! String!
                }
            }
            print("JSON: \(results)")
            
        }
    }
    private func detailsInfo(obj:Dictionary<String,Any>){
        let placeMap = areamap[obj["s_code"] as! String!] as! [String:AnyObject]?
        let DestinationMap = areamap[obj["t_code"] as! String!] as! [String:AnyObject]?
        
        
        if placeMap != nil{
            PlaceOfDeparture.text = placeMap!["TEXT"] as! String?
            Destination.text = DestinationMap!["TEXT"] as! String?
        }
        detailsDistance.text = obj["estimated_distance"] as! String?
        waybillCode.text = obj["order_no"] as! String?
        waybillTime.text = obj["post_time"] as! String?
        carType.text = obj["vehicle_type"] as! String?
        carLength.text = obj["vehicle_length"] as! String?
        goodsType.text = obj["cargo_type"] as! String?
        goodsWeight.text = (obj["cargo_size"] as! String) + (obj["cargo_unit"] as! String)
        shipperName.text = obj["shipper_name"] as! String?
        companyName.text = obj["company_name"] as! String?
        companyAddress.text = obj["company_address"] as! String?
        let qrText = obj["order_no"] as! String!
        let qrImg = LBXScanWrapper.createCode128(codeString: qrText! , size: QRImage.bounds.size, qrColor: UIColor.black, bkColor: UIColor.white)
        
        
        QRImage.image = qrImg
        QRLabel.text = qrText
        if obj["consignor_ phone"] != nil{
            tel = obj["consignor_ phone"] as! String
        }
        
//        HeadPortrait//头像
//        receiptImage／／回单图片
    }
    func uploadingImage(image:UIImage){
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.common.v1.upload.image.file","imgname":".png","time":strNowTime]
        defaulthttp.httpPostImage(parame: des, image: image){ results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                    let obj = results["resultObj"]  as! String
                    print("resultObj==\(obj)")
                    self.receiptUrl = obj
                }else{
                    //                    let info:String = results["resultInfo"] as! String!
                }
            }
            print("JSON: \(results)")

        }
    }
    func cellPhone() {
        if #available(iOS 10, *) {
            print("跳转电话界面")
            UIApplication.shared.open(URL(string: "tel://"+tel)!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(URL(string: "tel://"+tel)!)
        }
        
    }
    func presentUpload() {
        present(self.uploadAlertController, animated:true, completion: nil)
    }
    func initAlertController()
    {
        weak var blockSelf = self
        self.uploadAlertController = UIAlertController(title:nil, message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        let takePhoto = UIAlertAction(title:"拍照", style:UIAlertActionStyle.default) { (action:UIAlertAction)in
            blockSelf?.actionAction(action: action)
        }
        let photoLib = UIAlertAction(title:"从相册选择", style:UIAlertActionStyle.default) { (action:UIAlertAction)in
            blockSelf?.actionAction(action: action)
        }
        let cancel = UIAlertAction(title:"取消", style:UIAlertActionStyle.cancel) { (action:UIAlertAction)in
            blockSelf?.actionAction(action: action)
        }
        self.uploadAlertController?.addAction(takePhoto)
        self.uploadAlertController?.addAction(photoLib)
        self.uploadAlertController?.addAction(cancel)
    }
    func actionAction(action:UIAlertAction)
    {
        if action.title == "拍照" {
            self.getImageFromPhotoLib(type:.camera)
        }else if action.title == "从相册选择"{
            self.getImageFromPhotoLib(type:.photoLibrary)
        }
         
    }
    func initImagePickerController()
    {
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        // 设置是否可以管理已经存在的图片或者视频
        self.imagePickerController.allowsEditing = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getImageFromPhotoLib(type:UIImagePickerControllerSourceType)
    {
        self.imagePickerController.sourceType = type
        //判断是否支持相册
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(self.imagePickerController, animated: true, completion:nil)
        }
    }
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]){
        
        let type:String = (info[UIImagePickerControllerMediaType] as! String)
        //当选择的类型是图片
        if type=="public.image"
        {
            let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.receiptImage.image = img
            uploadingImage(image: img!)
            picker.dismiss(animated:true, completion:nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
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
