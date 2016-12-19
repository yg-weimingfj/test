//
//  findCargoViewController.swift
//  DriverIos
//
//  Created by my on 2016/12/12.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class findCargoViewController: UIViewController,DOPDropDownMenuDataSource, DOPDropDownMenuDelegate  {

    @IBOutlet weak var changeFindCargoPage: UISegmentedControl!
    let findCargoListView = UIScrollView()
    let allSorts: [String] = ["22分类","跟团游","自由行","极致日本","签证","当地玩乐"]
    let sorts = ["排序", "默认排序", "价格由低到高", "价格由高到低", "出发时间升序", "出发时间降序", "行程天数升序", "行程天数降序"]
    var sifts: [String] = ["出发地", "目的地", "线路玩法"]
    var classifys: [String] = ["美食","电影","酒店"]
    let cates: [String] = ["自助餐","快餐","火锅","日韩料理","西餐","烧烤小吃"]
    let movices: [String] = ["内地剧","港台剧","英美剧"]
    let hotels: [String] = ["经济酒店","商务酒店","连锁酒店","度假酒店","公寓酒店"]
    let imgArr: [String] = ["ic_filter_category_0", "ic_filter_category_1", "ic_filter_category_2", "ic_filter_category_3", "ic_filter_category_4", "ic_filter_category_5"]
    
    var srollerView = 0
    let contentHeight = 125
    let viewHeight = 137
    let viewMarginHeight = 127
    
//    var dopMenu : DOPDropDownMenu = DOPDropDownMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeFindCargoPage.layer.masksToBounds = true
        
        changeFindCargoPage.layer.borderWidth = 1
        changeFindCargoPage.widthForSegment(at: 0)
        changeFindCargoPage.layer.borderColor = changeFindCargoPage.tintColor.cgColor
        listScrollerView()
    }
    
    
    
    @IBAction func findCargoChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
