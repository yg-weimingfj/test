//
//  findCargoViewController.swift
//  DriverIos
//
//  Created by my on 2016/12/12.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class findCargoViewController: UIViewController  {
    
    var srollerView = 0
    let contentHeight = 125
    let viewHeight = 137
    let viewMarginHeight = 127
    
    @IBOutlet weak var findCargoSegmented: UISegmentedControl!
    @IBOutlet weak var findCargoSelectedView: UIView!
    var findCargoPageController : UIPageViewController!
    var findCargoController : findCargoTableViewController!
    var emptyCarTable : EmptyCarTableController!
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取到嵌入的UIPageViewController
        findCargoPageController = self.childViewControllers.first as! UIPageViewController
        
        let sb = UIStoryboard(name: "findCargoTable", bundle:nil)
        
        findCargoController = sb.instantiateViewController(withIdentifier: "findCargoTableViewController") as! findCargoTableViewController
        emptyCarTable = sb.instantiateViewController(withIdentifier: "emptyCarTableController") as! EmptyCarTableController
        //设置pageViewController的数据源代理为当前Controller
        findCargoPageController.dataSource = self
        
        //手动为pageViewController提供提一个页面
        findCargoPageController.setViewControllers([findCargoController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(findCargoPageChanged(notification:)), name: NSNotification.Name(rawValue: "findCargoPageChanged"), object: nil)
        
    }
    func findCargoPageChanged(notification: NSNotification) {
        print("aaa==\(notification.object as! Int)")
        self.findCargoSegmented.selectedSegmentIndex = notification.object as! Int
    }
    @IBAction func findCargoChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            findCargoPageController.setViewControllers([findCargoController], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        case 1:
            findCargoPageController.setViewControllers([emptyCarTable], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension findCargoViewController: UIPageViewControllerDataSource {
    
    //返回当前页面的下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: findCargoTableViewController.self) {
            //            self.waybillTab.selectedSegmentIndex = 0
            return emptyCarTable
        }
        return nil
        
    }
    
    //返回当前页面的上一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: EmptyCarTableController.self) {
            //            self.waybillTab.selectedSegmentIndex = 1
            return findCargoController
        }
        return nil
    }
}
