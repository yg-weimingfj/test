//
//  HomeController.swift
//  carriers
//
//  Created by my on 2016/12/4.
//  Copyright © 2016年 yange. All rights reserved.
//

import UIKit

class HomeController: UIViewController,SliderGalleryControllerDelegate,UIScrollViewDelegate{

    @IBOutlet weak var auditView: UIView!
    
    @IBOutlet weak var emptyCarView: UIView!
    
    @IBOutlet weak var offenRunView: UIView!
    
    @IBOutlet weak var myWalletView: UIView!
    
    @IBOutlet weak var myWalletPageView: UIView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var menuScrollView: UIScrollView!
    var codeResult:LBXScanResult?
    
  
    @IBAction func homeScanner(_ sender: Any) {
        
    }
    
    var menu1 : UIView?

    //获取屏幕宽度
    let screenWidth =  UIScreen.main.bounds.size.width
    
    //图片轮播组件
    var sliderGallery : SliderGalleryController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        auditView.layer.masksToBounds = true
        auditView.layer.cornerRadius = 10
        
        emptyCarView.layer.masksToBounds = true
        emptyCarView.layer.cornerRadius = 10
        
        offenRunView.layer.masksToBounds = true
        offenRunView.layer.cornerRadius = 10
        
        myWalletView.layer.masksToBounds = true
        myWalletView.layer.cornerRadius = 10
        
        myWalletPageView.layer.masksToBounds = true
        myWalletPageView.layer.cornerRadius = 10
        
        messageView.layer.masksToBounds = true
        messageView.layer.cornerRadius = 10
        
        helpView.layer.masksToBounds = true
        helpView.layer.cornerRadius = 10
        
        //初始化图片轮播组件
        sliderGallery = SliderGalleryController()
        sliderGallery.delegate = self
        sliderGallery.view.frame = CGRect(x: 0, y: 64, width: screenWidth,
                                          height: 160);
        
        //将图片轮播组件添加到当前视图
        self.addChildViewController(sliderGallery)
        self.view.addSubview(sliderGallery.view)
        
        //添加组件的点击事件
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(HomeController.handleTapAction(_:)))
        sliderGallery.view.addGestureRecognizer(tap)
//        print("\("码的类型:" + (codeResult?.strBarCodeType)!+"==="+"码的内容:" + (codeResult?.strScanned)!)")
        
        registerData()

    }
    
    //图片轮播组件协议方法：获取内部scrollView尺寸
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width: screenWidth, height: 160)
    }
    
    //图片轮播组件协议方法：获取数据集合
    func galleryDataSource() -> [String] {
        return ["http://bizhi.zhuoku.com/bizhi2008/0516/3d/3d_desktop_13.jpg",
                "http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
                "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
                "http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg",
                "http://bizhi.zhuoku.com/wall/jie/20061124/cartoon2/cartoon014.jpg"]
    }
    
    //点击事件响应
    func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
//       SliderGalleryControllerDelegate.resetImageViewSource()
        sliderGallery.resetImageViewSource()
    }
    @IBAction func QRcode(_ sender: UIBarButtonItem) {
        weixinStyle()
    }
    //MARK: ---无边框，内嵌4个角------
    func weixinStyle()
    {
        
        
        let sb = UIStoryboard(name: "MyQRCode", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "myQRCodeNavigationController") as! MyQRCodeNavigationController
                self.present(vc, animated: true, completion: nil)
    }
    /**
     * 加载数据
     */
    func registerData() {
        
        let myAccountUI = UITapGestureRecognizer(target: self, action: #selector(gotoMyAccount))
        myWalletPageView.addGestureRecognizer(myAccountUI)
        myWalletPageView.isUserInteractionEnabled = true
        
        let messageListUI = UITapGestureRecognizer(target: self, action: #selector(gotoMessageList))
        messageView.addGestureRecognizer(messageListUI)
        messageView.isUserInteractionEnabled = true
        
        let usedLineUI = UITapGestureRecognizer(target: self, action: #selector(gotoUsedLine))
        offenRunView.addGestureRecognizer(usedLineUI)
        offenRunView.isUserInteractionEnabled = true
        
        let auditViewUI = UITapGestureRecognizer(target: self, action: #selector(gotoAuth))
        auditView.addGestureRecognizer(auditViewUI)
        auditView.isUserInteractionEnabled = true
    }
    /**
     * 跳转到我的记账页面
     */
    func gotoMyAccount() {
        let sb = UIStoryboard(name: "OrderAccount", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "orderAccountController") as! OrderAccountController
        self.present(vc, animated: true, completion: nil)
    }
    /**
     * 跳转到消息列表页面
     */
    func gotoMessageList() {
        let sb = UIStoryboard(name: "Message", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "messageListController") as! MessageListController
        self.present(vc, animated: true, completion: nil)
    }
    /**
     * 跳转到认证页面
     */
    func gotoAuth() {
        let sb = UIStoryboard(name: "Authenticate", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "authenticateController") as! AuthenticateController
        self.present(vc, animated: true, completion: nil)
    }
    /**
     * 跳转到常跑路线页面
     */
    func gotoUsedLine() {
        let sb = UIStoryboard(name: "UsedLine", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "usedLineController") as! UsedLineController
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