//            dopMenu = DOPDropDownMenu(origin: CGPoint(x: 0, y: 94), height: 43)
//            dopMenu.dataSource = self
//            dopMenu.delegate = self
//            self.view.addSubview(dopMenu)
//            dopMenu.selectDefalutIndexPath()
            break

        case 1:
            break
        default:
            break
        }
    }
    //MARK:- 代理
    func numberOfColumnsInMenu(dopMenu menu: DOPDropDownMenu) -> Int {
        return 4
    }
    
    func listScrollerView(){
        
        findCargoListView.frame = self.view.bounds
        findCargoListView.isPagingEnabled = true
        findCargoListView.showsHorizontalScrollIndicator = true
        findCargoListView.showsVerticalScrollIndicator = true
        findCargoListView.scrollsToTop = true
        findCargoListView.backgroundColor = UIColor(red: 246/255 , green: 246/255, blue: 246/255, alpha: 0.5)
        
        
        findCargoListView.frame = CGRect(x: 0, y: 138, width: 375, height: 480)
        
        self.view.addSubview(findCargoListView)
        for i in 0  ..< 10  {
            srollerView = viewHeight*i
            let borderView = UIView(frame: CGRect(x: 0, y: srollerView+10, width: 375, height: viewMarginHeight))
            borderView.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 0.5)
            findCargoListView.addSubview(borderView)
            
            let contentView = UIView(frame: CGRect(x: 0, y: 1, width: 375, height: contentHeight))
            contentView.backgroundColor = UIColor.white
            borderView.addSubview(contentView)
            
            //加载标志图片
            let signImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            signImage.backgroundColor = UIColor.clear
            signImage.image = UIImage(named: "findCargo")
            borderView.addSubview(signImage)
            //加载时间
            let timeLabel = UILabel(frame: CGRect(x: 285, y: 15, width: 74, height: 17))
            timeLabel.text = "05-23 12:12"
            timeLabel.textColor = UIColor.black
            timeLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
            borderView.addSubview(timeLabel)
            //加载用户图像
            let userImage = UIImageView(frame: CGRect(x: 16, y: 27, width: 72, height: 72))
            let url = URL(string: "http://hangge.com/blog/images/logo.png")
            //从网络获取数据流
            let data = try! Data(contentsOf: url!)
            userImage.image = UIImage(data: data)
            userImage.backgroundColor  = UIColor.clear
            borderView.addSubview(userImage)
            //出发地到目的地
            let sourceLable = UILabel(frame: CGRect(x: 107, y: 24, width: 55, height: 24))
            sourceLable.text = "南京"
            sourceLable.textAlignment = NSTextAlignment.left
            sourceLable.textColor = UIColor.black
            sourceLable.font = UIFont.init(name: "PingFangSC-Regular", size: 17)
            let destLabel = UILabel(frame: CGRect(x: 249, y: 24, width: 55, height: 24))
            destLabel.textColor = UIColor.black
            destLabel.text = "桂林"
            destLabel.textAlignment = NSTextAlignment.left
            destLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 17)
            let kmLabel = UILabel(frame: CGRect(x: 162, y: 22, width: 52, height: 22))
            kmLabel.textColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 0.5)
            kmLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
            kmLabel.text = "1253公里"
            kmLabel.textAlignment = NSTextAlignment.center
            let pointImage = UIImageView(frame: CGRect(x: 162, y: 39, width: 167, height: 3))
            pointImage.backgroundColor = UIColor.clear
            pointImage.image = UIImage(named: "")
            borderView.addSubview(sourceLable)
            borderView.addSubview(destLabel)
            borderView.addSubview(kmLabel)
            borderView.addSubview(pointImage)
            //电话标志
            let photoImage = UIImageView(frame:CGRect(x: 315, y: 57, width: 44, height: 44))
            photoImage.image = UIImage(named: "findCargo")
            photoImage.backgroundColor = UIColor.clear
            borderView.addSubview(photoImage)
            //货物描述
            let weigthImage = UIImageView(frame: CGRect(x: 108, y: 59, width: 18, height: 18))
            weigthImage.backgroundColor = UIColor.clear
            weigthImage.image = UIImage(named:"findCargo")
            borderView.addSubview(weigthImage)
            let carTypeImage = UIImageView(frame: CGRect(x: 108, y: 86, width: 18, height: 18))
            carTypeImage.backgroundColor = UIColor.clear
            carTypeImage.image = UIImage(named: "findCargo")
            borderView.addSubview(carTypeImage)
            let weightLabel = UILabel(frame: CGRect(x: 135, y: 59, width: 70, height: 24))
            weightLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
            weightLabel.textAlignment = NSTextAlignment.left
            weightLabel.text = "234"
            borderView.addSubview(weightLabel)
            let carTypeLabel = UILabel(frame: CGRect(x: 135, y: 83, width: 70, height: 24))
            carTypeLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
            carTypeLabel.textAlignment = NSTextAlignment.left
            carTypeLabel.text = "12313"
            borderView.addSubview(carTypeLabel)
        }
        findCargoListView.contentSize = CGSize(width: 375, height: srollerView+viewHeight+20)
    }
    
    func menu(dopMenu menu: DOPDropDownMenu, numberOfRowsInColumn column: Int) -> Int {
        if column == 0 {
            return sorts.count
        } else if column == 1 {
            return sifts.count
        } else if column == 2 {
            return sorts.count
        } else {
            return sorts.count
        }
    }
    
    func menu(dopMenu menu: DOPDropDownMenu, titleForRowAtIndexPath indexPath: DOPIndexPath) -> String {
        if indexPath.column == 0 {
            return sorts[indexPath.row!]
        } else if indexPath.column == 1 {
            return sifts[indexPath.row!]
        } else if indexPath.column == 2 {
            return sorts[indexPath.row!]
        } else {
            return sorts[indexPath.row!]
        }
    }
    
    //new datasource
    func menu(dopMenu menu: DOPDropDownMenu, imageNameForRowAtIndexPath indexPath: DOPIndexPath) -> String {
        if indexPath.column == 1 {
            if let num = indexPath.row {
                return "ic_filter_category_\(num)"
            }
            
        }
//        else if indexPath.column == 0 {
//            return imgArr[indexPath.row!]
//        }
        return ""
    }
    
    func menu(dopMenu menu: DOPDropDownMenu, imageNameForItemsInRowAtIndexPath indexPath: DOPIndexPath) -> String {
//        if indexPath.column == 0 {
//            if let num = indexPath.row {
//                return "ic_filter_category_\(num)"
//            }
//        }
        return ""
    }
    
    func menu(dopMenu menu: DOPDropDownMenu, detailTextForRowAtIndexPath indexPath: DOPIndexPath) -> String {
        return String()
    }
    
    func menu(dopMenu menu: DOPDropDownMenu, detailTextForItemsInRowAtIndexPath indexPath: DOPIndexPath) -> String {
        return String()
    }
    //判断是否有二级菜单
    func menu(dopMenu menu: DOPDropDownMenu, numberOfItemsInRow row: Int, column: Int) -> Int {
//        if column == 1 {
//            if row == 0 {
//                return cates.count
//            } else if row == 1 {
//                return movices.count
//            } else if row == 2 {
//                return hotels.count
//            }
//        }
        return 0
    }
    //二级菜单返回
    func menu(dopMenu menu: DOPDropDownMenu, titleForItemsInRowAtIndexPath indexPath: DOPIndexPath) -> String {
//        if indexPath.column == 1 {
//            if indexPath.row == 0 {
//                return cates[indexPath.item!]
//            } else if indexPath.row == 1 {
//                return movices[indexPath.item!]
//            } else if indexPath.row == 2 {
//                return hotels[indexPath.item!]
//            }
//        }
        return "没有"
    }
    
    func menu(_ menu: DOPDropDownMenu, didSelectRowAtIndexPath indexPath: DOPIndexPath) {
        if indexPath.item! > 0 {
            print("点击了第\(indexPath.column)列 - 第\(indexPath.row)行 - 第\(indexPath.item)项")
        } else {
            print("点击了第\(indexPath.column)列 - 第\(indexPath.row)行")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
