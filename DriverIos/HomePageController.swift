//
//  HomePageController.swift
//  carriers
//
//  Created by my on 2016/12/2.
//  Copyright © 2016年 yange. All rights reserved.
//

import UIKit
/// tabbar圆弧高度
let layerHeight: CGFloat = 10
/// 屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// 屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
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
        let startPoint = CGPoint(x: SCREEN_WIDTH / 2 - layerHeight * 3,  y: downHeight)
        let endPoint = CGPoint(x:SCREEN_WIDTH / 2 + layerHeight * 3, y:downHeight)
        beizer.move(to: CGPoint(x:0, y:downHeight))
        beizer.addLine(to: startPoint)
        beizer.addQuadCurve(to: endPoint, controlPoint: CGPoint(x:SCREEN_WIDTH / 2, y:-layerHeight * 2))
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
        //        let editVC = SecondViewController()
        //        editVC.initTabBarItem()
        //        editVC.view.backgroundColor = UIColor.orangeColor()
        //        editVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-6, 0, 6, 0)
        //        editVC.tabBarItem.image = UIImage(named: "tab_bar_live_hig")
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

