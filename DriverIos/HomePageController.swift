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
class HomePageController: RAMAnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
        setControllers()
        self.delegate = self
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
//        let startPoint = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
//        let endPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
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
//    @IBInspectable
//    var scale:CGFloat = 0.90
//    @IBInspectable
//    var lineWidth:CGFloat = 1.0
//    @IBInspectable
//    var color:UIColor = UIColor.blue
//    
//    var skullRadius:CGFloat{
//        return min(bounds.size.width,bounds.size.height)/2*scale//获取原的半径为父View的一半
//    }
//    var skullCenter:CGPoint{
//        return CGPoint(x:bounds.midX,y:bounds.midY)////获取中心点
//        
//    }
//    private struct Ratios{
//        static let  skullRadiusToMouthWidth:CGFloat = 1
//        static let  skullRadiusToMouthHeigh:CGFloat = 3
//        static let  skullRadiusToMouthOffset:CGFloat = 3
//    }
//    func pathForMouth() -> UIBezierPath {
//        let  mouthWidth = skullRadius/Ratios.skullRadiusToMouthWidth
//        let  mouthHeigh = skullRadius/Ratios.skullRadiusToMouthHeigh
//        let  mouthOffset = skullRadius/Ratios.skullRadiusToMouthOffset
//        
//        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeigh)
//        
//        let  mouthCurvature = 0.0
//        
//        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1)))*mouthRect.height
//        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
//        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
//        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY+smileOffset)
//        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY+smileOffset)
//        
//        let path = UIBezierPath()
//        path.move(to: start)
//        path.lineWidth = lineWidth
//        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
//        
//        return path
//        //
//        //        return UIBezierPath(rect: mouthRect)
//        
//    }
    
    func setControllers() {
        
        //        //MARK: imageInsets 改变item图像的位置
        //        let vc1 = FirstViewController()
        //
        //        let na1 = UINavigationController(rootViewController: vc1)
        //        vc1.navigationItem.title = "一"
        //
        //        na1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        //        na1.tabBarItem.image = UIImage(named: "tab_bar_look_nor")
        //
//                let editVC = ViewController()
//                editVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-6, 0, 6, 0)
        //
        //
        //        let meVC = ThirdViewController()
        //        let meNavi = UINavigationController(rootViewController: meVC)
        //        meVC.navigationItem.title = "三"
        //        meNavi.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        //        meNavi.tabBarItem.image = UIImage(named: "tab_bar_me_nor")
        
        
        //        viewControllers = [na1, editVC, meNavi];
    }
}

