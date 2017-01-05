//
//  HomePageController.swift
//  carriers
//
//  Created by my on 2016/12/2.
//  Copyright © 2016年 yange. All rights reserved.
//

import UIKit

/// 屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// 屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
/// tabbar圆弧高度
let layerHeight: CGFloat = SCREEN_WIDTH/10-15
class HomePageController: RAMAnimatedTabBarController , AMapLocationManagerDelegate{
    lazy var locationManager = AMapLocationManager()
    var completionBlock: AMapLocatingCompletionBlock!
    let defaultLocationTimeout = 6
    let defaultReGeocodeTimeout = 3
    private var token = ""
    private let  defaulthttp = DefaultHttp()
    private var time:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
        self.delegate = self
        
        
        locationManager.pausesLocationUpdatesAutomatically = false//是否允许系统关闭
        locationManager.allowsBackgroundLocationUpdates = true//是否允许后台运行
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters//精度
        locationManager.locationTimeout = defaultLocationTimeout//超时时间
        locationManager.reGeocodeTimeout = defaultReGeocodeTimeout//超时时间
        locationManager.delegate = self
        initCompleteBlock()
        $.getObj("driverUserInfo") { (obj) -> () in
            if let obj = obj as? Student{
                print("\(obj.userId) , \(obj.name)")
                self.token = obj.token!
//                self.getLocation()
//                self.time = Timer(timeInterval: 60, target: self, selector: #selector(self.getLocation), userInfo: nil, repeats: true)
//                RunLoop.main.add(self.time!, forMode:RunLoopMode.commonModes)
            }
        }
    }
    func getLocation() {
        locationManager.requestLocation(withReGeocode: true, completionBlock: completionBlock)
    }
    func initCompleteBlock() {
        
        completionBlock = { [weak self] (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            if let error = error {
                let error = error as NSError
                NSLog("locError:{\(error.code) - \(error.localizedDescription)};")
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    return;
                }
            }
            if let location = location {
                if let regeocode = regeocode {
                    print("cc====\(regeocode)")
                }
                self?.locationPost(location: location,regeocode: regeocode!)
                print("lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)m")
                
            }
            
        }
    }
    
    private func locationPost(location:CLLocation,regeocode:AMapLocationReGeocode) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        var province = ""
        var city = ""
        var county = ""
        var addr = ""
        if regeocode.province != nil {
            province = regeocode.province!
        }
        if regeocode.city != nil {
            city = regeocode.city!
        }
        if regeocode.district != nil {
            county = regeocode.district!
        }
        if regeocode.formattedAddress != nil {
            addr = regeocode.formattedAddress!
        }
        
        
        let des : Dictionary<String,Any> = ["token":token,"method":"yunba.carrier.v1.user.location.update","time":strNowTime,"lat":String(format: "%.8f", location.coordinate.latitude),"lng":String(format: "%.8f", location.coordinate.longitude),"province":province,"city":city,"county":county,"addr":addr]
        
        defaulthttp.httpPost(parame: des){results in
            if let result:String = results["result"] as! String?{
                if result == "1"{
                   
                    
                }else{
                    
                }
            }
            print("JSON: \(results)")
            
        }
    }
    deinit {
        self.time?.invalidate()
        self.time = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension HomePageController: UITabBarControllerDelegate {
    //MARK: 在这里，代理。。如果模态到第二个控制器，必须要用到此代理
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 9 {
            let editLiveVC = TabViewController()
            //点击到第二个控制器，不选中此控制器，而是模态到此控制器
            self.present(editLiveVC, animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
    }
}

var skullCenter:CGPoint{
            return CGPoint(x:SCREEN_WIDTH/2,y:0)////获取中心点

        }
var skullRadius:CGFloat{
            return layerHeight
        }
    private struct Ratios{
        static let  skullRadiusToMouthWidth:CGFloat = 1
        static let  skullRadiusToMouthHeigh:CGFloat = 3
        static let  skullRadiusToMouthOffset:CGFloat = 3
    }
//MARK: -CustomMethod-
private extension HomePageController {
    /**
     设置tabbar UI
     */
    func setUpTabBar() {
        /// 贝塞尔曲线低tabbar的高度
        let downHeight: CGFloat = 0.2
        /// layer的宽度
        let layerLineWidth: CGFloat = 0.3
        let layer = CAShapeLayer()
        let beizer = UIBezierPath()
        let startPoint = CGPoint(x: SCREEN_WIDTH / 2 - layerHeight,  y: downHeight)
        let endPoint = CGPoint(x:SCREEN_WIDTH / 2 + layerHeight, y:downHeight)
        let  mouthWidth = skullRadius*4
        let  mouthHeigh = skullRadius*4
        let  mouthOffset = skullRadius
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y - mouthOffset, width: mouthWidth, height: mouthHeigh)

        let  mouthCurvature = 0.0

        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1)))*mouthRect.height
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY+smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY+smileOffset)
        beizer.move(to: CGPoint(x:0, y:downHeight))
        beizer.addLine(to: startPoint)
        beizer.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        beizer.addLine(to: CGPoint(x:SCREEN_WIDTH, y:downHeight))
        layer.path = beizer.cgPath
        layer.lineWidth = layerLineWidth
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.cyan.cgColor
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.layer.addSublayer(layer)
        
        //隐藏阴影线---缺一不可
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
    }
}

