//
//  WaybillViewController.swift
//  DriverIos
//
//  Created by weiming on 2016/12/12.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class WaybillViewController: UIViewController {
    var pageViewController: UIPageViewController!
    var UnderController: UnderWayTableViewController!
    var CompleteController: CompleteTableViewController!
    @IBOutlet var waybillTab: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取到嵌入的UIPageViewController
        pageViewController = self.childViewControllers.first as! UIPageViewController
        
        let sb = UIStoryboard(name: "Waybill", bundle:nil)
        
        UnderController = sb.instantiateViewController(withIdentifier: "underWayTableViewController") as! UnderWayTableViewController
        CompleteController = sb.instantiateViewController(withIdentifier: "completeTableViewController") as! CompleteTableViewController
        //设置pageViewController的数据源代理为当前Controller
        pageViewController.dataSource = self
        
        //手动为pageViewController提供提一个页面
        pageViewController.setViewControllers([UnderController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(currentPageChanged(notification:)), name: NSNotification.Name(rawValue: "currentPageChanged"), object: nil)
    }
    @IBAction func waybillTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            pageViewController.setViewControllers([UnderController], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        case 1:
            pageViewController.setViewControllers([CompleteController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        default:
            break
        }
    }
    func currentPageChanged(notification: NSNotification) {
        print("aaa==\(notification.object as! Int)")
        self.waybillTab.selectedSegmentIndex = notification.object as! Int
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
extension WaybillViewController: UIPageViewControllerDataSource {
    
    //返回当前页面的下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: UnderWayTableViewController.self) {
//            self.waybillTab.selectedSegmentIndex = 0
            return CompleteController
        }
        return nil
        
    }
    
    //返回当前页面的上一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: CompleteTableViewController.self) {
//            self.waybillTab.selectedSegmentIndex = 1
            return UnderController
        }
        return nil
    }
}
