//
//  EmptyCarTableListView.swift
//  DriverIos
//
//  Created by my on 2016/12/29.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarTableListView: UIViewController {

    @IBOutlet weak var emptyTimeSegmented: UISegmentedControl!
    @IBOutlet weak var tableListNavigationBar: UINavigationBar!
    var emptyCarCargoPageController : UIPageViewController!
    var todayCargoController : EmptyCarCargoTable!
    var oneDayCargoController : EmptyCarCargoTable!
    var twoDayCargoController : EmptyCarCargoTable!
    var threeDayCargoController: EmptyCarCargoTable!
    var fourDayCargoController: EmptyCarCargoTable!
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取到嵌入的UIPageViewController
        emptyCarCargoPageController = self.childViewControllers.first as! UIPageViewController
        
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        
        todayCargoController = sb.instantiateViewController(withIdentifier: "emptyCarCargoTable") as! EmptyCarCargoTable
        oneDayCargoController = sb.instantiateViewController(withIdentifier: "emptyCarCargoTable") as! EmptyCarCargoTable
        twoDayCargoController = sb.instantiateViewController(withIdentifier: "emptyCarCargoTable") as! EmptyCarCargoTable
        threeDayCargoController = sb.instantiateViewController(withIdentifier: "emptyCarCargoTable") as! EmptyCarCargoTable
        fourDayCargoController = sb.instantiateViewController(withIdentifier: "emptyCarCargoTable") as! EmptyCarCargoTable
        todayCargoController.index = 0
        oneDayCargoController.index = 1
        twoDayCargoController.index = 2
        threeDayCargoController.index = 3
        fourDayCargoController.index = 4
        //设置pageViewController的数据源代理为当前Controller
        emptyCarCargoPageController.dataSource = self
        
        //手动为pageViewController提供提一个页面
        emptyCarCargoPageController.setViewControllers([todayCargoController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(emptyCarPageChange(notification:)), name: NSNotification.Name(rawValue: "emptyCarPageChange"), object: nil)
    }
    func emptyCarPageChange(notification: NSNotification) {
        print("aaa==\(notification.object as! Int)")
        self.emptyTimeSegmented.selectedSegmentIndex = notification.object as! Int
    }
    @IBAction func emptyCarChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            emptyCarCargoPageController.setViewControllers([todayCargoController], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        case 1:
            emptyCarCargoPageController.setViewControllers([oneDayCargoController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        case 2:
            emptyCarCargoPageController.setViewControllers([twoDayCargoController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        case 3:
            emptyCarCargoPageController.setViewControllers([threeDayCargoController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        case 4:
            emptyCarCargoPageController.setViewControllers([fourDayCargoController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

   
}
extension EmptyCarTableListView : UIPageViewControllerDataSource{
    //返回当前页面的下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if self.emptyTimeSegmented.selectedSegmentIndex == 0 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return oneDayCargoController
        }
        if self.emptyTimeSegmented.selectedSegmentIndex == 1 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return twoDayCargoController
        }
        if self.emptyTimeSegmented.selectedSegmentIndex == 2 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return threeDayCargoController
        }
        if self.emptyTimeSegmented.selectedSegmentIndex == 3 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return fourDayCargoController
        }
        return nil
        
    }
    
    //返回当前页面的上一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if self.emptyTimeSegmented.selectedSegmentIndex == 1 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return todayCargoController
        }
        if self.emptyTimeSegmented.selectedSegmentIndex == 2 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return oneDayCargoController
        }
        if self.emptyTimeSegmented.selectedSegmentIndex == 3 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return twoDayCargoController
        }
        if self.emptyTimeSegmented.selectedSegmentIndex == 4 {
            //            self.waybillTab.selectedSegmentIndex = 0
            return threeDayCargoController
        }
        return nil
    }
}
