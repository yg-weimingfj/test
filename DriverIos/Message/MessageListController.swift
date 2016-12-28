//
//  MessageListController.swift
//  DriverIos
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class MessageListController: UIViewController {

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func itemChangedLisener(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            pageViewController.setViewControllers([leftController], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        case 1:
            pageViewController.setViewControllers([rightController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBOutlet weak var msgTypeTab: UISegmentedControl!
    @IBOutlet weak var viewCon: UIView!
    
    private var pageViewController: UIPageViewController!
    var leftController: MessageListLeftController!
    var rightController: MessageListRightController!
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    /**
     * 初始化
     */
    func initData() {
        //获取到嵌入的UIPageViewController
        pageViewController = self.childViewControllers.first as! UIPageViewController
        
        let sb = UIStoryboard(name: "Message", bundle:nil)
        
        leftController = sb.instantiateViewController(withIdentifier: "messageListLiftController") as! MessageListLeftController
        rightController = sb.instantiateViewController(withIdentifier: "messageListRightController") as! MessageListRightController
        //设置pageViewController的数据源代理为当前Controller
        pageViewController.dataSource = self
        
        //手动为pageViewController提供提一个页面
        pageViewController.setViewControllers([leftController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(currentPageChanged(notification:)), name: NSNotification.Name(rawValue: "messageListChanged"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentPageChanged(notification: NSNotification) {
        self.msgTypeTab.selectedSegmentIndex = notification.object as! Int
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
extension MessageListController: UIPageViewControllerDataSource {
    
    //返回当前页面的下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: MessageListLeftController.self) {
            //            self.waybillTab.selectedSegmentIndex = 0
            return rightController
        }
        return nil
        
    }
    
    //返回当前页面的上一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: MessageListRightController.self) {
            //            self.waybillTab.selectedSegmentIndex = 1
            return leftController
        }
        return nil
    }
}
